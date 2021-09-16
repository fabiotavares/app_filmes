import 'package:app_filmes/application/rest_client/rest_client.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import './movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final RestClient _restClient;

  MoviesRepositoryImpl({
    required RestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    //
    final result = await _restClient.get<List<MovieModel>>(
      '/movie/popular',
      query: {
        // sempre um mapa de string string
        'api_key': RemoteConfig.instance.getString('api_token'),
        'language': 'pt-br',
        'page': '1',
      },
      decoder: (data) {
        final results = data['results'];

        if (results != null) {
          return results.map<MovieModel>((m) => MovieModel.fromMap(m)).toList();
        }
        return <MovieModel>[];
      },
    );

    // o GetConect não lança nenhuma excessão
    // ele alimenta esse hasError
    if (result.hasError) {
      print('Erro ao buscar filmes populares:');
      print(result.statusText);
      throw Exception('Erro ao buscar populares');
    }

    return result.body ?? <MovieModel>[];
  }

  @override
  Future<List<MovieModel>> getTopRated() async {
    //
    final result = await _restClient.get<List<MovieModel>>(
      '/movie/top_rated',
      query: {
        // sempre um mapa de string string
        'api_key': RemoteConfig.instance.getString('api_token'),
        'language': 'pt-br',
        'page': '1',
      },
      decoder: (data) {
        final results = data['results'];

        if (results != null) {
          return results.map<MovieModel>((m) => MovieModel.fromMap(m)).toList();
        }
        return <MovieModel>[];
      },
    );

    // o GetConect não lança nenhuma excessão
    // ele alimenta esse hasError
    if (result.hasError) {
      print('Erro ao buscar filmes top rated:');
      print(result.statusText);
      throw Exception('Erro ao buscar top rated');
    }

    return result.body ?? <MovieModel>[];
  }
}

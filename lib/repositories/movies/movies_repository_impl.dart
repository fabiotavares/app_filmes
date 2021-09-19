import 'package:app_filmes/application/rest_client/rest_client.dart';
import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Future<MovieDetailModel?> getDetail(int id) async {
    final result = await _restClient.get<MovieDetailModel?>(
      '/movie/$id',
      query: {
        'api_key': RemoteConfig.instance.getString('api_token'),
        'language': 'pt-br',
        'append_to_response': 'images,credits',
        'include_image_language': 'en,pt-br',
      },
      decoder: (data) {
        // converte o mapa recebido em um objeto MovieDetailModel
        return MovieDetailModel.fromMap(data);
      },
    );

    if (result.hasError) {
      print('Erro ao buscar detalhes do filme:');
      print(result.statusText);
      throw Exception('Erro ao buscar detalhes do filme');
    }

    return result.body;
  }

  @override
  Future<void> addOrRemoveFavorite(String userId, MovieModel movie) async {
    try {
      var favoriteCollection = FirebaseFirestore.instance.collection('favorities').doc(userId).collection('movies');

      if (movie.favorite) {
        favoriteCollection.add(movie.toMap());
      } else {
        var favoriteData = await favoriteCollection.where('id', isEqualTo: movie.id).limit(1).get();
        favoriteData.docs.first.reference.delete();
        // se existissem diversos, eu faria assim:
        // var docs = favoriteData.docs;
        // for (var doc in docs) {
        //   doc.reference.delete();
        // }
      }
    } catch (e, s) {
      print('Erro ao atualizar favorito no firebase');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> getFavoritiesMovies(String userId) async {
    try {
      var favoriteMovies =
          await FirebaseFirestore.instance.collection('favorities').doc(userId).collection('movies').get();

      final listFavorites = <MovieModel>[];
      for (var movie in favoriteMovies.docs) {
        listFavorites.add(MovieModel.fromMap(movie.data()));
      }
      return listFavorites;
    } catch (e, s) {
      print('Erro ao uscar lista de favoritos no firebase');
      print(e);
      print(s);
      rethrow;
    }
  }
}

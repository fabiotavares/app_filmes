import 'package:app_filmes/application/rest_client/rest_client.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import './genres_repository.dart';

class GenresRepositoryImpl implements GenresRepository {
  final RestClient _restClient;

  GenresRepositoryImpl({
    required RestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<List<GenreModel>> getGenres() async {
    // buscando resultados na API
    final result = await _restClient.get<List<GenreModel>>(
      // url final para esta requisição
      '/genre/movie/list',
      // passando o id token de acesso à api (guardado no RemoteConfig do Firebase)
      query: {
        'api_key': RemoteConfig.instance.getString('api_token'),
        'language': 'pt-br',
      },
      // processando o resultado obtido
      decoder: (data) {
        // pegando o array da chave genres (ver dicumentação da API)
        final resultData = data['genres'];
        // convertendo cada mapa recebido no array para um objeto
        if (resultData != null) {
          return resultData.map<GenreModel>((g) => GenreModel.fromMap(g)).toList();
        }
        return <GenreModel>[];
      },
    );

    // o GetConect não lança nenhuma excessão
    // ele alimenta esse hasError
    if (result.hasError) {
      print('Erro ao buscar Genres:');
      print(result.statusText);
      throw Exception('Erro ao buscar Genres');
    }

    return result.body ?? <GenreModel>[];
  }
}

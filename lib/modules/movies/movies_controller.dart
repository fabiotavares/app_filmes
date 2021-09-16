import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';

import 'package:app_filmes/services/genres/genres_service.dart';

class MoviesController extends GetxController with MessagesMixin {
  final GenresService _genresService;
  final MoviesService _moviesService;

  final _message = Rxn<MessageModel>();
  final genres = <GenreModel>[].obs;

  final popularMovies = <MovieModel>[].obs;
  final topRatedMovies = <MovieModel>[].obs;

  final _popularMoviesOriginal = <MovieModel>[];
  final _topRatedMoviesOriginal = <MovieModel>[];

  MoviesController({required GenresService genresService, required MoviesService moviesService})
      : _genresService = genresService,
        _moviesService = moviesService;

  @override
  void onInit() {
    super.onInit();
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    try {
      // buscando os gêneros
      final genresData = await _genresService.getGenres();
      // substitui todos os genres existentes pelos novos
      // isso é uma extensão em List criada pelo getx
      genres.assignAll(genresData);

      // buscando filmes
      final popularesData = await _moviesService.getPopularMovies();
      final topRatedData = await _moviesService.getTopRated();

      popularMovies.assignAll(popularesData);
      topRatedMovies.assignAll(topRatedData);
    } catch (e, s) {
      print('Erros ao carregar dados da página Movies:');
      print(e);
      print(s);
      // só de alterar a messega já é suficiente para uma mensagem ser exibida
      _message(MessageModel.error(title: 'Erro', message: 'Erro ao carregar dados da página'));
    }
  }
}

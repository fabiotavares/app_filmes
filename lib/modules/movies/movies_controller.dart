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

  var _popularMoviesOriginal = <MovieModel>[];
  var _topRatedMoviesOriginal = <MovieModel>[];

  final genreSelected = Rxn<GenreModel>();

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
      _popularMoviesOriginal = popularesData;

      topRatedMovies.assignAll(topRatedData);
      _topRatedMoviesOriginal = topRatedData;
    } catch (e, s) {
      print('Erros ao carregar dados da página Movies:');
      print(e);
      print(s);
      // só de alterar a messega já é suficiente para uma mensagem ser exibida
      _message(MessageModel.error(title: 'Erro', message: 'Erro ao carregar dados da página'));
    }
  }

  void filterByName(String title) {
    if (title.isNotEmpty) {
      // filtra nos valores originais
      var newPopularMovies =
          _popularMoviesOriginal.where((movie) => movie.title.toLowerCase().contains(title.toLowerCase())).toList();

      var newTopRatedMovies =
          _topRatedMoviesOriginal.where((movie) => movie.title.toLowerCase().contains(title.toLowerCase())).toList();

      popularMovies.assignAll(newPopularMovies);
      topRatedMovies.assignAll(newTopRatedMovies);
    } else {
      // volta para todos os valores originais
      popularMovies.assignAll(_popularMoviesOriginal);
      topRatedMovies.assignAll(_topRatedMoviesOriginal);
    }
  }

  void filterByGenre(GenreModel? genreModel) {
    var genreFilter = genreModel;

    // se o gênero passado já for igual ao selecionado, significa que foi um segundo clique seguido => tira o filtro
    if (genreFilter?.id == genreSelected.value?.id) {
      genreFilter = null;
    }

    genreSelected.value = genreFilter;

    if (genreFilter != null) {
      // aplica o filtro nas listas
      var newPopularMovies = _popularMoviesOriginal.where((movie) => movie.genres.contains(genreFilter?.id)).toList();
      var newTopRatedMovies = _topRatedMoviesOriginal.where((movie) => movie.genres.contains(genreFilter?.id)).toList();

      popularMovies.assignAll(newPopularMovies);
      topRatedMovies.assignAll(newTopRatedMovies);
    } else {
      // volta para todos os valores originais
      popularMovies.assignAll(_popularMoviesOriginal);
      topRatedMovies.assignAll(_topRatedMoviesOriginal);
    }
  }
}

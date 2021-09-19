import 'package:app_filmes/application/auth/auth_service.dart';
import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';

import 'package:app_filmes/services/genres/genres_service.dart';

class MoviesController extends GetxController with MessagesMixin {
  final GenresService _genresService;
  final MoviesService _moviesService;
  final AuthService _authService;

  final _message = Rxn<MessageModel>();
  final genres = <GenreModel>[].obs;

  final popularMovies = <MovieModel>[].obs;
  final topRatedMovies = <MovieModel>[].obs;

  var _popularMoviesOriginal = <MovieModel>[];
  var _topRatedMoviesOriginal = <MovieModel>[];

  final genreSelected = Rxn<GenreModel>();

  MoviesController({
    required GenresService genresService,
    required MoviesService moviesService,
    required AuthService authService,
  })  : _genresService = genresService,
        _moviesService = moviesService,
        _authService = authService;

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
      await getMovies();
    } catch (e, s) {
      print('Erros ao carregar dados da página Movies:');
      print(e);
      print(s);
      // só de alterar a messega já é suficiente para uma mensagem ser exibida
      _message(MessageModel.error(title: 'Erro', message: 'Erro ao carregar dados da página'));
    }
  }

  Future<void> getMovies() async {
    // buscando filmes
    try {
      var popularesData = await _moviesService.getPopularMovies();
      var topRatedData = await _moviesService.getTopRated();
      final favorites = await getFavorites();

      // atualizando os objetos de filmes com relação a ser favorito ou não
      popularesData = popularesData.map((m) => m.copyWith(favorite: favorites.containsKey(m.id))).toList();
      topRatedData = topRatedData.map((m) => m.copyWith(favorite: favorites.containsKey(m.id))).toList();

      popularMovies.assignAll(popularesData);
      _popularMoviesOriginal = popularesData;

      topRatedMovies.assignAll(topRatedData);
      _topRatedMoviesOriginal = topRatedData;
    } catch (e, s) {
      print('Erro ao buscar filmes no servidor:');
      print(e);
      print(s);
      // só de alterar a messega já é suficiente para uma mensagem ser exibida
      _message(MessageModel.error(title: 'Erro', message: 'Erro ao buscar filmes no servidor'));
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

  Future<void> favoriteMovie(MovieModel movie) async {
    final user = _authService.user;
    if (user != null) {
      var newMovie = movie.copyWith(favorite: !movie.favorite);
      await _moviesService.addOrRemoveFavorite(user.uid, newMovie);
      await getMovies();
    }
  }

  Future<Map<int, MovieModel>> getFavorites() async {
    // este mapa servirá para descobrir mais fácil de determinado filme está favoritado
    // se sua chave existir, então está favoritado
    // isso evita ter de buscar sempre uma lista para atualizar a tela
    var user = _authService.user;
    if (user != null) {
      final favorites = await _moviesService.getFavoritiesMovies(user.uid);
      // olha que jogada de dart legal
      return <int, MovieModel>{
        for (var fav in favorites) fav.id: fav,
      };
    }
    return {};
  }
}

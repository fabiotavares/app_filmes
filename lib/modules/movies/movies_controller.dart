import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:get/get.dart';

import 'package:app_filmes/services/genres/genres_service.dart';

class MoviesController extends GetxController with MessagesMixin {
  final GenresService _genresService;
  final _message = Rxn<MessageModel>();
  final genres = <GenreModel>[].obs;

  MoviesController({
    required GenresService genresService,
  }) : _genresService = genresService;

  @override
  void onInit() {
    super.onInit();
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    // buscando os gêneros
    try {
      final newGenres = await _genresService.getGenres();
      // substitui todos os genres existentes pelos novos
      // isso é uma extensão em List criada pelo getx
      genres.assignAll(newGenres);
    } catch (e) {
      // só de alterar a messega já é suficiente para uma mensagem ser exibida
      _message(MessageModel.error(title: 'Erro', message: 'Erro ao buscar categorias'));
    }
  }
}

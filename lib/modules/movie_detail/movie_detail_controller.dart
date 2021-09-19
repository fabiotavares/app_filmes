import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:get/get.dart';

import 'package:app_filmes/application/ui/loader/loader_mixin.dart';
import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/services/movies/movies_service.dart';

class MovieDetailController extends GetxController with LoaderMixin, MessagesMixin {
  final MoviesService _moviesService;

  var loading = false.obs;
  var message = Rxn<MessageModel>();
  var movie = Rxn<MovieDetailModel>();

  MovieDetailController({
    required MoviesService moviesService,
  }) : _moviesService = moviesService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(loading);
    messageListener(message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    // pegando o id enviado como argumento
    try {
      final movieId = Get.arguments;
      // buscando detalhes do filme
      loading(true);
      final movieDetailData = await _moviesService.getDetail(movieId);
      movie.value = movieDetailData;
      loading(false);
    } catch (e, s) {
      print('Erro ao buscar detalhes do filme');
      print(e);
      print(s);
      loading(false);
      message(MessageModel.error(title: 'Erro', message: 'Erro ao buscar detalhes do filme'));
    }
  }
}

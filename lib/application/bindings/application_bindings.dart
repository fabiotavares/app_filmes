import 'package:app_filmes/application/auth/auth_service.dart';
import 'package:app_filmes/application/rest_client/rest_client.dart';
import 'package:app_filmes/repositories/login/login_repository.dart';
import 'package:app_filmes/repositories/login/login_repository_impl.dart';
import 'package:app_filmes/repositories/movies/movies_repository.dart';
import 'package:app_filmes/repositories/movies/movies_repository_impl.dart';
import 'package:app_filmes/services/login/login_service.dart';
import 'package:app_filmes/services/login/login_service_impl.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:app_filmes/services/movies/movies_service_impl.dart';
import 'package:get/get.dart';

// bindings de uso  mais geral e que podem ser acessados pela aplicação como um todo
class ApplicationBindings implements Bindings {
  @override
  void dependencies() {
    // fenix: impede o Get de matar essa instância ao sair de algum módulo que o utilizou
    // no Get.put seria o atributo permanent
    // executando métodos e instanciando classes básicas necessárias ao funcionamento do app...
    Get.lazyPut(() => RestClient(), fenix: true);
    Get.lazyPut<LoginRepository>(() => LoginRepositoryImpl(), fenix: true);
    Get.lazyPut<LoginService>(() => LoginServiceImpl(loginRepository: Get.find()), fenix: true);
    Get.put(AuthService()).init();
    Get.lazyPut<MoviesRepository>(() => MoviesRepositoryImpl(restClient: Get.find()), fenix: true);
    Get.lazyPut<MoviesService>(() => MoviesServiceImpl(moviesRepository: Get.find()), fenix: true);
  }
}

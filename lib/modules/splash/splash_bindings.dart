import 'package:app_filmes/modules/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBindings implements Bindings {
  @override
  void dependencies() {
    // instancia todas as depend6encias da página
    Get.put(SplashController());
  }
}

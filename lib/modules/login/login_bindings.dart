import 'package:app_filmes/modules/login/login_controller.dart';
import 'package:get/get.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    // lazyPut adiciona uma intenção, concretizada na primeira vez que ofr preciso
    Get.lazyPut(() => LoginController(loginService: Get.find()));
  }
}

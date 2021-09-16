// serviço de autenticação usado em todo o app

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  // GetxService não é disposável (não tem dispose), parecido com o atributo fenix=true
  // só morre quando o app encerrar
  // será inicializado no application_bindings.dart

  User? user;

  void init() {
    // ficar escutando alterações de autenticação
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      this.user = user;

      if (user == null) {
        // não está logado => vai pra tela de login
        Get.offAllNamed('/login');
      } else {
        Get.offAllNamed('/home');
      }
    });
  }
}

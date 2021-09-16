import 'package:get/get.dart';

import 'package:app_filmes/application/ui/loader/loader_mixin.dart';
import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/services/login/login_service.dart';

class LoginController extends GetxController with LoaderMixin, MessagesMixin {
  // exemplos:
  // var nome = Rx<String>('Fábio tavares');
  // var nome = RxString('Fábio tavares');
  // var nome = 'Fábio tavares'.obs;
  // nome.value = 'Academia do Flutter';
  final loading = false.obs;
  final message = Rxn<MessageModel>();

  // service (ver explicação em login_service_impl.dart)
  final LoginService _loginService;

  LoginController({
    required LoginService loginService,
  }) : _loginService = loginService;

  // ativando a função de loader
  @override
  void onInit() {
    super.onInit();
    loaderListener(loading);
    messageListener(message);
  }

  Future<void> login() async {
    // exemplos:
    // testando o loader
    // loading.value = true;
    // loading(true);
    // // await Future.delayed(const Duration(seconds: 2));
    // await 1.seconds.delay();
    // // loading.value = false;
    // loading(false);
    // message(MessageModel.error(title: 'Erro', message: 'Mensagem de erro'));
    // await 4.seconds.delay();
    // message(MessageModel.info(title: 'Atenção', message: 'Mensagem de info'));

    // Fazendo o login
    try {
      loading(true);
      await _loginService.login();
      loading(false);
      message(MessageModel.info(title: 'Sucesso', message: 'Login realizado com sucesso!'));
    } catch (e, s) {
      printError(info: e.toString());
      printError(info: s.toString());
      loading(false);
      message(MessageModel.error(title: 'Erro', message: 'Erro ao realizar login com o Google'));
    }
  }
}

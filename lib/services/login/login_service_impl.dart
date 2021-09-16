import 'package:firebase_auth/firebase_auth.dart';

import 'package:app_filmes/repositories/login/login_repository.dart';

import './login_service.dart';

class LoginServiceImpl implements LoginService {
  // sempre passar o repository por parâmetro no construtor
  // até poderia usar o Get para recuperar essa instância,
  // mas isso não seria uma boa prática devido aos testes unitários
  // o fator de ser uma atributo privado, é para impedir acesso direto ao repository sem passar pelo service
  final LoginRepository _loginRepository;

  LoginServiceImpl({
    required LoginRepository loginRepository,
  }) : _loginRepository = loginRepository;

  @override
  Future<UserCredential> login() => _loginRepository.login();

  @override
  Future<void> logout() => _loginRepository.logout();
}

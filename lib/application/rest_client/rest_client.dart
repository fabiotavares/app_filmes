import 'package:get/get_connect.dart';

class RestClient extends GetConnect {
  RestClient() {
    // se houvessem vários servidores, não poderia usar esse baseUrl (teria que ser dinâmico)
    httpClient..baseUrl = 'https://api.themoviedb.org/3';
  }
}

import 'package:app_filmes/application/bindings/application_bindings.dart';
import 'package:app_filmes/application/ui/filmes_app_ui_config.dart';
import 'package:app_filmes/modules/home/home_module.dart';
import 'package:app_filmes/modules/login/login_module.dart';
import 'package:app_filmes/modules/movie_detail/movie_detail_module.dart';
import 'package:app_filmes/modules/splash/splash_module.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';

Future<void> main() async {
  // inicializando o firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // habilitando o remote config do firebase
  RemoteConfig.instance.fetchAndActivate();
  // -----------------------------------------
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [SystemUiOverlay.top]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: FilmesAppUiConfig.title,
      theme: FilmesAppUiConfig.theme,
      debugShowCheckedModeBanner: false,
      // definindo os bindings que devem ser permanentes na aplicação (não morrem)
      initialBinding: ApplicationBindings(),
      getPages: [
        ...SplashModule().routers,
        ...LoginModule().routers,
        ...HomeModule().routers,
        ...MovieDetailModule().routers,
      ],
    );
  }
}

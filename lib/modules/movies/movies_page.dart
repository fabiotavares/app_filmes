import 'package:app_filmes/modules/movies/movies_controller.dart';
import 'package:app_filmes/modules/movies/widgets/movies_filters.dart';
import 'package:app_filmes/modules/movies/widgets/movies_group.dart';
import 'package:app_filmes/modules/movies/widgets/movies_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MoviesPage extends GetView<MoviesController> {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            MoviesHeader(),
            MoviesFilters(),
            MoviesGroup(
              title: 'Mais Populares',
              movies: controller.popularMovies,
            ),
            MoviesGroup(
              title: 'Top Filmes',
              movies: controller.topRatedMovies,
            ),
          ],
        ),
      ),
    );
  }
}

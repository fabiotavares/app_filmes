import 'package:app_filmes/modules/movies/widgets/movies_filters.dart';
import 'package:app_filmes/modules/movies/widgets/movies_group.dart';
import 'package:app_filmes/modules/movies/widgets/movies_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MoviesPage extends StatelessWidget {
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
            MoviesGroup(title: 'Mais Populares'),
            MoviesGroup(title: 'Top Filmes'),
          ],
        ),
      ),
    );
  }
}

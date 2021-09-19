import 'package:app_filmes/application/ui/widgets/movie_card.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:app_filmes/modules/movies/movies_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoviesGroup extends GetView<MoviesController> {
  final String title;
  final List<MovieModel> movies;

  const MoviesGroup({Key? key, required this.title, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            // para evitar erro de uma altura indefinida
            height: 280,

            child: Obx(() {
              return ListView.builder(
                // para evitar erro por estar dentro de uma column
                shrinkWrap: true,
                // physics: PageScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(
                    movie: movie,
                    favoriteCallback: () => controller.favoriteMovie(movie),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

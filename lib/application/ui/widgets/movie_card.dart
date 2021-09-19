import 'package:app_filmes/application/ui/filmes_app_icons_icons.dart';
import 'package:app_filmes/application/ui/theme_extensions.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MovieCard extends StatelessWidget {
  // final dateFormat = DateFormat('dd/MM/y');
  final dateFormat = DateFormat('y');
  final MovieModel movie;
  final VoidCallback favoriteCallback;

  MovieCard({Key? key, required this.movie, required this.favoriteCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/movie/detail', arguments: movie.id),
      child: Container(
        width: 158,
        height: 280,
        child: Stack(
          children: [
            // nova forma de colocar bordas arredondadas
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      // tirando um pouco do serrilhado das bordas arredondadas
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                        width: 148,
                        height: 184,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    movie.title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    // se o texto for muito grande, mostra parcialmente
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    dateFormat.format(DateTime.parse(movie.releaseDate)),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 90,
              right: -8,
              child: Material(
                elevation: 5,
                //borderRadius: BorderRadius.circular(100),
                shape: CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: 30,
                  child: IconButton(
                    iconSize: 13,
                    icon: Icon(
                      movie.favorite ? FilmesAppIcons.heart : FilmesAppIcons.heart_empty,
                      color: movie.favorite ? context.themeRed : Colors.grey,
                    ),
                    onPressed: favoriteCallback,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

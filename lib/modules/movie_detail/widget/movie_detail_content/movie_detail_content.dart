import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:app_filmes/modules/movie_detail/widget/movie_detail_content/movie_detail_content_main_cast.dart';
import 'package:app_filmes/modules/movie_detail/widget/movie_detail_content/movie_detail_content_credits.dart';
import 'package:app_filmes/modules/movie_detail/widget/movie_detail_content/movie_detail_content_production_companies.dart';
import 'package:app_filmes/modules/movie_detail/widget/movie_detail_content/movie_detail_content_title.dart';
import 'package:flutter/material.dart';

class MovieDetailContent extends StatelessWidget {
  final MovieDetailModel? movie;

  const MovieDetailContent({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // criando uma variável local para ter a auto-promoção de nulos
    final movieData = movie;
    if (movieData != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieDetailContentTitle(movie: movie),
          MovieDetailContentCredits(movie: movie),
          MovieDetailContentProductionCompanies(movie: movie),
          MovieDetailContentMainCast(movie: movie),
        ],
      );
    }

    // se for nulo retorna um componente bem pequeno (quase nulo)
    return SizedBox.shrink();
  }
}

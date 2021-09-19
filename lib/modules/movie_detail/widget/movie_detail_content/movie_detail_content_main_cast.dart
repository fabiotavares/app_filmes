import 'package:app_filmes/application/ui/theme_extensions.dart';
import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:app_filmes/modules/movie_detail/widget/movie_detail_content/movie_detail_content_cast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MovieDetailContentMainCast extends StatelessWidget {
  final MovieDetailModel? movie;
  // criando um observável aqui por ser algo muito simples e não valer a pena criar uma controller só pra isso
  final showPanel = false.obs;

  MovieDetailContentMainCast({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: context.themeGrey),
        // criando um mais que expande através do clique em uma seta
        Obx(() {
          return ExpansionPanelList(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (panelIndex, isExpanded) {
              // invertendo o valor de showPanel (legal - já tem pronto)
              showPanel.toggle();
            },
            children: [
              ExpansionPanel(
                  canTapOnHeader: false,
                  isExpanded: showPanel.value,
                  backgroundColor: Colors.white,
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Elenco',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                  body: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: movie?.cast.map((c) => MovieDetailContentCast(cast: c)).toList() ?? const [],
                    ),
                  ))
            ],
          );
        }),
      ],
    );
  }
}

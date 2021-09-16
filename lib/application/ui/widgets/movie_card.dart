import 'package:app_filmes/application/ui/filmes_app_icons_icons.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      'https://upload.wikimedia.org/wikipedia/pt/thumb/6/63/Joker_%282019%29.jpg/250px-Joker_%282019%29.jpg',
                      width: 148,
                      height: 184,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Coringa',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  // se o texto for muito grande, mostra parcialmente
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  '2019',
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
                    FilmesAppIcons.heart_empty,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

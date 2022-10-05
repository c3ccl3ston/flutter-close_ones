import 'package:closeones_app/views/game_card.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

import '../data_types/game.dart';
import '../data_types/week.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({super.key, required this.games, required this.week});

  final List<Game> games;
  final Week week;

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Text(
                      "No games for this week!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                    ),
                  )),
            ),
          ),
        ],
      ));
    }

    int numColumns = 1;
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 550 && screenWidth <= 1080) {
      numColumns = 2;
    } else if (screenWidth > 1080) {
      numColumns = 3;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: DynamicHeightGridView(
        itemCount: games.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        builder: (context, index) {
          return GameCard(game: games[index]);
        },
        crossAxisCount: numColumns,
      ),
    );
  }
}

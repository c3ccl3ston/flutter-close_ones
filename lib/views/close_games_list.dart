import 'package:closeones_app/views/skeleton_games.dart';

import '../data_types/week.dart';
import 'package:flutter/material.dart';

import '../data_types/game.dart';
import 'games.dart';
import '../utils/utils.dart';

class CloseGamesList extends StatefulWidget {
  final int week;
  final String season;
  final String seasonType;
  final bool shouldCache;

  const CloseGamesList(
      {super.key,
      required this.week,
      required this.season,
      required this.seasonType,
      required this.shouldCache});

  @override
  CloseGamesListState createState() {
    return CloseGamesListState();
  }
}

class CloseGamesListState extends State<CloseGamesList> with RestorationMixin {
  final RestorableBool _isRestored = RestorableBool(false);

  Future<List<Game>> _getGames() async {
    return Utils().fetchGames(
        widget.season, widget.seasonType, widget.week, widget.shouldCache);
  }

  String _getSeasonHeader(int year, String seasonType) {
    if (seasonType == 'postseason') {
      return "$year";
    }
    return "$year Regular Season";
  }

  String _getWeekHeader(int week, String seasonType) {
    if (seasonType == 'postseason') {
      return "Bowls";
    }
    return "Week $week";
  }

  bool isRefreshing = false;

  Future<void> _pullToRefresh() async {
    await _getGames();
    setState(() {
      isRefreshing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () {
          isRefreshing = true;
          return _pullToRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            Column(key: const ValueKey("Games Header"), children: [
              Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Column(children: [
                    Text(
                      _getSeasonHeader(
                          int.parse(widget.season), widget.seasonType),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      _getWeekHeader(widget.week, widget.seasonType),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.onSurface),
                    )
                  ]))
            ]),
            FutureBuilder<List<Game>>(
              key: const ValueKey("GamesList"),
              future: _getGames(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.waiting:
                    if (!isRefreshing) {
                      return const SkeletonGamesList();
                    } else {
                      isRefreshing = false;
                      continue games;
                    }
                  case ConnectionState.active:
                    return const Center(child: CircularProgressIndicator());
                  games:
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("ERROR: ${snapshot.error}"),
                      );
                    } else {
                      return Games(
                          key: const ValueKey("Games"),
                          games: snapshot.data!,
                          week: Week(
                              season: widget.season,
                              seasonType: widget.seasonType,
                              week: widget.week));
                    }
                }
              },
            ),
          ]),
        ));
  }

  @override
  String? get restorationId => "games_list";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_isRestored, "isRestored");
  }
}

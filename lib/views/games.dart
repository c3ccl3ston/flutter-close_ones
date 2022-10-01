import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_types/game.dart';
import '../data_types/week.dart';

class Games extends StatelessWidget {
  const Games({super.key, required this.games, required this.week});

  final List<Game> games;
  final Week week;

  Widget _listItem(i, context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Card(
          borderOnForeground: true,
          clipBehavior: Clip.hardEdge,
          elevation: 5,
          child: InkWell(
            onTap: () => {},
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer),
                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                  child: Text(
                    DateFormat("E MMM d, yyyy").format(games[i].startDate),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 14),
                  ),
                ),
                Stack(
                  children: [
                    Positioned(
                        left: 20,
                        top: 15,
                        child: Text(
                          games[i].awayRank! == 0
                              ? ""
                              : games[i].awayRank!.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w200),
                        )),
                    Positioned(
                        right: 20,
                        top: 15,
                        child: Text(
                          games[i].homeRank! == 0
                              ? ""
                              : games[i].homeRank!.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w200),
                        )),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              "http://a.espncdn.com/i/teamlogos/ncaa/500${(Theme.of(context).brightness == Brightness.dark) ? '-dark' : ''}/${games[i].awayId}.png",
                                          // placeholder: (context, url) =>
                                          //     const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          width: 100,
                                          height: 100,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                              games[i].awayTeam.toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18)),
                                        )
                                      ],
                                    )),
                                Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: const [
                                        Text(
                                          "at",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              "http://a.espncdn.com/i/teamlogos/ncaa/500${(Theme.of(context).brightness == Brightness.dark) ? '-dark' : ''}/${games[i].homeId}.png",
                                          width: 100,
                                          height: 100,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                              games[i].homeTeam.toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18)),
                                        )
                                      ],
                                    )),
                              ]),
                        ),
                        if (games[i].notes != null) ...[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            padding: const EdgeInsets.only(bottom: 15, top: 15),
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              games[i].notes!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200, fontSize: 14),
                            ),
                          )
                        ]
                      ],
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

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

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      itemCount: games.length,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return _listItem(i, context);
      },
    );
  }
}

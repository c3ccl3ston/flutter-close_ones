import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_types/game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
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
                    DateFormat("E MMM d, yyyy").format(game.startDate),
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
                          game.awayRank! == 0 ? "" : game.awayRank!.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w200),
                        )),
                    Positioned(
                        right: 20,
                        top: 15,
                        child: Text(
                          game.homeRank! == 0 ? "" : game.homeRank!.toString(),
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
                                              "http://a.espncdn.com/i/teamlogos/ncaa/500${(Theme.of(context).brightness == Brightness.dark) ? '-dark' : ''}/${game.awayId}.png",
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
                                              game.awayTeam.toUpperCase(),
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
                                              "http://a.espncdn.com/i/teamlogos/ncaa/500${(Theme.of(context).brightness == Brightness.dark) ? '-dark' : ''}/${game.homeId}.png",
                                          width: 100,
                                          height: 100,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                              game.homeTeam.toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18)),
                                        )
                                      ],
                                    )),
                              ]),
                        ),
                        if (game.notes != null) ...[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            padding: const EdgeInsets.only(bottom: 15, top: 15),
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              game.notes!,
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
}

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/season.dart';
import '../models/game.dart';
import '../models/rankings.dart';

class Utils {
  Future<List<Season>> fetchSeasons(int year) async {
    final response = await http.get(
      Uri.parse("https://api.collegefootballdata.com/calendar?year=$year"),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: dotenv.env['API_KEY'] ?? "",
      },
    );

    return parseSeason(response.body);
  }

  Future<List<Game>> fetchGames(
      String season, String seasonType, int week, bool shouldCache) async {
    String gamesFileName = '$season$seasonType$week.json';

    String rankingsFileName = '$season$seasonType${week}rankings.json';

    var dir = await getTemporaryDirectory();
    File gamesFile = File('${dir.path}/$gamesFileName');
    File rankingsFile = File('${dir.path}/$rankingsFileName');

    if (gamesFile.existsSync() && rankingsFile.existsSync()) {
      // print('CACHE FILES: using cached files for $season Week $week');
      var gamesData = gamesFile.readAsStringSync();
      var rankingsData = rankingsFile.readAsStringSync();
      return compute(parseGames, [gamesData, rankingsData]);
    } else {
      // print('CACHE FILES: calling api for $season Week $week');
      final response = await http.get(
        Uri.parse(
            "https://api.collegefootballdata.com/games?year=$season&week=$week&seasonType=$seasonType&division=fbs"),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: dotenv.env['API_KEY'] ?? "",
        },
      );

      final rankingsResponse = await http.get(
        Uri.parse(
            "https://api.collegefootballdata.com/rankings?year=$season&week=$week&seasonType=$seasonType"),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: dotenv.env['API_KEY'] ?? "",
        },
      );

      List<String> responses = [response.body, rankingsResponse.body];

      if (shouldCache) {
        // saving to cache
        gamesFile.writeAsStringSync(response.body,
            flush: false, mode: FileMode.write);
        rankingsFile.writeAsStringSync(rankingsResponse.body,
            flush: false, mode: FileMode.write);
      }

      await Future.delayed(const Duration(milliseconds: 1000));

      return compute(parseGames, responses);
    }
  }

  List<Game> parseGames(List<String> responses) {
    final parsed = jsonDecode(responses.first).cast<Map<String, dynamic>>();

    List<Game> games = parsed.map<Game>((json) => Game.fromJson(json)).toList();

    List<Game> closeGames = <Game>[];

    final rankingsData =
        json.decode(responses.last).cast<Map<String, dynamic>>();

    HashMap rankingsMap = HashMap<String, int>();

    List<Rankings> rankings =
        rankingsData.map<Rankings>((json) => Rankings.fromJson(json)).toList();

    if (rankings.isNotEmpty) {
      List<Polls>? polls = rankings[0].polls;

      List<Ranks>? ranks = <Ranks>[];
      for (int i = 0; i < polls!.length; i++) {
        if (polls[i].poll == 'AP Top 25') {
          ranks = polls[i].ranks;
        }
      }

      for (int i = 0; i < ranks!.length; i++) {
        rankingsMap[ranks[i].school] = ranks[i].rank;
      }
    }

    for (int i = 0; i < games.length; i++) {
      if (games[i].awayPoints != null && games[i].homePoints != null) {
        if ((games[i].awayPoints! - games[i].homePoints!).abs() <= 10) {
          if (rankings.isNotEmpty) {
            games[i].setHomeRank(rankingsMap[games[i].homeTeam] ?? 0);
            games[i].setAwayRank(rankingsMap[games[i].awayTeam] ?? 0);
          }
          closeGames.add(games[i]);
        }
      }
    }

    closeGames.sort((a, b) => a.excitementIndex == null
        ? -1
        : b.excitementIndex == null
            ? -1
            : b.excitementIndex! > a.excitementIndex!
                ? 1
                : -1);

    return closeGames;
  }

  List<Season> parseSeason(String response) {
    final parsed = jsonDecode(response).cast<Map<String, dynamic>>();
    List<Season> list =
        parsed.map<Season>((json) => Season.fromJson(json)).toList();
    var s = <Season>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i].firstGameStart.isBefore(DateTime.now())) {
        if (list[i].seasonType == "regular" ||
            list[i].seasonType == "postseason") {
          s.add(list[i]);
        }
      }
    }
    return s.toList();
  }
}

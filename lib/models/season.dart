import 'week.dart';

class Season {
  String season;
  int week;
  String seasonType;
  DateTime firstGameStart;
  DateTime lastGameStart;
  List<Week> weeks;

  Season(
      {required this.season,
      required this.week,
      required this.seasonType,
      required this.firstGameStart,
      required this.lastGameStart,
      this.weeks = const []});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
        season: json['season'] as String,
        week: json['week'] as int,
        seasonType: json['seasonType'] as String,
        firstGameStart: DateTime.parse(json['firstGameStart']),
        lastGameStart: DateTime.parse(json['lastGameStart']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['season'] = season;
    data['week'] = week;
    data['seasonType'] = seasonType;
    data['firstGameStart'] = firstGameStart;
    data['lastGameStart'] = lastGameStart;
    return data;
  }
}

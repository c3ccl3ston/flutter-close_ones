class Season {
  Season(
      {required this.season,
      required this.week,
      required this.seasonType,
      required this.firstGameStart});

  String season;
  int week;
  String seasonType;
  DateTime firstGameStart;

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
        season: json['season'] as String,
        week: json['week'] as int,
        seasonType: json['seasonType'] as String,
        firstGameStart: DateTime.parse(json['firstGameStart']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['season'] = season;
    data['week'] = week;
    data['seasonType'] = seasonType;
    data['firstGameStart'] = firstGameStart;
    return data;
  }
}

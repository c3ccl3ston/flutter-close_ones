class Week {
  Week(
      {required this.season,
      required this.week,
      required this.seasonType,
      this.shouldCache = true});

  final String season;
  final int week;
  final String seasonType;
  String? label;
  bool shouldCache;

  factory Week.fromJson(Map<String, dynamic> json) {
    return Week(
        season: json['season'] as String,
        week: json['week'] as int,
        seasonType: json['seasonType'] as String);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['season'] = season;
    data['week'] = week;
    data['seasonType'] = seasonType;
    return data;
  }

  String getLabel() {
    if (seasonType == "postseason") return "Bowls";
    return 'Week $week';
  }

  @override
  bool operator ==(Object other) {
    return other is Week &&
        other.season == season &&
        other.seasonType == seasonType &&
        other.week == week;
  }

  @override
  int get hashCode => Object.hash(season, seasonType, week);
}

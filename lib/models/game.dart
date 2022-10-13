class Game {
  final int id;
  final int season;
  final int week;
  final String seasonType;
  final DateTime startDate;
  final int homeId;
  final String homeTeam;
  final int? homePoints;
  final int awayId;
  final String awayTeam;
  final int? awayPoints;
  final double? excitementIndex;
  final String? notes;
  int? homeRank;
  int? awayRank;

  Game(
      {required this.id,
      required this.season,
      required this.week,
      required this.seasonType,
      required this.startDate,
      required this.homeId,
      required this.homeTeam,
      this.homePoints,
      required this.awayId,
      required this.awayTeam,
      this.awayPoints,
      this.excitementIndex,
      this.notes,
      this.homeRank,
      this.awayRank});

  void setHomeRank(int rank) {
    homeRank = rank;
  }

  void setAwayRank(int rank) {
    awayRank = rank;
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
        id: json["id"],
        season: json["season"],
        week: json["week"],
        seasonType: json["season_type"],
        startDate: DateTime.parse(json["start_date"]),
        homeId: json["home_id"],
        homeTeam: json["home_team"],
        homePoints: json["home_points"],
        awayId: json["away_id"],
        awayTeam: json["away_team"],
        awayPoints: json["away_points"],
        excitementIndex: json["excitement_index"] == null
            ? 0
            : double.parse(json["excitement_index"]),
        notes: json["notes"],
        homeRank: json["home_rank"] ?? 0,
        awayRank: json["away_rank"] ?? 0);
  }
}

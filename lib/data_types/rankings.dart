class Rankings {
  int? season;
  String? seasonType;
  int? week;
  List<Polls>? polls;

  Rankings({this.season, this.seasonType, this.week, this.polls});

  Rankings.fromJson(Map<String, dynamic> json) {
    season = json['season'];
    seasonType = json['seasonType'];
    week = json['week'];
    if (json['polls'] != null) {
      polls = <Polls>[];
      json['polls'].forEach((v) {
        polls!.add(Polls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['season'] = season;
    data['seasonType'] = seasonType;
    data['week'] = week;
    if (polls != null) {
      data['polls'] = polls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Polls {
  String? poll;
  List<Ranks>? ranks;

  Polls({this.poll, this.ranks});

  Polls.fromJson(Map<String, dynamic> json) {
    poll = json['poll'];
    if (json['ranks'] != null) {
      ranks = <Ranks>[];
      json['ranks'].forEach((v) {
        ranks!.add(Ranks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['poll'] = poll;
    if (ranks != null) {
      data['ranks'] = ranks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ranks {
  int? rank;
  String? school;
  String? conference;
  int? firstPlaceVotes;
  int? points;

  Ranks(
      {this.rank,
      this.school,
      this.conference,
      this.firstPlaceVotes,
      this.points});

  Ranks.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    school = json['school'];
    conference = json['conference'];
    firstPlaceVotes = json['firstPlaceVotes'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['school'] = school;
    data['conference'] = conference;
    data['firstPlaceVotes'] = firstPlaceVotes;
    data['points'] = points;
    return data;
  }
}

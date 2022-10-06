import 'package:closeones_app/data_types/season.dart';
import 'package:closeones_app/views/drawer_options.dart';
import 'package:flutter/material.dart';

import '../data_types/week.dart';
import 'close_games_list.dart';
import '../utils/utils.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return HomepageState();
  }
}

class HomepageState extends State<Homepage> with RestorationMixin {
  List<Season> _seasons = <Season>[];

  final RestorableString _selectedYear = RestorableString("");

  final RestorableString selectedSeason = RestorableString("");
  final RestorableString selectedSeasonType = RestorableString("");
  final RestorableInt selectedWeek = RestorableInt(0);
  final RestorableBool shouldCacheWeek = RestorableBool(false);

  @override
  void initState() {
    super.initState();
    getWeeks();
  }

  _getCloseGamesList(Week w, context) {
    if (w.week != 0) {
      return CloseGamesList(
        season: w.season,
        seasonType: w.seasonType,
        week: w.week,
        shouldCache: w.shouldCache,
        key: null,
      );
    }
    return Center(
        child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onSurface));
  }

  _onSelectItem(Week w, context) {
    setState(() {
      selectedSeason.value = w.season;
      selectedSeasonType.value = w.seasonType;
      selectedWeek.value = w.week;
      shouldCacheWeek.value = w.shouldCache;
      _getCloseGamesList(w, context);
    });
    Navigator.of(context).pop(); // close the drawer
  }

  Future<void> getWeeks() async {
    List<Season> newSeasons = <Season>[];
    Week lastestWeek =
        Week(season: "", seasonType: "", week: 0, shouldCache: false);
    int index = 0;
    for (int i = DateTime.now().year; i >= (DateTime.now().year - 4); i--) {
      List<Season> season = await Utils().fetchSeasons(i);
      List<Week> weeks = <Week>[];

      for (int j = 0; j < season.length; j++) {
        Week w = Week(
            season: season[j].season,
            week: season[j].week,
            seasonType: season[j].seasonType);
        if (i == DateTime.now().year && j == season.length - 1) {
          lastestWeek = w;
        }

        w.shouldCache = (season[j].lastGameStart.add(const Duration(hours: 6)))
            .isBefore(DateTime.now());
        weeks.add(w);
      }
      newSeasons.add(season[index]);
      newSeasons[index++].weeks = weeks;
    }

    setState(() {
      _seasons = newSeasons;

      if (selectedWeek.value == 0) {
        selectedSeason.value = lastestWeek.season;
        selectedSeasonType.value = lastestWeek.seasonType;
        selectedWeek.value = lastestWeek.week;
        shouldCacheWeek.value = lastestWeek.shouldCache;
        _selectedYear.value = lastestWeek.season;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double drawerWidth = 0.0;
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 550) {
      drawerWidth = screenWidth;
    } else if (screenWidth > 550 && screenWidth <= 1080) {
      drawerWidth = screenWidth * .8;
    } else {
      drawerWidth = screenWidth * .4;
    }

    return Scaffold(
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(title: const Text("Close Ones"), centerTitle: true),
      drawer: Drawer(
        width: drawerWidth,
        child: Column(
          children: [
            AppBar(
              title: const Text(
                "Seasons",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    icon: const Icon(Icons.close))
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: DrawerOptions(
              seasons: _seasons,
              onSelectItem: _onSelectItem,
              selectedSeason: selectedSeason.value,
              selectedSeasonType: selectedSeasonType.value,
              selectedWeek: selectedWeek.value,
            )))
          ],
        ),
      ),
      body: _getCloseGamesList(
          Week(
              season: selectedSeason.value,
              seasonType: selectedSeasonType.value,
              week: selectedWeek.value,
              shouldCache: shouldCacheWeek.value),
          context),
    );
  }

  @override
  String? get restorationId => "home_screen";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedYear, "selected_year");
    registerForRestoration(selectedSeason, "week_season");
    registerForRestoration(selectedSeasonType, "week_seasonType");
    registerForRestoration(selectedWeek, "week_week");
    registerForRestoration(shouldCacheWeek, "week_latest");
  }
}

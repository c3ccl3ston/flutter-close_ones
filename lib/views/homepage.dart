import 'package:closeones_app/data_types/season.dart';
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

class HomepageState extends State<Homepage>
    with WidgetsBindingObserver, RestorationMixin {
  Map<int, List<Week>> _seasons = <int, List<Week>>{};

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
    Map<int, List<Week>> seasons = <int, List<Week>>{};
    Week lastestWeek =
        Week(season: "", seasonType: "", week: 0, shouldCache: false);
    for (int i = DateTime.now().year; i >= (DateTime.now().year - 5); i--) {
      List<Season> weeks = await Utils().fetchSeasons(i);
      List<Week> w1 = <Week>[];

      for (int j = 0; j < weeks.length; j++) {
        Week w = Week(
            season: weeks[j].season,
            week: weeks[j].week,
            seasonType: weeks[j].seasonType);
        if (i == DateTime.now().year && j == weeks.length - 1) {
          lastestWeek = w;
        }
        
        w.shouldCache = (weeks[j].lastGameStart.add(const Duration(hours: 6)).isBefore(DateTime.now());
        w1.add(w);
      }
      seasons[i] = w1;
    }

    setState(() {
      _seasons = seasons;

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
    List<Widget> expansionTiles = <Widget>[];

    _seasons.forEach((key, value) {
      List<Widget> cards = <Widget>[];
      for (var w in value) {
        cards.add(Card(
          elevation: 5,
          borderOnForeground: true,
          color: w ==
                  Week(
                      season: selectedSeason.value,
                      seasonType: selectedSeasonType.value,
                      week: selectedWeek.value)
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
              onTap: () => _onSelectItem(w, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          w.seasonType == "postseason"
                              ? "BOWLS"
                              : "WEEK\n${w.week}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14)),
                    ],
                  )),
                ],
              )),
        ));
      }
      Container g = Container(
        color: Theme.of(context).colorScheme.background,
        child: GridView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 85,
                childAspectRatio: 1 / 1.25,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10),
            children: cards),
      );

      expansionTiles.add(Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            textColor: Theme.of(context).colorScheme.onPrimaryContainer,
            title: Text('$key Season',
                style:
                    const TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
            initiallyExpanded:
                key.toString() == selectedSeason.value ? true : false,
            children: [g]),
      ));
    });

    Widget drawerOptions;

    if (expansionTiles.isNotEmpty) {
      drawerOptions = ListView.separated(
          itemBuilder: (context, index) {
            return expansionTiles[index];
          },
          itemCount: expansionTiles.length - 1,
          separatorBuilder: (context, index) =>
              const Divider(height: 0, thickness: 0),
          key: Key(selectedSeason.value),
          padding: const EdgeInsets.only(top: 0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics());
    } else {
      drawerOptions = Column(children: const [
        Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        )
      ]);
    }

    double drawerWidth = 0.0;
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 550) {
      drawerWidth = screenWidth;
    } else {
      drawerWidth = screenWidth * .4;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Close Ones")),
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
            Expanded(child: SingleChildScrollView(child: drawerOptions))
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

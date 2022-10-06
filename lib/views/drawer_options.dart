import 'package:flutter/material.dart';

import '../data_types/season.dart';
import '../data_types/week.dart';

class DrawerOptions extends StatefulWidget {
  final List<Season> seasons;
  final String selectedSeason;
  final String selectedSeasonType;
  final int selectedWeek;
  final Function(Week, BuildContext) onSelectItem;

  const DrawerOptions(
      {super.key,
      required this.seasons,
      required this.selectedSeason,
      required this.selectedSeasonType,
      required this.selectedWeek,
      required this.onSelectItem});

  @override
  State<DrawerOptions> createState() => _DrawerOptionsState();
}

class _DrawerOptionsState extends State<DrawerOptions> {
  final List<bool> _isExpanded = <bool>[];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.seasons.length; i++) {
      _isExpanded.add(
          widget.seasons[i].season == widget.selectedSeason ? true : false);
    }
    List<ExpansionPanel> expansionTiles = <ExpansionPanel>[];

    int count = 0;
    for (var season in widget.seasons) {
      List<Widget> cards = <Widget>[];
      for (var week in season.weeks) {
        cards.add(Card(
          elevation: 5,
          borderOnForeground: true,
          color: week ==
                  Week(
                      season: widget.selectedSeason,
                      seasonType: widget.selectedSeasonType,
                      week: widget.selectedWeek)
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).scaffoldBackgroundColor,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
              onTap: () => widget.onSelectItem(week, context),
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
                          week.seasonType == "postseason"
                              ? "BOWLS"
                              : "WEEK\n${week.week}",
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

      expansionTiles.add(ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            if (isExpanded) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Text('${season.season} Season',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 24)),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Text('${season.season} Season',
                  style: const TextStyle(
                      fontWeight: FontWeight.w200, fontSize: 22)),
            );
          },
          canTapOnHeader: true,
          backgroundColor: _isExpanded[count]
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          isExpanded: _isExpanded[count++],
          body: g));
    }

    if (expansionTiles.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.zero,
          animationDuration: const Duration(milliseconds: 500),
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              for (int i = 0; i < _isExpanded.length; i++) {
                _isExpanded[i] = false;
              }
              _isExpanded[panelIndex] = !isExpanded;
            });
          },
          children: expansionTiles,
        ),
      );
    } else {
      return Column(children: const [
        Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        )
      ]);
    }
  }
}

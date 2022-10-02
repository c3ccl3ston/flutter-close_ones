import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonGamesList extends StatelessWidget {
  const SkeletonGamesList({super.key, this.withHeader = false});

  final bool withHeader;

  Widget _gamesList(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SkeletonTheme(
        shimmerGradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.primaryContainer,
          HSLColor.fromColor(Theme.of(context).colorScheme.primaryContainer)
              .withLightness(.85)
              .toColor(),
          HSLColor.fromColor(Theme.of(context).colorScheme.primaryContainer)
              .withLightness(.85)
              .toColor(),
          Theme.of(context).colorScheme.primaryContainer,
        ], stops: const [
          0.1,
          0.4,
          0.7,
          0.9,
        ]),
        darkShimmerGradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.primaryContainer,
          HSLColor.fromColor(Theme.of(context).colorScheme.primaryContainer)
              .withLightness(0.15)
              .toColor(),
          HSLColor.fromColor(Theme.of(context).colorScheme.primaryContainer)
              .withLightness(0.15)
              .toColor(),
          Theme.of(context).colorScheme.primaryContainer,
        ], stops: const [
          0.1,
          0.4,
          0.7,
          0.9,
        ]),
        child: Card(
          borderOnForeground: true,
          clipBehavior: Clip.hardEdge,
          elevation: 5,
          child: Opacity(
            opacity: 1,
            child: SkeletonItem(
              child: Column(children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      width: double.infinity,
                      height: 30,
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                          shape: BoxShape.rectangle,
                                          width: 85,
                                          height: 85)),
                                  SizedBox(height: 16),
                                  SkeletonLine(
                                      style: SkeletonLineStyle(
                                          width: 100, height: 26)),
                                  SizedBox(height: 24),
                                ]),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: SkeletonLine(
                                  style: SkeletonLineStyle(
                                      width: 25.0, height: 25)),
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                          shape: BoxShape.rectangle,
                                          width: 85,
                                          height: 85)),
                                  SizedBox(height: 16),
                                  SkeletonLine(
                                      style: SkeletonLineStyle(
                                          width: 100, height: 26)),
                                  SizedBox(height: 24),
                                ]),
                          ]),
                    ),
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int numColumns = 1;
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 550 && screenWidth <= 1080) {
      numColumns = 2;
    } else if (screenWidth > 1080) {
      numColumns = 3;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: DynamicHeightGridView(
          // padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: numColumns,
          itemCount: 5,
          // primary: false,
          shrinkWrap: true,
          builder: (context, index) {
            if (withHeader && index == 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(40, 5, 40, 0),
                child: SkeletonItem(
                    child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 0),
                      child: Column(children: const [
                        SkeletonLine(style: SkeletonLineStyle(height: 50)),
                        SizedBox(height: 20)
                      ]))
                ])),
              );
            }
            return _gamesList(context);
          }),
    );
  }
}

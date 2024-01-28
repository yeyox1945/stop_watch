import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch/domain/entities/lap.dart';
import 'package:stop_watch/presentation/providers/watch_provider.dart';
import 'package:stop_watch/presentation/utils/text_formatter.dart';

class LapsListView extends ConsumerWidget {
  const LapsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Lap> laps = ref.watch(stopWatchNotifierProvider).laps;

    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: laps.length,
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (context, index) => LapItem(lap: laps[index]));
  }
}

class LapItem extends ConsumerWidget {
  const LapItem({super.key, required this.lap});

  final Lap lap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const textStyle =
        TextStyle(fontSize: 15, fontFeatures: [FontFeature.tabularFigures()]);

    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lap.lapNumber.toString(),
              style: textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '+ ${TextFormatter.stopWatchTimeFormat(lap.lapTime)}',
              style: textStyle.copyWith(
                  color: lap.isBetter ? Colors.green : Colors.red),
            ),
            Text(
              TextFormatter.stopWatchTimeFormat(lap.totalTime),
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

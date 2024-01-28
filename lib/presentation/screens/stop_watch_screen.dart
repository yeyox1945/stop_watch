import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch/presentation/providers/watch_provider.dart';
import 'package:stop_watch/presentation/utils/text_formatter.dart';
import 'package:stop_watch/presentation/widgets/laps_list_view.dart';

class StopWatchScreen extends ConsumerStatefulWidget {
  const StopWatchScreen({super.key});

  @override
  ConsumerState<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends ConsumerState<StopWatchScreen> {
  late Timer ticker;

  @override
  void initState() {
    super.initState();

    // todo: find a way to stop ticker if watch is stopped...
    ticker = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // ignore: avoid_print
      print('ticking...');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final StopWatchState watchProvider = ref.watch(stopWatchNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 90, top: 50),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TextFormatter.stopWatchTimeFormat(
                      watchProvider.stopwatch.elapsed),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                    fontFeatures: [
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
                if (watchProvider.laps.isNotEmpty)
                  const Expanded(child: LapsListView()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed:
                ref.read(stopWatchNotifierProvider.notifier).togglePlayPause,
            shape: const CircleBorder(),
            child: Icon(
                watchProvider.stopwatch.isRunning
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 30),
          ),
          if (watchProvider.stopwatch.elapsedTicks != 0) ...[
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed:
                  ref.read(stopWatchNotifierProvider.notifier).toggleStopLap,
              shape: const CircleBorder(),
              child: Icon(
                  watchProvider.stopwatch.isRunning
                      ? Icons.flag_rounded
                      : Icons.stop_rounded,
                  size: 30),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
  }
}

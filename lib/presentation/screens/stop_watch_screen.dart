import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch/presentation/providers/watch_provider.dart';
import 'package:stop_watch/presentation/utils/text_formatter.dart';
import 'package:stop_watch/presentation/widgets/laps_list_view.dart';

class StopWatchScreen extends StatelessWidget {
  const StopWatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WatchView(),
      floatingActionButton: WatchActions(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class WatchView extends ConsumerWidget {
  const WatchView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StopWatchState watchProvider = ref.watch(stopWatchNotifierProvider);

    return SafeArea(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 90, top: 50),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const StopWatchText(),
              if (watchProvider.laps.isNotEmpty)
                const Expanded(child: LapsListView()),
            ],
          ),
        ),
      ),
    );
  }
}

class StopWatchText extends ConsumerStatefulWidget {
  const StopWatchText({
    super.key,
  });

  @override
  ConsumerState<StopWatchText> createState() => _StopWatchTextState();
}

class _StopWatchTextState extends ConsumerState<StopWatchText>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      setState(() {});
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StopWatchState watchProvider = ref.watch(stopWatchNotifierProvider);

    return Text(
      TextFormatter.stopWatchTimeFormat(watchProvider.stopwatch.elapsed),
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.w500,
        fontFeatures: [
          FontFeature.tabularFigures(),
        ],
      ),
    );
  }
}

class WatchActions extends ConsumerWidget {
  const WatchActions({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StopWatchState watchProvider = ref.watch(stopWatchNotifierProvider);
    return Row(
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
    );
  }
}

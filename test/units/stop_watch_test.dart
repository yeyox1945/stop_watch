import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:stop_watch/presentation/providers/watch_provider.dart';

ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  addTearDown(container.dispose);
  return container;
}

void main() {
  Future wait() async {
    return await Future.delayed(const Duration(seconds: 2));
  }

  test('Stop watch notifier initial state is correct', () {
    final container = createContainer();

    expect(container.read(stopWatchNotifierProvider).laps, []);
  });

  test('Stop watch notifier starts and pauses correctly', () {
    final container = createContainer();
    final notifier = container.read(stopWatchNotifierProvider.notifier);
    final state = container.read(stopWatchNotifierProvider);

    notifier.togglePlayPause();
    expect(state.stopwatch.isRunning, true);

    notifier.togglePlayPause();
    expect(state.stopwatch.isRunning, false);
  });

  test('Stop watch notifier ticks correctly', () async {
    final container = createContainer();
    final notifier = container.read(stopWatchNotifierProvider.notifier);
    final state = container.read(stopWatchNotifierProvider);

    notifier.togglePlayPause();
    await wait();
    notifier.togglePlayPause();
    expect(state.stopwatch.elapsed.inSeconds, isNonZero);
  });

  test('Stop button clears time and laps array correctly', () async {
    final container = createContainer();
    final notifier = container.read(stopWatchNotifierProvider.notifier);
    final state = container.read(stopWatchNotifierProvider);

    notifier.togglePlayPause();
    await wait(); // play
    notifier.toggleStopLap(); // add lap
    await wait(); // play
    notifier.toggleStopLap(); // add lap
    await wait(); // play
    notifier.togglePlayPause(); // pause
    await wait(); // play
    notifier.toggleStopLap(); // reset

    expect(state.laps, isEmpty);
    expect(state.stopwatch.elapsed, const Duration());
  });
}

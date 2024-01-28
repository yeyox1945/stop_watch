import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stop_watch/domain/entities/lap.dart';
part 'watch_provider.g.dart';

class StopWatchState extends Equatable {
  final Stopwatch stopwatch;
  final List<Lap> laps;

  const StopWatchState({required this.stopwatch, this.laps = const []});

  StopWatchState copyWith({Stopwatch? stopwatch, List<Lap>? laps}) {
    return StopWatchState(
        stopwatch: stopwatch ?? this.stopwatch, laps: laps ?? this.laps);
  }

  @override
  List<Object?> get props => [laps];
}

@riverpod
class StopWatchNotifier extends _$StopWatchNotifier {
  @override
  StopWatchState build() {
    return StopWatchState(stopwatch: Stopwatch(), laps: const []);
  }

  void togglePlayPause() {
    if (state.stopwatch.isRunning) {
      state.stopwatch.stop();
    } else {
      state.stopwatch.start();
    }
    state = state.copyWith();
  }

  void toggleStopLap() {
    if (state.stopwatch.isRunning) {
      addLap();
    } else {
      state.stopwatch.reset();
      state = state.copyWith(laps: const []);
    }
  }

  void addLap() {
    final lastLapTotalTime =
        (state.laps.isNotEmpty ? state.laps.first.totalTime : const Duration());

    final currentLapTime = state.stopwatch.elapsed - lastLapTotalTime;

    final lastLapTime =
        state.laps.isNotEmpty ? state.laps.first.lapTime : const Duration();

    state = state.copyWith(laps: [
      Lap(
          lapTime: currentLapTime,
          totalTime: state.stopwatch.elapsed,
          lapNumber: state.laps.length + 1,
          isBetter: currentLapTime <= lastLapTime),
      ...state.laps,
    ]);
  }
}

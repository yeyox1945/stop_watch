class Lap {
  final Duration lapTime;
  final Duration totalTime;
  final int lapNumber;
  final bool isBetter;

  Lap(
      {required this.lapTime,
      required this.totalTime,
      required this.lapNumber,
      required this.isBetter});
}

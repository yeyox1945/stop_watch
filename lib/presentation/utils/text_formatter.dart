class TextFormatter {
  static String stopWatchTimeFormat(Duration duration) {
    // Show only minutes if hasnt passed at least 1 hour to increase readability, and only show 2 miliseconds decimals
    return duration.inHours > 0
        ? duration.toString().substring(0, 10)
        : duration.toString().substring(2, 10);
  }
}

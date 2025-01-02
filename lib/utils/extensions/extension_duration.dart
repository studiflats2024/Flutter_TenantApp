extension DurationString on Duration {
  static Duration fromString(String time) {
    final parts = time.split(':');
    try {
      if (parts.length != 3) throw const FormatException('Invalid time format');

      int days;
      int hours;
      int minutes;
      int seconds;

      seconds = int.parse(parts[2]);

      minutes = int.parse(parts[1]);

      {
        int p = int.parse(parts[0]);
        hours = p % 24;
        days = p ~/ 24;
      }

      return Duration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      );
    } catch (e) {
      return Duration.zero;
    }
  }
}

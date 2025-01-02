class DateManager {
  static bool hasThirtyOneDays(int year, int month) {
// Get the first day of the next month
    DateTime firstDayNextMonth;
    if (month == 12) {
// If December, the next month is January of the next year
      firstDayNextMonth = DateTime(year + 1, 1, 1);
    } else {
// For all other months, the next month is just month + 1
      firstDayNextMonth = DateTime(year, month + 1, 1);
    }

// Subtract one day to get the last day of the current month
    DateTime lastDayCurrentMonth =
        firstDayNextMonth.subtract(const Duration(days: 1));

// Check if the last day of the month is 31
    return lastDayCurrentMonth.day == 31;
  }
}

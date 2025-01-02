import 'package:intl/intl.dart';

class AppDateFormat {
  static DateFormat appDateFormat(String local) {
    return DateFormat.yMMMMd(local);
  }

  static DateFormat appDatePickerFormat(String local) {
    return DateFormat.yMMMMd(local);
  }

  static DateTime appDatePickerParse(String date, String local) {
    return appDatePickerFormat(local).parse(date);
  }

  static String formattingDatePicker(DateTime date, String local) {
    return appDatePickerFormat(local).format(date);
  }

  static String formattingDate(DateTime date, String local) {
    return appDateFormat(local).format(date);
  }

  static String formattingDateToMonth(DateTime date, String local) {
    return DateFormat.yMMMM(local).format(date);
  }

  static String formattingMonthDay(DateTime date, String local) {
    return DateFormat.yMMMd(local).format(date);
  }

  static String formattingOnlyMonthDay(DateTime date, String local) {
    return DateFormat.MMMd(local).format(date);
  }

  static String formattingOnlyYearMonth(DateTime date, String local) {
    return DateFormat.yMMM(local).format(date);
  }

  static String formattingOnlyMonth(DateTime date, String local) {
    return DateFormat.MMM(local).format(date);
  }

  static String formattingApiDate(DateTime date, String local) {
    return DateFormat("yyyy-MM-dd", local).format(date);
  }

  static DateTime appDateFormApiParse(String date) {
    return DateTime.tryParse(date) ?? DateFormat("MM/dd/yyyy").parse(date);
  }

  static String tryFormattingDate(DateTime? date, String local) {
    try {
      return appDateFormat(local).format(date!);
    } catch (e) {
      return "";
    }
  }

  static String formattingTime(DateTime date, String local) {
    return DateFormat.jm(local).format(date);
  }

  static String formattingDateTime(DateTime date, String local) {
    return appDateFormat(local).add_jm().format(date);
  }

  static DateTime formattingApiDateFromString(String? date) {
    return DateFormat('dd/MM/yyyy h:m').parse(date!);
  }
}

import 'package:vivas/utils/locale/app_localization_keys.dart';

enum ProblemFilter {
  all,
  pending,
  completed;

  String get getLocalizedKey {
    switch (this) {
      case ProblemFilter.all:
        return LocalizationKeys.all;
      case ProblemFilter.pending:
        return LocalizationKeys.pending;
      case ProblemFilter.completed:
        return LocalizationKeys.completed;
    }
  }

  String get getApiKey {
    switch (this) {
      case ProblemFilter.all:
        return "All";
      case ProblemFilter.pending:
        return "Pending";
      case ProblemFilter.completed:
        return "Completed";
    }
  }
}

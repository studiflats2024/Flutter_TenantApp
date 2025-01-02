import 'package:vivas/utils/locale/app_localization_keys.dart';

enum InvoicesFilter {
  all,
  paid,
  unpaid;

  String get getLocalizedKey {
    switch (this) {
      case InvoicesFilter.all:
        return LocalizationKeys.all;
      case InvoicesFilter.paid:
        return LocalizationKeys.paid;
      case InvoicesFilter.unpaid:
        return LocalizationKeys.unPaid;
    }
  }

  String get getApiKey {
    switch (this) {
      case InvoicesFilter.all:
        return "All";
      case InvoicesFilter.paid:
        return "Paid";
      case InvoicesFilter.unpaid:
        return "UnPaid";
    }
  }
}

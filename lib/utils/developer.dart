import 'package:vivas/utils/build_type/build_type.dart';
import 'package:flutter/foundation.dart';

import 'feedback/feedback_toast.dart';

class Developer {
  static const String sampleDeveloperError =
      "Sample Developer Error to be guided with";

  static void developerError(String message) {
    developerShow(message);
    developerLog(message);
  }

  static void developerLog(String message) {
    debugPrint(message);
  }

  static void developerShow(String message) {
    if (isDebugMode()) {
      showToast(message);
    }
  }
}

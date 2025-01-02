import 'package:fluttertoast/fluttertoast.dart';
import 'package:vivas/res/app_colors.dart';

void showToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: AppColors.toastBackground,
      textColor: AppColors.toastText,
      fontSize: 14.0);
}

/// reference
/// https://pub.dev/packages/fluttertoast

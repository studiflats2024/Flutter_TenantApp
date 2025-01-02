import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';

class Utils {
  static void showMessageAlert({
    required BuildContext context,
    required String message,
    String title = "",
    ArtSweetAlertType? type,
  }) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(type: type, title: title, text: message));
  }
}

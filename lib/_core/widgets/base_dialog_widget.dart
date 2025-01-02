import 'package:flutter/material.dart';

Future<void> showAppDialog(
    {required BuildContext context,
    required Widget dialogWidget,
    required bool shouldPop}) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) {
        return PopScope(
          canPop: shouldPop,
          child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.all(15),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              content: dialogWidget),
        );
      });
}

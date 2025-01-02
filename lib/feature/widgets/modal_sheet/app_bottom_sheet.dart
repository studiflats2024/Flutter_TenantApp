import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/feature/widgets/login_or_register_bottom_sheet_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/base_bottom_sheet_widget.dart';

class AppBottomSheet {
  static openAppBottomSheet(
      {required BuildContext context,
      required Widget child,
      required String title,
      VoidCallback? onCloseCallBack}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BaseBottomSheetWidget(
          onCloseCallBack: onCloseCallBack,
          title: title,
          child: child,
        ),
      ),
    );
  }

  static openBaseBottomSheet({
    required BuildContext context,
    required Widget child,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: bottomSheetShapes,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: child,
      ),
    );
  }

  static Future<void> showLoginOrRegisterDialog(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      shape: bottomSheetShapes,
      builder: (context) {
        return LoginOrRegisterBottomSheetWidget();
      },
    );
  }

  /// Shared Between Bottom Sheets

  static final bottomSheetShapes = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.r),
      topRight: Radius.circular(20.r),
    ),
  );
}

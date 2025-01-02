import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/auth/login/screen/login_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class LoginOrRegisterBottomSheetWidget extends BaseStatelessWidget {
  LoginOrRegisterBottomSheetWidget({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            translate(LocalizationKeys.signInRequired)!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            translate(LocalizationKeys.youNeedToSignInToContinue)!,
            style: const TextStyle(
              color: Color(0xFF1C1C1C),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: _cancelElevatedButton(context)),
              const SizedBox(width: 15),
              Expanded(child: _signInElevatedButton(context)),
            ],
          ),
        ],
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _cancelElevatedButton(BuildContext context) {
    return AppOutlinedButton.withTitle(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
      onPressed: () => _onPressCancel(context),
      title: translate(LocalizationKeys.cancel)!,
    );
  }

  Widget _signInElevatedButton(BuildContext context) {
    return AppElevatedButton.withTitle(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
      onPressed: () => LoginScreen.open(context),
      title: translate(LocalizationKeys.signIn)!,
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Helper methods ///////////////////////
  ///////////////////////////////////////////////////////////

  void _onPressCancel(BuildContext context) => Navigator.pop(context);
}

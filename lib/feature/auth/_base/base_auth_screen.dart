import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/widgets/back_button/app_back_button.dart';

abstract class BaseAuthScreen extends BaseStatefulScreenWidget {
  const BaseAuthScreen({Key? key}) : super(key: key);
}

abstract class BaseAuthState<AW extends BaseAuthScreen>
    extends BaseScreenState<AW> {
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: const AppBackButton(),
          ),
        ),
        body: bodyWidget(context));
  }

  Widget bodyWidget(BuildContext context);
}

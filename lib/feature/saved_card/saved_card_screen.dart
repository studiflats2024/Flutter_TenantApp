import 'package:flutter/material.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';

class SavedCardScreen extends BaseStatefulScreenWidget {
  static const routeName = '/saved-cards-screen';
  const SavedCardScreen({super.key});
  static open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  @override
  BaseScreenState<SavedCardScreen> baseScreenCreateState() {
    return _PaymentsInvoicesScreen();
  }
}

class _PaymentsInvoicesScreen extends BaseScreenState<SavedCardScreen> {
  @override
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      body: _backgroundImage(),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  /*Widget _listWidget() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: const Column(
        children: [],
      ),
    );
  }*/
  Widget _backgroundImage() {
    return SizedBox(
      child: Image.asset(AppAssetPaths.downbackground, fit: BoxFit.cover),
    );
  }
  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////
}

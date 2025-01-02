import 'package:flutter/material.dart';
import 'package:vivas/res/app_asset_paths.dart';

class AppLogoTitleWidget extends StatelessWidget {
  const AppLogoTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssetPaths.appLogoTitle,
      fit: BoxFit.cover,
    );
  }
}

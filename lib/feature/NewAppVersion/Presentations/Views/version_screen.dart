import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';

class VersionScreen extends StatelessWidget {
  String packageName;

  VersionScreen({required this.packageName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              AppAssetPaths.splashBackground,
              fit: BoxFit.fill,
              colorBlendMode: BlendMode.luminosity,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 15.r,
            left: 15.r,
            child: Column(
              children: [
                Text(
                  "We have a new version click update now to install it",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColors.toastText,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 18.r,
                ),
                AppElevatedButton.whiteWithTitle(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(300.r, 50.r)),
                    maximumSize: MaterialStateProperty.all(Size(300.r, 50.r)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: AppColors.appButtonBorder,
                        ),
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor: MaterialStateProperty.all(AppColors.background)
                  ),
                  onPressed: () {
                    _openStore();
                  },
                  title: "Update Now",
                ),
                SizedBox(
                  height: 20.r,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _openStore() async {
    String url;

    if (Platform.isAndroid) {
      url = "https://play.google.com/store/apps/details?id=$packageName";
    } else if (Platform.isIOS) {
      url = "https://apps.apple.com/de/app/studiflats/id6474908385";
    } else {
      throw "Unsupported platform";
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }
}

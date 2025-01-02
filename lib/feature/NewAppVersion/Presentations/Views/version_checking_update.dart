
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';

class VersionChecking extends StatelessWidget {
  final String version;
  const VersionChecking({required this.version ,super.key});

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
            right: 10.r,
            left: 10.r,
            child: Column(
              children: [
                Text(
                  "Checking App Version $version",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.toastText,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.r,),
               const CircularProgressIndicator(color: AppColors.toastText,),
                SizedBox(height: 16.r,)
              ],
            ),
          )
        ],
      ),
    );
  }

}

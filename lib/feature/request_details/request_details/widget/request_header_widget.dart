// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/feature/bookings/screen/bookings_screen.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/feature/unit_list/screen/unit_list_screen.dart';

import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';

class RequestHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final String state;

  const RequestHeaderWidget({
    super.key,
    required this.state,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Stack(
        children: [
          AppCachedNetworkImage(
            imageUrl: imageUrl,
            height: double.infinity,
            width: double.infinity,
            boxFit: BoxFit.fill,
          ),
          PositionedDirectional(
            end: 30,
            top: kToolbarHeight,
            start: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: InkWell(
                    radius: 100,
                    onTap: () {
                       Navigator.of(context).pop();
                      // BottomNavigationScreen.open(context, 2);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.h),
                      child: SvgPicture.asset(AppAssetPaths.arrowBackIcon),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  child: Text(
                    state,
                    style: const TextStyle(
                      color: Color(0xFF1151B4),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

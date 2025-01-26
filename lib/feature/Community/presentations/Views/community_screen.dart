import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_dialog_widget.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_about.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_activities.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_club_activities.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_header.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_subscription.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/OnBoarding/community_on_boarding.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/size_manager.dart';

class CommunityScreen extends BaseStatefulScreenWidget {
  const CommunityScreen({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _CommunityScreen();
  }
}

class _CommunityScreen extends BaseScreenState<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AboutCommunity.showOnBoarding(context, false);
    });
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeManager.sizeSp16,
            vertical: SizeManager.sizeSp8,
          ),
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.none,
            children: [
              CommunityHeader(),
              CommunityActivities(),
              CommunityClubActivities(),
              CommunityAbout(),
              SizedBox(
                height: 330.r,
                child: const CommunitySubscription(),
              ),
              SizedBox(height: SizeManager.sizeSp6,)
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: SizeManager.sizeSp18),
        child: FloatingActionButton(
          onPressed: () {
            AboutCommunity.showOnBoarding(context, true);
          },
          backgroundColor: AppColors.colorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(SizeManager.circularRadius15),
          ),
          child: SvgPicture.asset(AppAssetPaths.informationIcon),
        ),
      ),
    );
  }
}

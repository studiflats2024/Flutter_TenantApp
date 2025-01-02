import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';

import '../../res/app_asset_paths.dart';
import '../extensions/extension_colors.dart';
import '../locale/app_localization_keys.dart';

// ignore: must_be_immutable
class StatusWidget extends BaseStatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonTitle;
  final VoidCallback onAction;
  final Widget? bottomWidget;

  StatusWidget.noMessage(
      {super.key,
      this.image = AppAssetPaths.noMessageImage,
      this.title = LocalizationKeys.noMessage,
      this.description = LocalizationKeys.whenYouHaveMessagesYouWillSeeThemHere,
      this.buttonTitle = LocalizationKeys.goBack,
      this.bottomWidget,
      required this.onAction});

  StatusWidget.noFavorites(
      {super.key,
      this.image = AppAssetPaths.noFavoriteImage,
      this.title = LocalizationKeys.noFavorites,
      this.description =
          LocalizationKeys.youCanAddAnItemToYourFavoritesByClickingStarIcon,
      this.buttonTitle = LocalizationKeys.goBack,
      this.bottomWidget,
      required this.onAction});

  StatusWidget.lostConnection(
      {super.key,
      this.image = AppAssetPaths.noConnectionImage,
      this.title = LocalizationKeys.lostConnection,
      this.description = LocalizationKeys
          .whoopsNoInternetConnectionFoundPleaseCheckYourConnection,
      this.buttonTitle = LocalizationKeys.tryAgain,
      this.bottomWidget,
      required this.onAction});

  StatusWidget.notFound(
      {super.key,
      this.image = AppAssetPaths.notFoundImage,
      this.title = LocalizationKeys.resultNotFound,
      this.description = LocalizationKeys
          .pleaseTryAgainWithAnotherKeywordsOrMaybeUseGenericTerm,
      this.buttonTitle = LocalizationKeys.searchAgain,
      this.bottomWidget,
      required this.onAction});
  StatusWidget.searchNotFound(
      {super.key,
      this.image = AppAssetPaths.notFoundImage,
      this.title = LocalizationKeys.resultNotFound,
      this.description = LocalizationKeys
          .unfortunatelyWeDidNotFindASuitableApartmentAccordingToYourSearchCriteria,
      this.buttonTitle = LocalizationKeys.putYourselfOnTheWaitingList,
      this.bottomWidget,
      required this.onAction});

  StatusWidget.noNotification(
      {super.key,
      this.image = AppAssetPaths.noNotificationImage,
      this.title = LocalizationKeys.noNotificationsYet,
      this.description =
          LocalizationKeys.whenYouGetNotificationsTheyWillShowUpHere,
      this.buttonTitle = LocalizationKeys.refresh,
      this.bottomWidget,
      required this.onAction});

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 30.w, right: 30.w),
      child: Column(
        children: [
          Center(
            child: SvgPicture.asset(image),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              translate(title)!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              translate(description)!,
              style: TextStyle(
                color: HexColor.fromHex('9E9E9E'),
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: ElevatedButton(
              onPressed: onAction,
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    HexColor.fromHex('1151B4')),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
              child: Text(
                translate(buttonTitle)!,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (bottomWidget != null) bottomWidget!
        ],
      ),
    );
  }
}

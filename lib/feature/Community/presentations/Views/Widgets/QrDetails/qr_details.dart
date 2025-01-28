import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

//ignore: must_be_immutable
class CommunityQrDetails extends BaseStatelessWidget {
  static const routeName = '/my_qr_code_community';

  static Future<void> open(
    BuildContext context,
    bool replacement,
  ) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(
        routeName,
      );
    } else {
      await Navigator.of(context).pushNamed(
        routeName,
      );
    }
  }

  CommunityQrDetails({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        withBackButton: true,
        iconColor: AppColors.textWhite,
        titleColor: AppColors.textWhite,
        title: LocalizationKeys.myQrCode,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 220.r,
              decoration: const BoxDecoration(color: AppColors.colorPrimary),
            ),
          ),
          Positioned(
            top: 120.r,
            left: 0,
            right: 0,
            child: Container(
              height: 500.r,
              margin: EdgeInsets.symmetric(
                horizontal: SizeManager.sizeSp16,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeManager.sizeSp16,
              ),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.all(SizeManager.circularRadius20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F919191),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage(AppAssetPaths.qrCode),
                    width: 200.r,
                    height: 200.r,
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp16,
                  ),
                  TextApp(
                    text: "Sara Mohamed",
                    color: AppColors.colorPrimary,
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp24,
                  ),
                  TextApp(
                    text: "Welcome to the Community Club!",
                    fontSize: FontSize.fontSize14,
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp8,
                  ),
                  TextApp(
                    text:
                        "Show This Code At The Club Gate To Confirm Your Membership",
                    textAlign: TextAlign.center,
                    fontSize: FontSize.fontSize12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textNatural700,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

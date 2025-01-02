import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signature/signature.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/bookings/screen/hand_over_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/feature/widgets/app_buttons/app_text_button.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/res/app_asset_paths.dart';
import '../../../res/app_colors.dart';
import '../../../utils/locale/app_localization_keys.dart';

class SignContractV2Screen extends BaseStatefulScreenWidget {
  static const routeName = '/_sign-contract-v2-screen';

  const SignContractV2Screen({super.key});

  static Future<void> open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  @override
  BaseScreenState<SignContractV2Screen> baseScreenCreateState() {
    return _SignContractScreenState();
  }
}

class _SignContractScreenState extends BaseScreenState<SignContractV2Screen> {
  TextEditingController controller = TextEditingController();
  bool showHelpMessage = false;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                      child: Row(
                        children: [
                           Icon(
                            Icons.arrow_back,
                            color: AppColors.colorPrimary,
                             size: 20.r,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            translate(LocalizationKeys.back)!,
                            style: TextStyle(
                                color: AppColors.colorPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 18.sp),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Center(
                      child: Text(
                        translate(LocalizationKeys.signContract) ?? '',
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color:const Color(0xFF1A1B1E),
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 85.h,
                      width: 350.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.colorPrimary),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 18.h),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppAssetPaths.contractIcon,),
                          SizedBox(
                            width: 10.w,
                          ),
                           Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contract.pdf',
                                style: TextStyle(
                                  color:const Color(0xFF787579),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '200 KB ',
                                style: TextStyle(
                                  color:const Color(0xFF605D62),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      translate(LocalizationKeys.signature) ?? "",
                      style:  TextStyle(
                        color:const Color(0xFF1A1B1E),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: _onSignContractNowClicked,
                      child: Container(
                        height: 120.h,
                        width: 350.w,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssetPaths.signatureIcon,width: 50.w,height: 50.h,),
                            SizedBox(
                              height: 5.h,
                            ),
                             Text(
                              'Sign Here',
                              style: TextStyle(
                                color:const Color(0xFF1F4068),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                height: 0.11,
                              ),
                            )
                          ],
                        ),),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
              SubmitButtonWidget(
                  title: translate(LocalizationKeys.continuee)!,
                  withoutShape: true,
                  padding: EdgeInsets.zero,
                  onClicked: () {
                   // HandoverProtocolsScreen.open(context);
                  }),
              SizedBox(
                height: 10.h,
              ),
              Text.rich(
                TextSpan(
                  text: translate(
                    LocalizationKeys.needHelp,
                  ),
                  style: const TextStyle(color: AppColors.formFieldHintText),
                  children: [
                    TextSpan(
                      text: translate(LocalizationKeys.contactUs)!,
                      style: const TextStyle(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _onSignContractNowClicked() {
    showSignatureBottomSheet();
  }

  Widget _signatureWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0.h, horizontal: 16.h),
          child: DottedBorder(
            borderType: BorderType.Rect,
            radius: const Radius.circular(8),
            padding: const EdgeInsets.all(4),
            color: AppColors.signatureBorderColor,
            dashPattern: const [10, 10],
            child: Signature(
              controller: _signatureController,
              height: 200.h,
              width: 290.w,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.appCancelButtonBackground,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: AppElevatedButton.withTitle(
                onPressed: () => {_signatureController.clear()},
                title: translate(LocalizationKeys.clear)!,
                color: Colors.white,
                textColor: AppColors.colorPrimary,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: AppTextButton(
                  onPressed: () => {

                  },
                  child: Text(
                    translate(LocalizationKeys.confirm)!,
                    style: themeData.textTheme.labelMedium?.copyWith(
                        color: AppColors.appSecondButton,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500),
                  )),
            ),
          ],
        )
      ],
    );
  }
  void showSignatureBottomSheet() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: _signatureWidget(),
        title: translate(LocalizationKeys.yourSignature)!);
  }

}

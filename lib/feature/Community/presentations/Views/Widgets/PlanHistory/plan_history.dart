import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/Data/Models/plan_details_model.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanHistory/plan_invoice_details.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class PlanHistory extends BaseStatelessWidget {
  PlanHistory({super.key});

  static Future<void> open(BuildContext context) async {
    await Navigator.of(context).pushNamed(
      routeName,
    );
  }

  static const routeName = '/plans-history';

  @override
  Widget baseBuild(BuildContext context) {
    return const PlanHistoryWithBloc();
  }
}

class PlanHistoryWithBloc extends BaseStatefulScreenWidget {
  const PlanHistoryWithBloc({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _PlanHistoryWithBloc();
  }
}

class _PlanHistoryWithBloc extends BaseScreenState<PlanHistoryWithBloc> {
  PlanDetailsModel planDetailsModel = PlanDetailsModel(
      planName: "Annual Plan",
      planDuration: "Year",
      planFianlPrice: 460,
      planDurationInMonths: 12);

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalizationKeys.paymentHistory,
        withBackButton: true,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: SizeManager.sizeSp16),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(SizeManager.circularRadius10),
                  border: Border.all(color: AppColors.cardBorderPrimary100)),
              padding: EdgeInsets.all(SizeManager.sizeSp16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30.r,
                            height: 30.r,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeManager.sizeSp4,
                                vertical: SizeManager.sizeSp6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(SizeManager.circularRadius8),
                              color:
                                  getColor(planDetailsModel).withOpacity(0.1),
                            ),
                            child: SvgPicture.asset(
                              getAsset(planDetailsModel),
                            ),
                          ),
                          SizedBox(
                            width: SizeManager.sizeSp12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: planDetailsModel.planName ?? "",
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                              SizedBox(
                                height: SizeManager.sizeSp4,
                              ),
                              TextApp(
                                text: "Enjoy exclusive access ",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textNatural700,
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                //return CommunityInvoiceDetails(invoiceApiModel: invoiceApiModel, isMonthlyInvoice: isMonthlyInvoice, downloadClickedCallBack: downloadClickedCallBack, payNowClickedCallBack: payNowClickedCallBack)
                                return CommunityInvoiceDetails();
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: 30.r,
                          height: 30.r,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(SizeManager.circularRadius8),
                            color: AppColors.cardBorderPrimary100,
                          ),
                          child: SvgPicture.asset(
                            AppAssetPaths.communityArrowUp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp16,
                  ),
                  Row(
                    children: [
                      TextApp(
                        multiLang: false,
                        text:
                            " € ${planDetailsModel.planFianlPrice?.toStringAsFixed(2) ?? 0.0} ",
                        style: textTheme.headlineLarge?.copyWith(
                          fontSize: FontSize.fontSize18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorPrimary,
                        ),
                      ),
                      TextApp(
                        multiLang: false,
                        text: "/ ${planDetailsModel.planDuration ?? ''}",
                        color: AppColors.textNatural700,
                        fontWeight: FontWeight.w400,
                        fontSize: FontSize.fontSize14,
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      color: AppColors.cardBorderPrimary100))),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppAssetPaths.calenderIconOutline,
                                color: AppColors.colorPrimary,
                              ),
                              SizedBox(
                                width: SizeManager.sizeSp8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextApp(
                                    text: "Payment Date",
                                    fontSize: FontSize.fontSize12,
                                    color: AppColors.textNatural700,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(
                                    height: SizeManager.sizeSp4,
                                  ),
                                  TextApp(
                                    text: "Feb 25 , 2025",
                                    fontSize: FontSize.fontSize14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssetPaths.communityInvoiceIcon,
                            color: AppColors.colorPrimary,
                          ),
                          SizedBox(
                            width: SizeManager.sizeSp8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: "Invoice No.",
                                fontSize: FontSize.fontSize12,
                                color: AppColors.textNatural700,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(
                                height: SizeManager.sizeSp4,
                              ),
                              TextApp(
                                text: "00125985",
                                fontSize: FontSize.fontSize14,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          )
                        ],
                      )),
                    ],
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: SizeManager.sizeSp16,
            );
          },
          itemCount: 3),
    );
  }

  String getAsset(PlanDetailsModel? item) {
    switch (item?.planDurationInMonths) {
      case 12:
        return AppAssetPaths.rateIcon;
      case 1:
        return AppAssetPaths.personIcon;
      default:
        return AppAssetPaths.calenderIcon2;
    }
  }

  Color getColor(PlanDetailsModel? item) {
    switch (item?.planDurationInMonths) {
      case 12:
        return AppColors.cardBorderGold;
      case 1:
        return AppColors.cardBorderGreen;
      default:
        return AppColors.colorPrimary;
    }
  }
}

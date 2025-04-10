import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Managers/subscription_enum.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/my_plan_model.dart';
import 'package:vivas/feature/Community/Data/Repository/MyPlan/my_plan_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/MyPlan/my_plan_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/AllPlans/all_plans.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MyPlan/contdown_timer.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanDetails/pay_subscription.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanHistory/plan_history.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanHistory/plan_invoice_details.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_member_contract.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class MyPlan extends BaseStatelessWidget {
  static const routeName = '/my-plan-community';

  MyPlan({super.key});

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

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
        create: (context) => MyPlanBloc(
              MyPlanRepositoryImplementation(
                CommunityManager(dioApiManager),
              ),
            ),
        child: const MyPlanScreen());
  }
}

class MyPlanScreen extends BaseStatefulScreenWidget {
  const MyPlanScreen({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _MyPlanScreen();
  }
}

class _MyPlanScreen extends BaseScreenState<MyPlanScreen> {
  ExpandableController controller = ExpandableController();

  MyPlanModel planModel = MyPlanModel();

  @override
  void initState() {
    currentBloc.add(GetMyPlanEvent());
    super.initState();
  }

  MyPlanBloc get currentBloc => context.read<MyPlanBloc>();

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: AppColors.textWhite),
        actions: [
          InkWell(
            onTap: () {
              PlanHistory.open(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp8),
              child: SvgPicture.asset(AppAssetPaths.communityFilterIcon),
            ),
          )
        ],
        title: LocalizationKeys.myPlan,
        withBackButton: true,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: BlocConsumer<MyPlanBloc, MyPlanState>(
        listener: (context, state) {
          if (state is MyPlanLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is GetMyPlanState) {
            if (state.model != null) {
              planModel = state.model!;
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return ViewPlans();
              }));
            }
          } else if (state is ErrorMyPlanState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage) ?? ""
                : state.errorMassage);
          }
        },
        builder: (context, state) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.textWhite,
                  borderRadius: BorderRadius.all(SizeManager.circularRadius10),
                  border: Border(
                    top: BorderSide(color: getColor(planModel), width: 4.r),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3FA1A1A1),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: SizeManager.sizeSp16),
                padding: EdgeInsets.all(SizeManager.sizeSp16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40.r,
                              height: 40.r,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeManager.sizeSp4,
                                  vertical: SizeManager.sizeSp8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    SizeManager.circularRadius10),
                                color: getColor(planModel).withOpacity(0.1),
                              ),
                              child: SvgPicture.asset(
                                getAsset(planModel),
                              ),
                            ),
                            SizedBox(
                              width: SizeManager.sizeSp12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextApp(
                                  text: (planModel.isTrial ?? false)
                                      ? "Free Trial Plan"
                                      : planModel.planName ?? "",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                                SizedBox(
                                  height: SizeManager.sizeSp4,
                                ),
                                if (planModel.isTrial ?? false) ...[
                                  TextApp(
                                    text: (planModel.isTrial ?? false)
                                        ? "Enjoy exclusive access "
                                        : "${planModel.planFianlPrice}",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textNatural700,
                                  ),
                                ] else
                                  ...[],
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            TextApp(
                              text: planModel.paymentMethod ?? "",
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: FontSize.fontSize14,
                            ),
                            SizedBox(
                              height: SizeManager.sizeSp8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: planModel.subscriptionStatus ==
                                        SubscriptionStatus.waitingPayment
                                    ? AppColors.cardBackgroundActivityCancelled
                                    : AppColors.cardBackgroundEvent,
                                borderRadius: BorderRadius.all(
                                    SizeManager.circularRadius8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: TextApp(
                                text: planModel.subscriptionStatus ==
                                        SubscriptionStatus.waitingPayment
                                    ? "UnPaid"
                                    : "Paid",
                                color: planModel.subscriptionStatus ==
                                        SubscriptionStatus.waitingPayment
                                    ? AppColors.textActivityCancelled
                                    : AppColors.cardBorderGreen,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeManager.sizeSp24,
                    ),
                    if (planModel.isTrial ?? false) ...[
                      TextApp(
                        text:
                            "You are currently enjoying a free trial duration of your subscription.🎉",
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp24,
                      ),
                    ] else ...[
                      Row(
                        children: [
                          TextApp(
                            multiLang: false,
                            text:
                                "€ ${planModel.planFianlPrice?.toStringAsFixed(2) ?? 0.0}",
                            style: textTheme.headlineLarge?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorPrimary,
                            ),
                          ),
                          TextApp(
                            multiLang: false,
                            text: " / ${planModel.planDuration ?? ''}",
                            color: AppColors.textNatural700,
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextApp(
                          multiLang: false,
                          fontWeight: FontWeight.w400,
                          fontSize: FontSize.fontSize12,
                          text:
                              "Billed annually, save ${planModel.planDiscount}%",
                          color: AppColors.textNatural700,
                        ),
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp16,
                      ),
                      Container(
                        height: 1.sp,
                        margin:
                            EdgeInsets.symmetric(vertical: SizeManager.sizeSp4),
                        color: AppColors.cardBorderPrimary100,
                      ),
                    ],
                    expandedItem,
                    SizedBox(
                      height: SizeManager.sizeSp16,
                    ),
                    dateItem
                  ],
                ),
              ),
              SizedBox(
                height: SizeManager.sizeSp24,
              ),
              if (planModel.dateTimeRange != null &&
                  planModel.dateTimeRange!.duration.inDays <= 7) ...[
                SizedBox(
                  height: 230.r,
                  child: CountdownTimer(
                    planModel.endDate ?? "",
                    planModel.planName ?? "",
                  ),
                )
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: (planModel.subscriptionStatus ==
                  SubscriptionStatus.active &&
              !(planModel.isTrial ?? false) &&
              !(planModel.contractSigned ?? false))
          ? SizedBox(
              height: 110.r,
              child: SubmitButtonWidget(
                  withoutShape: true,
                  title: translate(LocalizationKeys.signContract) ?? "",
                  onClicked: () async {
                    if (planModel.subscriptionStatus ==
                        SubscriptionStatus.active) {
                      await SignMemberContract.open(context, false);
                      currentBloc.add(GetMyPlanEvent());
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ViewPlans();
                      }));
                    }
                  }))
          : (planModel.subscriptionStatus == SubscriptionStatus.active &&
                      (planModel.contractSigned ?? false) &&
                      !(planModel.isTrial ?? false)) &&
                  !(planModel.canUpgrade ?? false)
              ? SizedBox(
                  height: 110.r,
                  child: SubmitButtonWidget(
                    withoutShape: true,
                    title: translate(LocalizationKeys.seeContract) ?? "",
                    onClicked: () async {
                      launchUrl(Uri.parse(planModel.contractPath ?? ""));
                    },
                  ),
                )
              : planModel.subscriptionStatus == SubscriptionStatus.active &&
                      !(planModel.canUpgrade ?? false) &&
                      !(planModel.isTrial ?? false)
                  ? null
                  : SizedBox(
                      height: 110.r,
                      child: SubmitButtonWidget(
                          withoutShape: true,
                          title: translate((planModel.subscriptionStatus ==
                                          SubscriptionStatus.waitingPayment &&
                                      !(planModel.isTrial ?? false))
                                  ? LocalizationKeys.payNow
                                  : LocalizationKeys.upgradeNow) ??
                              "",
                          onClicked: () {
                            if (planModel.subscriptionStatus ==
                                    SubscriptionStatus.waitingPayment &&
                                !(planModel.isTrial ?? false)) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) {
                                    return CommunityInvoiceDetails(
                                        planModel.paymentInvoiceId ?? "");
                                  },
                                ),
                              ).then((v) {
                                return currentBloc.add(GetMyPlanEvent());
                              });
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return ViewPlans();
                              }));
                            }
                          }),
                    ),
    );
  }

  Widget get expandedItem {
    return ExpandableNotifier(
      child: Expandable(
        collapsed: ExpandableButton(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeManager.sizeSp16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      multiLang: true,
                      fontWeight: FontWeight.w400,
                      text: LocalizationKeys.features,
                      color: AppColors.textNatural700,
                    ),
                    SvgPicture.asset(AppAssetPaths.forwardIcon)
                  ],
                ),
              ),
              Container(
                height: 1.sp,
                margin: EdgeInsets.symmetric(vertical: SizeManager.sizeSp4),
                color: AppColors.cardBorderPrimary100,
              ),
            ],
          ),
        ),
        expanded: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeManager.sizeSp16),
              child: ExpandableButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      multiLang: true,
                      fontWeight: FontWeight.w400,
                      text: LocalizationKeys.features,
                      color: AppColors.textNatural700,
                    ),
                    SvgPicture.asset(AppAssetPaths.forwardIconTop)
                  ],
                ),
              ),
            ),
            Column(
              children: List.generate(
                planModel.planFeatures?.length ?? 0,
                (index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeManager.sizeSp8),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppAssetPaths.featureIcon,
                        ),
                        SizedBox(
                          width: SizeManager.sizeSp4,
                        ),
                        TextApp(
                          multiLang: false,
                          text: planModel.planFeatures?[index] ?? "",
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textNatural700,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 1.sp,
              margin: EdgeInsets.symmetric(vertical: SizeManager.sizeSp4),
              color: AppColors.cardBorderPrimary100,
            ),
          ],
        ),
      ),
    );
  }

  Widget get dateItem {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    right: BorderSide(color: AppColors.cardBorderPrimary100))),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssetPaths.calenderIconOutline,
                  color: AppColors.colorPrimary,
                ),
                SizedBox(
                  width: SizeManager.sizeSp12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp(
                      multiLang: true,
                      text: LocalizationKeys.startDate,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: AppColors.cardTextNatural700,
                    ),
                    SizedBox(
                      height: SizeManager.sizeSp4,
                    ),
                    TextApp(
                      text: planModel.startDate ?? "",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMainColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    left: BorderSide(color: AppColors.cardBorderPrimary100))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  AppAssetPaths.calenderIconOutline,
                  color: AppColors.colorPrimary,
                ),
                SizedBox(
                  width: SizeManager.sizeSp12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp(
                      multiLang: true,
                      text: LocalizationKeys.renewalDate,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: AppColors.cardTextNatural700,
                    ),
                    SizedBox(
                      height: SizeManager.sizeSp4,
                    ),
                    TextApp(
                      text: planModel.endDate ?? "",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMainColor,
                    ),
                  ],
                ),
                SizedBox(
                  width: SizeManager.sizeSp16,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  String getAsset(MyPlanModel? item) {
    if (item?.isTrial ?? false) {
      return AppAssetPaths.prizeIcon;
    } else {
      switch (item?.planDurationInMonths) {
        case 12:
          return AppAssetPaths.rateIcon;
        case 1:
          return AppAssetPaths.personIcon;
        default:
          return AppAssetPaths.calenderIcon2;
      }
    }
  }

  Color getColor(MyPlanModel? item) {
    if (item?.isTrial ?? false) {
      return AppColors.cardBorderBrown;
    } else {
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
}

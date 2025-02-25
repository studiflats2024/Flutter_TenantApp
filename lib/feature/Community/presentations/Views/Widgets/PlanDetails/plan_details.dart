import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/plan_details_model.dart';
import 'package:vivas/feature/Community/Data/Models/plan_subscribe_model.dart';
import 'package:vivas/feature/Community/Data/Repository/Plans/PlanDetails/plan_details_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/Plans/PlanDetails/plan_details_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanDetails/pay_subscription.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

//ignore: must_be_immutable
class PlanDetails extends BaseStatelessWidget {
  static const routeName = '/plan_details';
  static const argumentPlanId = 'plan-id';
  static const argumentPlanName = 'plan-name';

  PlanDetails({super.key});

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  static Future<void> open(
    BuildContext context,
    bool replacement,
    String planId,
    String planName,
  ) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentPlanId: planId,
        argumentPlanName: planName,
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentPlanId: planId,
        argumentPlanName: planName,
      });
    }
  }

  String planId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[PlanDetails.argumentPlanId] as String;

  String planName(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[PlanDetails.argumentPlanName] as String;

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
      create: (context) => PlanDetailsBloc(
        PlanDetailsRepositoryImplementation(
          CommunityManager(
            dioApiManager,
          ),
        ),
      ),
      child: PlanDetailsWithBloc(planId(context), planName(context)),
    );
  }
}

class PlanDetailsWithBloc extends BaseStatefulScreenWidget {
  final String planID;
  final String planName;

  const PlanDetailsWithBloc(this.planID, this.planName, {super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _PlanDetailsWithBloc();
  }
}

class _PlanDetailsWithBloc extends BaseScreenState<PlanDetailsWithBloc> {
  PlanDetailsModel? planDetailsModel;
  SubscribePlanModel? subscribePlanModel;
  bool isGuest = true;

  @override
  void initState() {
    super.initState();
    currentBloc.add(CheckLoggedInEvent());
    currentBloc.add(GetPlanDetailsEvent(widget.planID));
  }

  PlanDetailsBloc get currentBloc => context.read<PlanDetailsBloc>();

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.planName,
        withBackButton: true,
        multiLan: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: BlocConsumer<PlanDetailsBloc, PlanDetailsState>(
        listener: (context, state) {
          if (state is PlanDetailsLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is GetPlanDetailsState) {
            planDetailsModel = state.planDetailsModel;
          } else if (state is IsLoggedInState) {
            isGuest = false;
          } else if (state is IsGuestModeState) {
            AppBottomSheet.showLoginOrRegisterDialog(context);
            isGuest = true;
          } else if (state is SubscribePlanSuccessState) {
            subscribePlanModel = state.model;
            AppBottomSheet.openAppBottomSheet(
                context: context,
                child: Column(
                  children: [
                    _methodWidget(translate(LocalizationKeys.onlinePayment)!,
                        AppAssetPaths.creditCardIcon, () {
                      currentBloc.add(
                        PaySubscriptionEvent(
                          PaySubscriptionSendModel(
                              state.model.invoiceId ?? "", false),
                        ),
                      );
                      Navigator.pop(context);
                    }),
                    _methodWidget(translate(LocalizationKeys.cash)!,
                        AppAssetPaths.walletIcon, () {
                      currentBloc.add(
                        PaySubscriptionEvent(
                          PaySubscriptionSendModel(
                              state.model.invoiceId ?? "", true),
                        ),
                      );
                      Navigator.pop(context);
                    }),
                  ],
                ),
                title: "Pay Methods");
          } else if (state is PaySubscribePlanSuccessState) {
            if (state.response.isLink) {
              PaySubscription.open(context, subscribePlanModel?.invoiceId ?? "",
                      state.response)
                  .then((v) {
                currentBloc.add(GetPlanDetailsEvent(widget.planID));
              });
            } else {
              showFeedbackMessage(state.response);
            }
          } else if (state is ErrorPlanDetails) {
            showFeedbackMessage(state.errorMassage);
          } else if (state is PayErrorPlanDetails) {
            showFeedbackMessage(state.errorMassage);
          }
        },
        builder: (context, state) {
          return state is PlanDetailsLoadingState || state is ErrorPlanDetails
              ? Container()
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.textWhite,
                        borderRadius:
                            BorderRadius.all(SizeManager.circularRadius10),
                        border: Border(
                          top: BorderSide(
                              color: getColor(planDetailsModel), width: 4.r),
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
                      margin: EdgeInsets.only(
                        top: SizeManager.sizeSp16,
                        right: SizeManager.sizeSp16,
                        left: SizeManager.sizeSp16,
                      ),
                      padding: EdgeInsets.all(SizeManager.sizeSp16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                  color: getColor(planDetailsModel)
                                      .withOpacity(0.1),
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
                                    text: planDetailsModel?.planName ?? "",
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
                          // SizedBox(
                          //   height: SizeManager.sizeSp24,
                          // ),
                          // TextApp(
                          //   text:
                          //       "You are currently enjoying a free trial month of your subscription.🎉",
                          //   textAlign: TextAlign.center,
                          //   fontWeight: FontWeight.w400,
                          //   fontSize: 14.sp,
                          // ),
                          SizedBox(
                            height: SizeManager.sizeSp16,
                          ),
                          Row(
                            children: [
                              TextApp(
                                multiLang: false,
                                text:
                                    "${planDetailsModel?.planFianlPrice?.toStringAsFixed(2) ?? 0.0} € ",
                                style: textTheme.headlineLarge?.copyWith(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.colorPrimary,
                                ),
                              ),
                              TextApp(
                                multiLang: false,
                                text:
                                    "/ ${planDetailsModel?.planDuration ?? ''}",
                                color: AppColors.textNatural700,
                              )
                            ],
                          ),
                          SizedBox(
                            height: SizeManager.sizeSp24,
                          ),
                          Column(
                            children: List.generate(
                              planDetailsModel?.planFeatures?.length ?? 0,
                              (index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeManager.sizeSp8),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssetPaths.featureIcon,
                                      ),
                                      SizedBox(
                                        width: SizeManager.sizeSp4,
                                      ),
                                      SizedBox(
                                        width: 280.r,
                                        child: TextApp(
                                          multiLang: false,
                                          text: planDetailsModel
                                                  ?.planFeatures?[index] ??
                                              "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyMedium?.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.textNatural700,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: SizeManager.sizeSp16,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 115.r,
        child: BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
          builder: (context, state) {
            return SubmitButtonWidget(
                title: translate(LocalizationKeys.subscription) ?? "",
                buttonColor: isGuest ? null:(planDetailsModel?.hasPlan ?? true)
                    ? AppColors.buttonGrey
                    : null,
                onClicked: () {
                  if (isGuest) {
                    AppBottomSheet.showLoginOrRegisterDialog(context);
                  } else {
                    if (!(planDetailsModel?.hasPlan ?? true)) {
                      currentBloc.add(
                        SubscribeEvent(widget.planID),
                      );
                    }
                  }
                });
          },
        ),
      ),
    );
  }

  Widget _methodWidget(String title, String logoPath, VoidCallback onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFF5F5F5)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(logoPath),
              SizedBox(width: 16.w),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF606060),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_outlined,
                  color: Color(0xff1D2939)),
            ],
          ),
        ),
      ),
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

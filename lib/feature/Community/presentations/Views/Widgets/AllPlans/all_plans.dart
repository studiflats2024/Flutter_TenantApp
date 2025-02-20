import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/subscription_plans_model.dart';
import 'package:vivas/feature/Community/Data/Repository/CommunityScreen/community_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/community_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanDetails/plan_details.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_list_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

class ViewPlans extends BaseStatelessWidget {
  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CommunityBloc(
          CommunityRepositoryImplementation(
            CommunityManager(dioApiManager),
          ),
        );
      },
      child: ViewPlansWithBloc(),
    );
  }
}

class ViewPlansWithBloc extends BaseStatefulScreenWidget {
  const ViewPlansWithBloc({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _ViewPlans();
  }
}

class _ViewPlans extends BaseScreenState<ViewPlansWithBloc>
    with PaginationManager<SubscriptionPlansModel> {
  List<SubscriptionPlansModel>? subscriptions;

  @override
  void initState() {
    currentBloc.add(GetCommunitySubscriptionPlans(1));
    super.initState();
  }

  CommunityBloc get currentBloc => context.read<CommunityBloc>();

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalizationKeys.plans,
        withBackButton: true,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: BlocConsumer<CommunityBloc, CommunityState>(
        listener: (context, state) {
          if (state is CommunityLoadedSubscriptionPlansState) {
            subscriptions = state.subscriptionPlansModel;
            alignPaginationWithApi(false, false, state.subscriptionPlansModel);
          } else if (state is CommunityErrorState) {
            showFeedbackMessage(state.errorMassage);
          }
        },
        builder: (context, state) {
          return PagingSwipeToRefreshListWidget(
            reachedEndOfScroll: () {
              if (shouldLoadMore) {}
            },
            itemWidget: (index) {
              var item = getUpdatedData[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.textWhite,
                  borderRadius: BorderRadius.all(SizeManager.circularRadius10),
                  border: Border(
                    top: BorderSide(color: getColor(item), width: 4.r),
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
                            borderRadius:
                                BorderRadius.all(SizeManager.circularRadius10),
                            color: getColor(item).withOpacity(0.1),
                          ),
                          child: SvgPicture.asset(
                            getAsset(item),
                          ),
                        ),
                        SizedBox(
                          width: SizeManager.sizeSp12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextApp(
                              text: (item.isTrial ?? false)
                                  ? "Free Trial Month"
                                  : item.planName ?? "",
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                            SizedBox(
                              height: SizeManager.sizeSp4,
                            ),
                            if (item.isTrial ?? false) ...[
                              TextApp(
                                text: (item.isTrial ?? false)
                                    ? "Enjoy exclusive access "
                                    : "${item.planFianlPrice}",
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
                    SizedBox(
                      height: SizeManager.sizeSp24,
                    ),
                    if (item.isTrial ?? false) ...[
                      TextApp(
                        text:
                            "You are currently enjoying a free trial month of your subscription.🎉",
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
                                "€ ${item.planFianlPrice?.toStringAsFixed(2) ?? 0.0}",
                            style: textTheme.headlineLarge?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorPrimary,
                            ),
                          ),
                          TextApp(
                            multiLang: false,
                            text: " / ${item.planDuration ?? ''}",
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
                          text: "Billed annually, save ${item.planDiscount}%",
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
                    expandedItem(getUpdatedData[index]),
                    SizedBox(
                      height: SizeManager.sizeSp16,
                    ),
                    SubmitButtonWidget(
                      withoutShape: true,
                      padding: EdgeInsets.zero,
                      sizeTop: 0,
                      sizeBottom: 0,
                      title: translate(LocalizationKeys.getStarted) ?? "",
                      onClicked: () {
                        PlanDetails.open(
                            context,
                            false,
                            getUpdatedData[index].id ?? "",
                            getUpdatedData[index].planName ?? "");
                      },
                    )
                  ],
                ),
              );
            },
            swipedToRefresh: () {
              currentBloc.add(GetCommunitySubscriptionPlans(1));
            },
            listLength: getUpdatedData.length,
            showPagingLoader: currentLoadingState,
            itemClickable: false,
          );
        },
      ),
    );
  }

  Widget expandedItem(SubscriptionPlansModel model) {
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
                model.planFeatures?.length ?? 0,
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
                          text: model.planFeatures?[index] ?? "",
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

  String getAsset(SubscriptionPlansModel item) {
    switch (item.planDurationInMonths!) {
      case 12:
        return AppAssetPaths.rateIcon;
      case 1:
        return AppAssetPaths.personIcon;
      default:
        return AppAssetPaths.calenderIcon2;
    }
  }

  Color getColor(SubscriptionPlansModel item) {
    switch (item.planDurationInMonths!) {
      case 12:
        return AppColors.cardBorderGold;
      case 1:
        return AppColors.cardBorderGreen;
      default:
        return AppColors.colorPrimary;
    }
  }
}

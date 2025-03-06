import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/plan_history_model.dart';
import 'package:vivas/feature/Community/Data/Repository/PlanHistory/plan_history_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/PlanHistory/plan_history_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanHistory/plan_invoice_details.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_list_widget.dart';
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

  DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
        create: (ctx) => PlanHistoryBloc(PlanHistoryRepositoryImplementation(
            CommunityManager(dioApiManager))),
        child: const PlanHistoryWithBloc());
  }
}

class PlanHistoryWithBloc extends BaseStatefulScreenWidget {
  const PlanHistoryWithBloc({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _PlanHistoryWithBloc();
  }
}

class _PlanHistoryWithBloc extends BaseScreenState<PlanHistoryWithBloc>
    with PaginationManager<Plan> {
  PlanHistoryModel? planHistoryModel;

  @override
  void initState() {
    getTransactions(
      1,
    );
    super.initState();
  }

  getTransactions(int pageNumber, {bool isFirst = true}) {
    currentBloc.add(
      GetPlanTransactions(
        PagingListSendModel(
            pageNumber: isFirst ? 1 : (planHistoryModel?.currentPage ?? 0) + 1),
      ),
    );
  }

  PlanHistoryBloc get currentBloc => context.read<PlanHistoryBloc>();

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
      body: BlocConsumer<PlanHistoryBloc, PlanHistoryState>(
        listener: (context, state) {
          if (state is PlanHistoryLoading) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is GetPlanHistory) {
            planHistoryModel = state.planHistoryModel;
            alignPaginationWithApi(
                state.planHistoryModel.hasPreviousPage ?? false,
                state.planHistoryModel.hasNextPage ?? false,
                state.planHistoryModel.data ?? []);
            stopPaginationLoading();
          }
        },
        builder: (context, state) {
          return PagingSwipeToRefreshListWidget(
            reachedEndOfScroll: () {
              if (shouldLoadMore) {
                if (planHistoryModel?.currentPage != null &&
                    planHistoryModel?.currentPage !=
                        planHistoryModel?.totalPages) {
                  startPaginationLoading();
                  getTransactions((planHistoryModel?.currentPage ?? 0) + 1,
                      isFirst: false);
                }
                // paginatedActivities();
              }
            },
            itemWidget: (index) {
              return item(getUpdatedData[index]);
            },
            swipedToRefresh: () {
              resetPagination();
              getTransactions(1);
            },
            listLength: getUpdatedData.length,
            showPagingLoader: currentLoadingState,
            itemClickable: false,
          );
        },
      ),
    );
  }

  Widget item(Plan plan) {
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
                      color: getColor(plan).withOpacity(0.1),
                    ),
                    child: SvgPicture.asset(
                      getAsset(plan),
                    ),
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(
                        text: plan.planName ?? "",
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
                        return CommunityInvoiceDetails(plan.invoiceId ?? "");
                      },
                    ),
                  );
                },
                child: Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(SizeManager.circularRadius8),
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
                text: " € ${plan.planPrice?.toStringAsFixed(2) ?? 0.0} ",
                style: textTheme.headlineLarge?.copyWith(
                  fontSize: FontSize.fontSize18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorPrimary,
                ),
              ),
              TextApp(
                multiLang: false,
                text: "/ ${plan.planDuration ?? ''}",
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
                            text: plan.paymentDate ?? "",
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
                        text: LocalizationKeys.invoiceNo,
                        fontSize: FontSize.fontSize12,
                        color: AppColors.textNatural700,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp4,
                      ),
                      TextApp(
                        text: plan.invoiceNo ?? "",
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
  }

  String getAsset(Plan? item) {
    switch (item?.planDurationInMonths) {
      case 12:
        return AppAssetPaths.rateIcon;
      case 1:
        return AppAssetPaths.personIcon;
      default:
        return AppAssetPaths.calenderIcon2;
    }
  }

  Color getColor(Plan? item) {
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

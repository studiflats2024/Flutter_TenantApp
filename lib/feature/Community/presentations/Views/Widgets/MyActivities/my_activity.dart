import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/app_route.dart';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Managers/my_activity_enum.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/my_activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/my_activity_response.dart';
import 'package:vivas/feature/Community/Data/Repository/MyActivity/my_activity_repository.dart';
import 'package:vivas/feature/Community/Data/Repository/MyActivity/my_activity_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/MyActivity/my_activity_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/ActivityDetails/activity_details.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MyActivities/my_activity_rate.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

class MyActivities extends BaseStatelessWidget {
  static const routeName = '/my-activity-community';

  MyActivities({super.key});

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

  DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
      create: (ctx) => MyActivityBloc(
        MyActivityRepositoryImplementation(
          CommunityManager(dioApiManager),
        ),
      ),
      child: MyActivitiesWithBloc(),
    );
  }
}

class MyActivitiesWithBloc extends BaseStatefulScreenWidget {
  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _MyActivitiesWithBloc();
  }
}

class _MyActivitiesWithBloc extends BaseScreenState<MyActivitiesWithBloc>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller =
        TabController(length: MyActivityStatus.values.length, vsync: this);
  }

  MyActivityBloc get currentBloc => context.read<MyActivityBloc>();

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Activity",
        withBackButton: true,
        multiLan: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: AppColors.textWhite,
        ),
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColors.cardBorderPrimary100)),
            ),
            child: TabBar(
              controller: controller,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.colorPrimary,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textNatural400,
              ),
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
              indicatorColor: AppColors.colorPrimary,
              indicator: UnderlineTabIndicator(
                  borderRadius: BorderRadius.only(
                      topLeft: SizeManager.circularRadius4,
                      topRight: SizeManager.circularRadius4),
                  borderSide: const BorderSide(
                      color: AppColors.colorPrimary, width: 2)),
              tabs: List.generate(MyActivityStatus.values.length, (index) {
                return Tab(
                  child: Text(MyActivityStatus.values[index].name),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: controller,
                children:
                    List.generate(MyActivityStatus.values.length, (index) {
                  return MyActivitiesPage(
                      MyActivityStatus.values[index], currentBloc);
                })),
          )
        ],
      ),
    );
  }
}

class MyActivitiesPage extends BaseStatefulScreenWidget {
  final MyActivityBloc myActivityBloc;
  final MyActivityStatus status;

  const MyActivitiesPage(this.status, this.myActivityBloc, {super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _MyActivitiesPage();
  }
}

class _MyActivitiesPage extends BaseScreenState<MyActivitiesPage>
    with PaginationManager<MyActivitiesModel> {
  int? removeIndex;

  @override
  void initState() {
    getMyActivity(isFirst: true);
    super.initState();
  }

  MyActivityResponse myActivities = MyActivityResponse();

  getMyActivity({
    required bool isFirst,
    int pageNum = 1,
  }) {
    widget.myActivityBloc.add(GetMyActivityEvent(
        MyActivitySendModel(pageNum: pageNum, status: widget.status), isFirst));
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocProvider.value(
      value: widget.myActivityBloc,
      child: BlocConsumer<MyActivityBloc, MyActivityState>(
        listener: (context, state) {
          if (state is MyActivityLoading) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is GetMyActivityState) {
            myActivities = state.data;
            alignPaginationWithApi(state.data.hasPreviousPage ?? false,
                state.data.hasNextPage ?? false, state.data.data ?? []);
            stopPaginationLoading();
          } else if (state is UnEnrollState) {
            removeIndex = state.position;
          } else if (state is MyActivityErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage) ?? ""
                : state.errorMassage);
          }
        },
        builder: (context, state) {
          if (state is MyActivityLoading && getUpdatedData.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (getUpdatedData.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssetPaths.communityNoActivities),
                SizedBox(
                  height: SizeManager.sizeSp16,
                ),
                TextApp(
                  multiLang: true,
                  fontSize: FontSize.fontSize18,
                  color: AppColors.textMainColor,
                  text: LocalizationKeys.emptyActivityTitle,
                ),
                TextApp(
                  multiLang: true,
                  fontSize: FontSize.fontSize14,
                  color: AppColors.textNatural700,
                  text: LocalizationKeys.emptyActivityDesc,
                ),
              ],
            );
          } else {
            return PagingSwipeToRefreshGridListWidget(
              reachedEndOfScroll: () {
                if (shouldLoadMore) {
                  if (myActivities.currentPage != null &&
                      myActivities.currentPage != myActivities.totalPages) {
                    startPaginationLoading();
                    getMyActivity(
                        isFirst: false,
                        pageNum: (myActivities.currentPage ?? 0) + 1);
                  }
                  // paginatedActivities();
                }
              },
              // itemClickable: false,
              listPadding: EdgeInsets.symmetric(horizontal: 8.w),
              itemWidget: (int index) {
                var data = getUpdatedData[index];
                return item(
                    MyActivityModel(
                        id: data.activityId ?? "",
                        image: data.activityPhoto ?? "",
                        name: data.activityName ?? "",
                        activitiesType:
                            data.activityType ?? ActivitiesType.course,
                        date: data.activityDate ?? '',
                        consultSubscription: data.consultSubscriptions ?? [],
                        hasRated: data.hasRated ?? false,
                        rate: data.reviews ?? 0),
                    index);
              },
              swipedToRefresh: () {
                resetPagination();
                getMyActivity(isFirst: true);
              },
              listLength: getUpdatedData.length,
              showPagingLoader: currentLoadingState,
            );
          }
        },
      ),
    );
  }

  void autoDeleteItem(int index) {
    if (mounted) {
      getUpdatedData.removeAt(index);
      setState(() {
        // Remove from list after animation
        removeIndex = null;
      });
    }
  }

  Widget item(MyActivityModel model, index) {
    ValueKey dismissKey = ValueKey(index);
    return GestureDetector(
      onTap: () {
        _goToDetails(model);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        transform: Matrix4.translationValues(
          removeIndex != null && removeIndex == index ? -500 : 0,
          // Move item left
          0,
          0,
        ),
        onEnd: () {
          if (removeIndex != null) {
            autoDeleteItem(removeIndex!);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.cardBorderPrimary100,
            ),
            borderRadius: BorderRadius.all(SizeManager.circularRadius10),
          ),
          child: Row(
            children: [
              Container(
                width: 105.r,
                height: 112.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: SizeManager.circularRadius10,
                      bottomLeft: SizeManager.circularRadius10),
                  image: model.image.isLink
                      ? DecorationImage(
                          image: NetworkImage(
                            model.image,
                          ),
                          fit: BoxFit.cover)
                      : const DecorationImage(
                          image:
                              AssetImage(AppAssetPaths.imageMonthlyActivities),
                          fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(SizeManager.sizeSp8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.status == MyActivityStatus.cancelled
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeManager.sizeSp15,
                                    vertical: SizeManager.sizeSp8,
                                  ),
                                  decoration: BoxDecoration(
                                      color: AppColors
                                          .cardBackgroundActivityCancelled,
                                      borderRadius: BorderRadius.all(
                                          SizeManager.circularRadius8)),
                                  child: TextApp(
                                    multiLang: true,
                                    text: LocalizationKeys.cancelled,
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: AppColors.textActivityCancelled,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeManager.sizeSp15,
                                    vertical: SizeManager.sizeSp8,
                                  ),
                                  decoration: BoxDecoration(
                                      color:
                                          cardTypeColor(model.activitiesType),
                                      borderRadius: BorderRadius.all(
                                          SizeManager.circularRadius8)),
                                  child: TextApp(
                                    multiLang: false,
                                    text: model.activitiesType.name.capitalize,
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: textActivityColor(
                                          model.activitiesType),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                          widget.status == MyActivityStatus.ongoing
                              ? PopupMenuButton(
                                  constraints: BoxConstraints(minWidth: 285.r),
                                  padding: EdgeInsets.zero,
                                  position: PopupMenuPosition.under,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      height: SizeManager.sizeSp32,
                                      value: "un_enroll",
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextApp(
                                            multiLang: true,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            text: LocalizationKeys.unEnroll,
                                          ),
                                          SvgPicture.asset(
                                            AppAssetPaths.unEnrollIcon,
                                          )
                                        ],
                                      ),
                                    ),
                                    // PopupMenuItem(
                                    //     height: SizeManager.sizeSp4,
                                    //     child: const Divider()),
                                    // PopupMenuItem(
                                    //   value: "add_to_calender",
                                    //   height: SizeManager.sizeSp32,
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       TextApp(
                                    //         multiLang: true,
                                    //         fontSize: 14.sp,
                                    //         fontWeight: FontWeight.w400,
                                    //         text: LocalizationKeys.addToCalender,
                                    //       ),
                                    //       SvgPicture.asset(
                                    //         AppAssetPaths.calenderIconOutline,
                                    //         color: AppColors.colorPrimary,
                                    //         width: SizeManager.sizeSp20,
                                    //         height: SizeManager.sizeSp20,
                                    //       )
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                  onSelected: (value) {
                                    if (value == "un_enroll") {
                                      widget.myActivityBloc
                                          .add(UnEnrollEvent(model.id, index));
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          SizeManager.circularRadius10)),
                                  child: SvgPicture.asset(
                                    AppAssetPaths.menuIcon,
                                    fit: BoxFit.none,
                                  ),
                                )
                              : widget.status == MyActivityStatus.completed
                                  ? Visibility(
                                      visible: !(model.hasRated ?? false),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) {
                                                return MyActivityRating(
                                                  model,
                                                  widget.myActivityBloc,
                                                  index,
                                                );
                                              },
                                            ),
                                          ).then((v){
                                            resetPagination();
                                            getMyActivity(
                                                isFirst: true,
                                                pageNum: 1);
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          AppAssetPaths.editRateIcon,
                                        ),
                                      ),
                                    )
                                  : Container(),
                        ],
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 140.r,
                            child: TextApp(
                              text: model.name,
                              fontSize: FontSize.fontSize12,
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.textMainColor,
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(AppAssetPaths.rateIcon),
                              TextApp(
                                text: " ${model.rate}",
                                fontSize: FontSize.fontSize12,
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.textNatural700,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp8,
                      ),
                      footer(model)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _goToDetails(MyActivityModel model) {
    ActivityDetails.open(
        AppRoute.mainNavigatorKey.currentContext!,
        false,
        true,
        ActivityDetailsSendModel(model.id, model.activitiesType,
            status: widget.status));
  }

  Color cardTypeColor(
    ActivitiesType status,
  ) {
    switch (status) {
      case ActivitiesType.course:
        return AppColors.cardBackgroundCourse;
      case ActivitiesType.workshop:
        return AppColors.cardBackgroundWorkshop;
      case ActivitiesType.event:
        return AppColors.cardBackgroundEvent;
      case ActivitiesType.consultant:
        return AppColors.cardBackgroundConsultant;
      default:
        return AppColors.cardBackgroundCourse;
    }
  }

  Color textActivityColor(
    ActivitiesType status,
  ) {
    switch (status) {
      case ActivitiesType.course:
        return AppColors.textCourse;
      case ActivitiesType.workshop:
        return AppColors.textWorkshop;
      case ActivitiesType.event:
        return AppColors.textEvent;
      case ActivitiesType.consultant:
        return AppColors.textConsultant;
      default:
        return AppColors.textCourse;
    }
  }

  Widget footer(
    MyActivityModel model,
  ) {
    if (model.activitiesType == ActivitiesType.event) {
      return Row(
        children: [
          SvgPicture.asset(
            AppAssetPaths.calenderIconOutline,
            color: AppColors.colorPrimary,
          ),
          SizedBox(
            width: SizeManager.sizeSp8,
          ),
          Row(
            children: [
              TextApp(
                text: model.date,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
                fontSize: 12.sp,
                color: AppColors.textNatural700,
              ),
            ],
          ),
        ],
      );
    } else if (model.activitiesType == ActivitiesType.consultant) {
      return Row(
        children: [
          SvgPicture.asset(
            AppAssetPaths.calenderIconOutline,
            color: AppColors.colorPrimary,
          ),
          SizedBox(
            width: SizeManager.sizeSp8,
          ),
          TextApp(
            text:
                "${model.consultSubscription?[0].day}, ${model.consultSubscription?[0].date}, ${model.consultSubscription?[0].time}",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.textNatural700,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          SvgPicture.asset(
            AppAssetPaths.calenderIconOutline,
            color: AppColors.colorPrimary,
          ),
          SizedBox(
            width: SizeManager.sizeSp8,
          ),
          TextApp(
            text: "${model.date} ",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.textNatural700,
          ),
        ],
      );
    }
  }
}

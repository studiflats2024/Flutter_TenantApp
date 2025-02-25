import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/paginated_club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Repository/ClubActivites/club_activities_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/ClubActivity/club_activity_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/ActivityDetails/activity_details.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class ClubActivity extends BaseStatelessWidget {
  ClubActivity({super.key});

  static const routeName = '/club-activity-community';

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
        create: (context) => ClubActivityBloc(
            ClubActivitiesRepositoryImplementation(
                CommunityManager(dioApiManager))),
        child: const ClubActivityWithBloc());
  }
}

class ClubActivityWithBloc extends BaseStatefulScreenWidget {
  const ClubActivityWithBloc({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _ClubActivityWithBloc();
  }
}

class _ClubActivityWithBloc extends BaseScreenState<ClubActivityWithBloc>
    with PaginationManager<ActivitiesModel> {
  int currentIndex = 0;

  ClubActivityModel activities = ClubActivityModel();

  ActivitiesType currentType = ActivitiesType.all;

  @override
  void initState() {
    firstLoad();
    super.initState();
  }

  ClubActivityBloc get currentBloc => context.read<ClubActivityBloc>();

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocConsumer<ClubActivityBloc, ClubActivityState>(
      listener: (context, state) {
        if (state is ClubActivityLoading) {
          showLoading();
        } else {
          hideLoading();
        }

        if (state is GetClubActivityState) {
          activities = state.activitiesModel;
          alignPaginationWithApi(
              state.activitiesModel.hasPreviousPage ?? false,
              state.activitiesModel.hasNextPage ?? false,
              state.activitiesModel.data ?? []);
          stopPaginationLoading();
        } else if (state is ChangeActivityTypeState) {
          if (state.type != currentType) {
            currentType = state.type;
            firstLoad();
          }
        } else if (state is ErrorClubActivityState) {
          showFeedbackMessage(state.isLocalizationKey
              ? (translate(state.errorMassage) ?? "")
              : state.errorMassage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocalizationKeys.clubActivity,
            systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: AppColors.textWhite,
            ),
            withBackButton: true,
            centerTitle: true,
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: ListView(
            children: [
              SizedBox(
                height: SizeManager.sizeSp8,
              ),
              Container(
                height: 32.r,
                margin: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
                child: ListView.separated(
                  shrinkWrap: true,
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemCount: ActivitiesType.values.length,
                  itemBuilder: (context, index) {
                    return itemCategory(ActivitiesType.values[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: SizeManager.sizeSp8,
                    );
                  },
                ),
              ),
              if (getUpdatedData.isNotEmpty) ...[
                SizedBox(
                  height: 680.r,
                  child: PagingSwipeToRefreshGridListWidget(
                    reachedEndOfScroll: () {
                      if (shouldLoadMore) {
                        startPaginationLoading();
                        paginatedActivities();
                      }
                    },
                    // itemClickable: false,
                    listPadding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemWidget: (int index) {
                      return itemActivity(getUpdatedData[index]);
                    },
                    swipedToRefresh: () {
                      resetPagination();
                      firstLoad();
                    },
                    listLength: getUpdatedData.length,
                    showPagingLoader: currentLoadingState,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  firstLoad() {
    currentBloc.add(GetClubActivityEvent(
        PagingCommunityActivitiesListSendModel(activitiesType: currentType)));
  }

  paginatedActivities() {
    currentBloc.add(GetClubActivityEvent(PagingCommunityActivitiesListSendModel(
        pageNumber: activities.currentPage! + 1, activitiesType: currentType)));
  }

  Widget itemActivity(ActivitiesModel model) {
    return InkWell(
      onTap: () {
        ActivityDetails.open(
            AppRoute.mainNavigatorKey.currentContext!,
            false,
            false,
            ActivityDetailsSendModel(model.activityId ?? "",
                model.activityType ?? ActivitiesType.course));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardBorderPrimary100),
          borderRadius: BorderRadius.all(SizeManager.circularRadius10),
        ),
        margin: EdgeInsets.only(bottom: SizeManager.sizeSp16),
        padding: EdgeInsets.all(SizeManager.sizeSp8),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 115.r,
                  height: 87.r,
                  decoration: (model.activityMedia?.isLink ?? false)
                      ? null
                      : BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage(
                                AppAssetPaths.imageMonthlyActivities,
                              ),
                              fit: BoxFit.cover),
                          borderRadius:
                              BorderRadius.all(SizeManager.circularRadius10),
                        ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(SizeManager.circularRadius10),
                    child: (model.activityMedia?.isLink ?? false)
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: (model.activityMedia ?? ""),
                          )
                        : null,
                  ),
                ),
                SizedBox(
                  width: SizeManager.sizeSp16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentIndex == 0) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeManager.sizeSp15,
                          vertical: SizeManager.sizeSp6,
                        ),
                        decoration: BoxDecoration(
                            color: cardTypeColor(
                                model.activityType ?? ActivitiesType.course),
                            borderRadius:
                                BorderRadius.all(SizeManager.circularRadius4)),
                        child: TextApp(
                          multiLang: false,
                          text: model.activityType?.name.capitalize ?? "",
                          style: textTheme.bodyLarge?.copyWith(
                            color: textActivityColor(
                                model.activityType ?? ActivitiesType.course),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeManager.sizeSp8,
                      ),
                    ],
                    SizedBox(
                      width: 170.r,
                      child: TextApp(
                        text: model.activityName ?? "",
                        fontSize: FontSize.fontSize12,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.textMainColor,
                      ),
                    ),
                    SizedBox(
                      height: SizeManager.sizeSp4,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(AppAssetPaths.rateIcon),
                        TextApp(
                          text: " ${model.activityRating ?? 0}",
                          fontSize: FontSize.fontSize12,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.textNatural700,
                        ),
                        TextApp(
                          text: " (${model.ratingCount} Review)",
                          fontSize: FontSize.fontSize12,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.textNatural700,
                        )
                      ],
                    ),
                    if (model.availableSeats != model.activitySeats) ...[
                      SizedBox(
                        height: SizeManager.sizeSp4,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: SizeManager.sizeSp4,
                            right: SizeManager.sizeSp8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: SizeManager.circularRadius2,
                            bottomLeft: SizeManager.circularRadius2,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFC1111A).withOpacity(0.5),
                              const Color(0xFFE2888D).withOpacity(0.5),
                              const Color(0xFFF1C0C2).withOpacity(0.5),
                              const Color(0xFFFDECED),
                            ],
                          ),
                        ),
                        child: TextApp(
                          text: "${model.availableSeats} Seat Leave",
                          fontSize: FontSize.fontSize10,
                          color: AppColors.textRed,
                          lineHeight: 1.3.r,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ]
                  ],
                ),
              ],
            ),
            SizedBox(
              height: SizeManager.sizeSp8,
            ),
            Container(
              height: 1.r,
              color: AppColors.cardBorderPrimary100,
            ),
            SizedBox(
              height: SizeManager.sizeSp8,
            ),
            footer(model),
            SizedBox(
              height: SizeManager.sizeSp8,
            ),
          ],
        ),
      ),
    );
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
    ActivitiesModel model,
  ) {
    if (model.activityType == ActivitiesType.event) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                    right: BorderSide(color: AppColors.cardBorderPrimary100)),
              ),
              margin: EdgeInsets.only(right: SizeManager.sizeSp8),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppAssetPaths.calenderIconOutline,
                    color: AppColors.colorPrimary,
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                  TextApp(
                    text: "${model.postponedTo ?? model.activityDate} ",
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: AppColors.textNatural700,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssetPaths.timerIcon,
                  color: AppColors.colorPrimary,
                ),
                SizedBox(
                  width: SizeManager.sizeSp8,
                ),
                TextApp(
                  text: "${model.activityTime}",
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: AppColors.textNatural700,
                ),
              ],
            ),
          ),
        ],
      );
    } else if (model.activityType == ActivitiesType.consultant) {
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
            text: model.activityDate ?? "",
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
            text: "${model.activityDate}",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.textNatural700,
          ),
        ],
      );
    }
  }

  Widget itemCategory(ActivitiesType activityType) {
    return InkWell(
      onTap: () {
        currentBloc.add(ChangeFilterActivityType(activityType));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(SizeManager.circularRadius10),
            border: Border.all(color: AppColors.cardBorderPrimary100),
            color: currentType == activityType
                ? AppColors.colorPrimary
                : AppColors.textWhite),
        padding: activityType.asset != null
            ? EdgeInsets.all(SizeManager.sizeSp8)
            : EdgeInsets.symmetric(
                vertical: SizeManager.sizeSp8,
                horizontal: SizeManager.sizeSp16),
        child: Row(
          children: [
            if (activityType.asset != null) ...[
              SvgPicture.asset(
                activityType.asset!,
                fit: BoxFit.contain,
                color: currentType == activityType ? AppColors.textWhite : null,
                width: SizeManager.sizeSp16,
                height: SizeManager.sizeSp16,
              ),
              SizedBox(
                width: SizeManager.sizeSp8,
              ),
            ],
            TextApp(
              text: activityType.code,
              fontSize: FontSize.fontSize12,
              color: currentType == activityType
                  ? AppColors.textWhite
                  : AppColors.textShade3,
            )
          ],
        ),
      ),
    );
  }
}

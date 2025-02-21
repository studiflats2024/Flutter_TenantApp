import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:readmore/readmore.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/enroll_activity_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/activity_details_model.dart';
import 'package:vivas/feature/Community/Data/Repository/ActivityDetails/activity_details_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/ActivityDetails/activity_details_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/ActivityDetails/Components/activity_deatils_header.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/ActivityDetails/Components/activity_details_sections.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/ActivityDetails/Components/activity_details_sub_header.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/ActivityDetails/Components/enroll_consultant_widget.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/AllPlans/all_plans.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

//ignore: must_be_immutable
class ActivityDetails extends BaseStatelessWidget {
  static const routeName = '/activity-details';

  static const argumentActivityDetailsSendModel =
      '/activity-details_send_model';

  static const argumentActivityDetailsFromMyActivity = 'is-from-my-activity';

  static Future<void> open(BuildContext context, bool replacement,
      bool isFromMyActivity, ActivityDetailsSendModel sendModel) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentActivityDetailsSendModel: sendModel,
        argumentActivityDetailsFromMyActivity: isFromMyActivity
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentActivityDetailsSendModel: sendModel,
        argumentActivityDetailsFromMyActivity: isFromMyActivity
      });
    }
  }

  ActivityDetails({super.key});

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  ActivityDetailsSendModel activityDetailsSendModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[ActivityDetails.argumentActivityDetailsSendModel]
          as ActivityDetailsSendModel;

  bool fromMyActivity(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[ActivityDetails.argumentActivityDetailsFromMyActivity]
          as bool;

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
        create: (context) => ActivityDetailsBloc(
            ActivityDetailsRepositoryImplementation(
                CommunityManager(dioApiManager))),
        child: ActivityDetailsWithBloc(
            activityDetailsSendModel(context), fromMyActivity(context)));
  }
}

class ActivityDetailsWithBloc extends BaseStatefulScreenWidget {
  final ActivityDetailsSendModel sendModel;
  final bool fromMyActivity;

  const ActivityDetailsWithBloc(this.sendModel, this.fromMyActivity,
      {super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _ActivityDetailsWithBloc();
  }
}

class _ActivityDetailsWithBloc
    extends BaseScreenState<ActivityDetailsWithBloc> {
  ActivityDetailsModel activityDetailsModel = ActivityDetailsModel();

  String filter = "All";
  List<String> ratings = ["All", "5", "4", "3", "2", "1"];
  List<Rating> ratingFilter = [];

  @override
  void initState() {
    super.initState();
    currentBloc.add(GetActivityDetailsEvent(widget.sendModel));
  }

  ActivityDetailsBloc get currentBloc => context.read<ActivityDetailsBloc>();

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ActivityDetailsHeader(
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: BlocConsumer<ActivityDetailsBloc, ActivityDetailsState>(
        listener: (context, state) {
          if (state is ActivityDetailsLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is GetActivityDetailsState) {
            activityDetailsModel = state.activityDetailsModel;
            ratingFilter = activityDetailsModel.ratings ?? [];
          } else if (state is FilterRatingState) {
            filter = state.filter;
            ratingFilter = filterRating(activityDetailsModel, state.filter);
          } else if (state is SuccessEnrollState) {
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                customColumns: [
                  SvgPicture.asset(AppAssetPaths.communityIconSuccess),
                  SizedBox(
                    height: SizeManager.sizeSp8,
                  ),
                  TextApp(
                    text: LocalizationKeys.enrollSuccessMessage,
                    multiLang: true,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp16,
                  ),
                ],
                dialogDecoration: BoxDecoration(
                    color: AppColors.textWhite,
                    borderRadius:
                        BorderRadius.all(SizeManager.circularRadius10)),
                confirmButtonColor: AppColors.colorPrimary,
                confirmButtonText:
                    translate(LocalizationKeys.goToMyActivity) ?? "",
              ),
            );
          } else if (state is ActivityDetailsErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage) ?? ""
                : state.errorMassage);
          }
        },
        builder: (context, state) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 250.r,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(AppAssetPaths.imageMonthlyActivities),
                    fit: BoxFit.fill,
                  )),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: widget.fromMyActivity ? 580.r : 500.r,
                  decoration: BoxDecoration(
                    color: AppColors.textWhite,
                    borderRadius: BorderRadius.only(
                        topRight: SizeManager.circularRadius20,
                        topLeft: SizeManager.circularRadius20),
                  ),
                  padding: EdgeInsets.all(SizeManager.sizeSp16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ActivityDetailsSubHeader(
                          widget.fromMyActivity,
                          status: widget.sendModel.status,
                          activityDetailsModel: activityDetailsModel,
                        ),
                        SizedBox(
                          height: SizeManager.sizeSp12,
                        ),
                        if (activityDetailsModel.activityType ==
                                ActivitiesType.course ||
                            activityDetailsModel.activityType ==
                                ActivitiesType.workshop) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: AppColors
                                                  .cardBorderPrimary100))),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(AppAssetPaths.seatIcon),
                                      SizedBox(
                                        width: SizeManager.sizeSp8,
                                      ),
                                      TextApp(
                                        multiLang: false,
                                        text:
                                            "${activityDetailsModel.availableSeats} ${translate(LocalizationKeys.seats)}",
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textNatural700,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: AppColors
                                                  .cardBorderPrimary100))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          AppAssetPaths.communityStartDateIcon),
                                      SizedBox(
                                        width: SizeManager.sizeSp8,
                                      ),
                                      TextApp(
                                        multiLang: false,
                                        text: "Feb 15 , 2025",
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textNatural700,
                                        ),
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
                                        AppAssetPaths.communityEndDateIcon),
                                    SizedBox(
                                      width: SizeManager.sizeSp8,
                                    ),
                                    TextApp(
                                      multiLang: false,
                                      text: "Feb 25 , 2025",
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textNatural700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeManager.sizeSp12,
                          ),
                        ],
                        ActivityDetailsSections(
                            activityDetailsModel, widget.fromMyActivity,
                            status: widget.sendModel.status),
                        TextApp(
                          text: LocalizationKeys.description,
                          fontWeight: FontWeight.w500,
                          multiLang: true,
                          fontSize: FontSize.fontSize16,
                        ),
                        SizedBox(
                          height: SizeManager.sizeSp8,
                        ),
                        ReadMoreText(
                          activityDetailsModel.activityDescription ?? "",
                          trimCollapsedText:
                              translate(LocalizationKeys.readMore)!,
                          trimExpandedText:
                              translate(LocalizationKeys.readLess)!,
                          moreStyle: const TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.w500),
                          lessStyle: const TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: SizeManager.sizeSp16,
                        ),
                        if (activityDetailsModel.ratings?.isNotEmpty ??
                            false) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextApp(
                                text: LocalizationKeys.reviews,
                                fontWeight: FontWeight.w500,
                                multiLang: true,
                                fontSize: FontSize.fontSize16,
                              ),
                              // SvgPicture.asset(
                              //     AppAssetPaths.communityEditPinIcon)
                            ],
                          ),
                          SizedBox(
                            height: SizeManager.sizeSp16,
                          ),
                          SizedBox(
                            height: 32.r,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: ratings.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: SizeManager.sizeSp8,
                                );
                              },
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (ratings[index] != filter) {
                                      currentBloc.add(
                                          FilterRatingEvent(ratings[index]));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: ratings[index] == filter
                                            ? AppColors.colorPrimary
                                            : AppColors.textWhite,
                                        border: Border.all(
                                            color:
                                                AppColors.cardBorderPrimary100),
                                        borderRadius: BorderRadius.all(
                                            SizeManager.circularRadius8)),
                                    padding:
                                        EdgeInsets.all(SizeManager.sizeSp8),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppAssetPaths.rateIcon,
                                          color: ratings[index] == filter
                                              ? AppColors.textWhite
                                              : AppColors.textShade3,
                                          width: SizeManager.sizeSp14,
                                          height: SizeManager.sizeSp14,
                                        ),
                                        SizedBox(
                                          width: SizeManager.sizeSp8,
                                        ),
                                        TextApp(
                                          text: ratings[index],
                                          color: ratings[index] == filter
                                              ? AppColors.textWhite
                                              : AppColors.textShade3,
                                          fontWeight: FontWeight.w500,
                                          fontSize: FontSize.fontSize14,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: SizeManager.sizeSp16,
                          ),
                          Column(
                            children:
                                List.generate(ratingFilter.length, (index) {
                              var item = ratingFilter[index];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      SizeManager.circularRadius10),
                                  border: Border.all(
                                    color: AppColors.cardBorderPrimary100,
                                  ),
                                ),
                                padding: EdgeInsets.all(
                                  SizeManager.sizeSp16,
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: SizeManager.sizeSp8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  AppColors.textWhite,
                                              radius: SizeManager.sizeSp24,
                                              child: item.userPhoto != null &&
                                                      item.userPhoto!.isLink
                                                  ? Container(
                                                      width:
                                                          SizeManager.sizeSp24,
                                                      height:
                                                          SizeManager.sizeSp24,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              item.userPhoto!),
                                                        ),
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      AppAssetPaths
                                                          .profileDefaultAvatar,
                                                    ),
                                            ),
                                            SizedBox(
                                              width: SizeManager.sizeSp8,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextApp(
                                                  text: item.userName ?? '',
                                                  fontSize: FontSize.fontSize14,
                                                ),
                                                SizedBox(
                                                  height: SizeManager.sizeSp4,
                                                ),
                                                TextApp(
                                                  text: item.ratingDate ?? '',
                                                  fontSize: FontSize.fontSize12,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textShade3,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppAssetPaths.rateIcon,
                                              width: SizeManager.sizeSp14,
                                              height: SizeManager.sizeSp14,
                                            ),
                                            SizedBox(
                                              width: SizeManager.sizeSp8,
                                            ),
                                            TextApp(
                                              text: item.ratingValue.toString(),
                                              color: AppColors.colorPrimary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontSize.fontSize14,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: SizeManager.sizeSp24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: SizeManager.sizeSp8),
                                      child: TextApp(
                                        text: item.comment ?? '',
                                        fontSize: FontSize.fontSize14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                          SizedBox(
                            height: SizeManager.sizeSp8,
                          ),
                          SubmitButtonWidget(
                            title: translate(LocalizationKeys.viewAll)!,
                            titleStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.colorPrimary),
                            withoutShape: true,
                            buttonColor: AppColors.textWhite,
                            outlinedBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  SizeManager.circularRadius10),
                              side: const BorderSide(
                                color: AppColors.colorPrimary,
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            onClicked: () {},
                            child: SizedBox(
                              height: SizeManager.sizeSp15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextApp(
                                    text: LocalizationKeys.viewAll,
                                    multiLang: true,
                                  ),
                                  SizedBox(
                                    width: SizeManager.sizeSp8,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.colorPrimary,
                                    size: SizeManager.sizeSp20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: widget.fromMyActivity
          ? null
          : SizedBox(
              height: 112.r,
              child: SubmitButtonWidget(
                title: (activityDetailsModel.hasEnrolled ?? false) &&
                        (activityDetailsModel.hasPlan ?? false)
                    ? ""
                    : translate(LocalizationKeys.enrollNow)!,
                onClicked: () {
                  if (!(activityDetailsModel.hasPlan ?? false)) {
                    ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                        confirmButtonText:
                            translate(LocalizationKeys.viewPlans) ?? "",
                        confirmButtonColor: AppColors.colorPrimary,
                        onConfirm: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return ViewPlans();
                          }));
                        },
                        dialogDecoration: BoxDecoration(
                            color: AppColors.textWhite,
                            borderRadius:
                                BorderRadius.all(SizeManager.circularRadius10)),
                        customColumns: [
                          SvgPicture.asset(
                              AppAssetPaths.communityIconViewPlans),
                          SizedBox(
                            height: SizeManager.sizeSp8,
                          ),
                          TextApp(
                            text: LocalizationKeys.unHaveSubscription,
                            multiLang: true,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            height: SizeManager.sizeSp16,
                          ),
                        ],
                      ),
                    );
                  } else if (activityDetailsModel.hasEnrolled ?? false) {
                  } else if (activityDetailsModel.activityType !=
                      ActivitiesType.consultant) {
                    currentBloc.add(
                      EnrollEvent(
                        EnrollActivitySendModel(
                          activityDetailsModel.activityId ?? '',
                          activityDetailsModel.activityType!,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return EnrollConsultantWidget(
                        activityDetailsModel,
                        currentBloc,
                      );
                    }));
                  }
                },
                withoutShape: true,
                buttonColor: (activityDetailsModel.hasEnrolled ?? false) &&
                        (activityDetailsModel.hasPlan ?? false)
                    ? AppColors.buttonGrey
                    : null,
                decoration: const BoxDecoration(
                    color: AppColors.textWhite,
                    border: Border(
                        top:
                            BorderSide(color: AppColors.cardBorderPrimary100))),
                child: (activityDetailsModel.hasEnrolled ?? false) &&
                        (activityDetailsModel.hasPlan ?? false)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check,
                            color: AppColors.textNatural700,
                          ),
                          SizedBox(
                            width: SizeManager.sizeSp8,
                          ),
                          TextApp(
                            text: translate(LocalizationKeys.alreadyEnrolled)!,
                            color: AppColors.textNatural700,
                          ),
                        ],
                      )
                    : null,
              ),
            ),
    );
  }

  List<Rating> filterRating(ActivityDetailsModel details, String filter) {
    List<Rating> ratingList = [];
    if (filter == "All") {
      return details.ratings ?? [];
    } else {
      for (int i = 0; i < details.ratings!.length; i++) {
        if (details.ratings![i].ratingValue == int.parse(filter)) {
          ratingList.add(details.ratings![i]);
        }
      }
      return ratingList;
    }
  }
}

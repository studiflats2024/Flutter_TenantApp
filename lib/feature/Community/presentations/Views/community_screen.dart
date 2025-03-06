import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/subscription_plans_model.dart';
import 'package:vivas/feature/Community/Data/Repository/CommunityScreen/community_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/community_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_about.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_activities.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_club_activities.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_header.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MainScreen/community_subscription.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/OnBoarding/community_on_boarding.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/size_manager.dart';

class CommunityScreen extends BaseStatelessWidget {
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
      child: const CommunityScreenWithBloc(),
    );
  }
}

class CommunityScreenWithBloc extends BaseStatefulScreenWidget {
  const CommunityScreenWithBloc({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _CommunityScreen();
  }
}

class _CommunityScreen extends BaseScreenState<CommunityScreenWithBloc> {
  PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();

  @override
  void initState() {
    super.initState();
    currentBloc.add(CheckLoggedInEvent());
    currentBloc.add(GetCommunityMonthlyActivities(1));
    currentBloc.add(GetCommunityClubActivities(1));
    currentBloc.add(GetCommunitySubscriptionPlans(1));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!(await preferencesManager.getCommunityFirstTime() ?? false)) {
        preferencesManager.setCommunityFirstTime();
        AboutCommunity.showOnBoarding(context, false);
      }
    });
  }

  ClubActivityModel? clubActivityModel;
  ClubActivityModel? monthlyActivities;
  List<SubscriptionPlansModel>? subscriptions;

  bool isGuest = true;

  CommunityBloc get currentBloc => context.read<CommunityBloc>();

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          currentBloc.add(GetCommunityMonthlyActivities(1));
          currentBloc.add(GetCommunityClubActivities(1));
          currentBloc.add(GetCommunitySubscriptionPlans(1));
        },
        child: BlocConsumer<CommunityBloc, CommunityState>(
          listener: (context, state) {
            if (state is CommunityLoadingState) {
              showLoading();
            } else {
              hideLoading();
            }
            if (state is CommunityLoadedMonthlyActivityState) {
              monthlyActivities = state.clubActivityModel;
            } else if (state is IsLoggedInState) {
              isGuest = false;
            } else if (state is IsGuestModeState) {
              AppBottomSheet.showLoginOrRegisterDialog(context);
              isGuest = true;
            } else if (state is CommunityLoadedClubActivityState) {
              clubActivityModel = state.clubActivityModel;
            } else if (state is CommunityLoadedSubscriptionPlansState) {
              subscriptions = state.subscriptionPlansModel;
            } else if (state is CommunityErrorState) {
              showFeedbackMessage(state.errorMassage);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: SizeManager.sizeSp16,
                  vertical: SizeManager.sizeSp8,
                ),
                child: ListView(
                  shrinkWrap: true,
                  clipBehavior: Clip.none,
                  children: [
                    CommunityHeader(isGuest),
                    if (monthlyActivities != null &&
                        (monthlyActivities?.data?.isNotEmpty ?? false)) ...[
                      CommunityActivities(monthlyActivities!)
                    ],
                    if (clubActivityModel != null &&
                        (clubActivityModel?.data?.isNotEmpty ?? false)) ...[
                      CommunityClubActivities(clubActivityModel!)
                    ],
                    CommunityAbout(),
                    if (subscriptions != null &&
                        (subscriptions?.isNotEmpty ?? false))
                      SizedBox(
                        height: 330.r,
                        child: CommunitySubscription(subscriptions!),
                      ),
                    SizedBox(
                      height: SizeManager.sizeSp6,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: SizeManager.sizeSp20),
        child: FloatingActionButton(
          onPressed: () {
            AboutCommunity.showOnBoarding(context, true);
          },
          backgroundColor: AppColors.colorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(SizeManager.circularRadius15),
          ),
          child: SvgPicture.asset(AppAssetPaths.informationIcon),
        ),
      ),
    );
  }
}

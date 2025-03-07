import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/invite_frind_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/invitations_history_model.dart';
import 'package:vivas/feature/Community/Data/Repository/InviteFriend/invite_friend_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/InviteFrindes/invite_frindes_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/InviteFrindes/invite_again.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_list_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_time_form_field_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class HistoryInviteFriends extends BaseStatelessWidget {
  HistoryInviteFriends({super.key});

  static const routeName = '/invitation-history-community';

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
        create: (ctx) => InviteFrindesBloc(
              InviteFriendRepositoryImplementation(
                CommunityManager(
                  dioApiManager,
                ),
              ),
            ),
        child: const HistoryInviteFriendsWithBloc());
  }
}

class HistoryInviteFriendsWithBloc extends BaseStatefulScreenWidget {
  const HistoryInviteFriendsWithBloc({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _HistoryInviteFriendsWithBloc();
  }
}

class _HistoryInviteFriendsWithBloc
    extends BaseScreenState<HistoryInviteFriendsWithBloc>
    with PaginationManager<InviteModel> {
  InvitationsHistoryModel model = InvitationsHistoryModel();

  InviteFrindesBloc get currentBloc => context.read<InviteFrindesBloc>();

  @override
  void initState() {
    getInvitationHistory(1);
    super.initState();
  }

  getInvitationHistory(pageNumber) {
    currentBloc.add(GetInvitationsHistoryEvent(
        PagingListSendModel(pageNumber: pageNumber)));
  }

  paginatedInvitationHistory() {
    currentBloc.add(GetInvitationsHistoryEvent(
        PagingListSendModel(pageNumber: (model.currentPage ?? 0) + 1)));
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: AppColors.textWhite),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            AppAssetPaths.backIcon,
          ),
        ),
        title: TextApp(
          text: LocalizationKeys.historyInvitation,
          multiLang: true,
          fontWeight: FontWeight.w500,
          fontSize: SizeManager.sizeSp16,
        ),
      ),
      body: BlocConsumer<InviteFrindesBloc, InviteFrindesState>(
        listener: (context, state) {
          if (state is InviteFriendsLoading) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is InviteHistoryFriendState) {
            model = state.model;
            alignPaginationWithApi(state.model.hasPreviousPage ?? false,
                state.model.hasNextPage ?? false, state.model.data ?? []);
            stopPaginationLoading();
          } else if (state is InviteFriendState) {
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                customColumns: [
                  SvgPicture.asset(AppAssetPaths.communityIconSuccess),
                  SizedBox(
                    height: SizeManager.sizeSp8,
                  ),
                  TextApp(
                    text: state.isReminder
                        ? LocalizationKeys.reminderSent
                        : LocalizationKeys.invitationSent,
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
              ),
            );
          } else if (state is ErrorInviteFriendState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage) ?? ""
                : state.errorMassage);
          }
        },
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: SizeManager.sizeSp16),
            child: PagingSwipeToRefreshListWidget(
              reachedEndOfScroll: () {
                if (shouldLoadMore) {
                  if (model.hasNextPage ?? false) {
                    startPaginationLoading();
                    paginatedInvitationHistory();
                  }
                }
              },
              itemWidget: (index) {
                return itemHistory(context, getUpdatedData[index], index);
              },
              swipedToRefresh: () {
                getInvitationHistory(1);
              },
              listLength: getUpdatedData.length,
              showPagingLoader: currentLoadingState,
              itemClickable: false,
            ),
          );
        },
      ),
    );
  }

  Widget itemHistory(BuildContext context, InviteModel model, int index) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.cardBorderPrimary100),
              borderRadius: BorderRadius.all(SizeManager.circularRadius10)),
          margin: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
          child: Padding(
            padding: EdgeInsets.all(SizeManager.sizeSp16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // CircleAvatar(
                    //   radius: SizeManager.sizeSp25,
                    //   backgroundColor: Colors.transparent,
                    //   backgroundImage:
                    //       const AssetImage(AppAssetPaths.profileDefaultAvatar),
                    // ),
                    // SizedBox(
                    //   width: SizeManager.sizeSp15,
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: model.name ?? "",
                          fontSize: 12.sp,
                        ),
                        SizedBox(
                          height: SizeManager.sizeSp4,
                        ),
                        TextApp(
                          text: model.email ?? "",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textNatural700,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PopupMenuButton(
                      constraints: BoxConstraints(minWidth: 275.r),
                      icon: SvgPicture.asset(AppAssetPaths.menuIcon),
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          height: SizeManager.sizeSp32,
                          value: "invite_again",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextApp(
                                multiLang: true,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                text: LocalizationKeys.inviteAgain,
                              ),
                              SvgPicture.asset(
                                AppAssetPaths.messageIcon,
                                color: AppColors.colorPrimary,
                                fit: BoxFit.none,
                              )
                            ],
                          ),
                        ),
                        PopupMenuItem(
                            height: SizeManager.sizeSp4,
                            child: const Divider()),
                        PopupMenuItem(
                          value: "reminder",
                          height: SizeManager.sizeSp32,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextApp(
                                multiLang: true,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                text: LocalizationKeys.reminder,
                              ),
                              SvgPicture.asset(
                                AppAssetPaths.reminderIcon,
                                color: AppColors.colorPrimary,
                              )
                            ],
                          ),
                        )
                      ],
                      onSelected: (value) {
                        if (value == "invite_again") {
                          AppBottomSheet.openBaseBottomSheet(
                            context: context,
                            child: SizedBox(
                                height: 200.r,
                                child: InviteAgain(currentBloc, model)),
                          );
                        } else if (value == "reminder") {
                          currentBloc.add(InviteFriendEvent(
                              InviteFriendSendModel(
                                  name: model.name ?? "",
                                  email: model.email ?? "",
                                  phone: model.phone ?? "",
                                  invitationDate: model.date ?? DateTime.now(),
                                  isReminder: true)));
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(SizeManager.circularRadius10)),
                    ),
                    TextApp(
                      text: DateFormat("dd/MM/yyyy")
                          .format(model.date ?? DateTime.now()),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textNatural700,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        if (index != getUpdatedData.length - 1) ...[
          SizedBox(
            height: SizeManager.sizeSp16,
          )
        ]
      ],
    );
  }
}

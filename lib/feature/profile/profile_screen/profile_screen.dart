import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/apis/managers/profile_api_manger.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/QrDetails/qr_details.dart';
import 'package:vivas/feature/PlanSettings/plan_settinngs.dart';
import 'package:vivas/feature/auth/login/screen/login_screen.dart';
import 'package:vivas/feature/contact_support/screen/contact_support_screen.dart';
import 'package:vivas/feature/invoices/screen/invoices_screen.dart';
import 'package:vivas/feature/my_documents/screen/my_documents_screen.dart';
import 'package:vivas/feature/notification_list/screen/notification_list_screen.dart';
import 'package:vivas/feature/problem/screen/my_problem_screen.dart';
import 'package:vivas/feature/profile/edit_personal_information/edit_personal_info_screen.dart';
import 'package:vivas/feature/profile/profile_screen/bloc/profile_bloc.dart';
import 'package:vivas/feature/profile/profile_screen/bloc/profile_repository.dart';
import 'package:vivas/feature/profile/profile_screen/widget/change_language_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_text_button.dart';
import 'package:vivas/feature/widgets/delete_bottom_sheet_widget.dart';
import 'package:vivas/feature/profile/profile_screen/widget/profile_view.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/wishlist/screen/wishlist_screen.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(ProfileRepository(
        profileApiManger: ProfileApiManger(dioApiManager, context),
        preferencesManager: GetIt.I<PreferencesManager>(),
      )),
      child: const ProfileScreenWithBloc(),
    );
  }
}

class ProfileScreenWithBloc extends BaseStatefulScreenWidget {
  const ProfileScreenWithBloc({super.key});

  @override
  BaseScreenState<ProfileScreenWithBloc> baseScreenCreateState() {
    return _ProfileScreenWithBloc();
  }
}

class _ProfileScreenWithBloc extends BaseScreenState<ProfileScreenWithBloc> {
  ProfileInfoApiModel? profileInfo;
  bool isGuestMode = true;

  @override
  void initState() {
    _getProfileData();
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: BlocConsumer<ProfileBloc, GetProfileState>(
          listener: (context, state) {
            if (state is GetProfileLoadingState) {
              showLoading();
            } else {
              hideLoading();
            }
            if (state is GetProfileErrorState) {
              showFeedbackMessage(state.isLocalizationKey
                  ? translate(state.errorMassage)!
                  : state.errorMassage);
            } else if (state is GetProfileLoadedState) {
              isGuestMode = false;
              profileInfo = state.data;
            } else if (state is GuestModeStateState) {
              isGuestMode = true;
            } else if (state is LogoutState) {
              _openLoginScreen();
            } else if (state is DeleteAccountState) {
              _deletedAccount();
            }
          },
          builder: (context, state) {
            return buildPersonalInformationWidget(profileInfo);
          },
        ));
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget buildPersonalInformationWidget(ProfileInfoApiModel? profileInfo) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 68.h, left: 22.w, right: 23.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate(LocalizationKeys.profile)!,
              style: themeData.textTheme.labelMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            SizedBox(height: 16.h),
            _buildImageNameWidget(profileInfo, isGuestMode),
            SizedBox(height: 28.h),
            Text(
              translate(LocalizationKeys.settings)!,
              style: themeData.textTheme.labelMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            SizedBox(height: 16.h),
            Column(
              children: [
                if (!isGuestMode) ...[
                  _buildProfileSection(
                      assetPath: AppAssetPaths.personalInformationIcon,
                      title: translate(LocalizationKeys.personalInformation)!,
                      onActionClicked: () =>
                          {_openEditPersonalInfoScreen(profileInfo)}),
                  _buildProfileSection(
                      assetPath: AppAssetPaths.qrIcon,
                      title: translate(LocalizationKeys.qrCode)!,
                      onActionClicked: () => {
                            CommunityQrDetails.open(
                              context,
                              false,
                              true
                            )
                          }),
                  _buildProfileSection(
                      assetPath: AppAssetPaths.myPlanIcon,

                      title: translate(LocalizationKeys.planSettings)!,
                      onActionClicked: () => {
                            PlanSettings.open(
                              context,
                              false
                            )
                          }),
                  _buildProfileSection(
                      assetPath: AppAssetPaths.navWishlistIcon,
                      title: translate(LocalizationKeys.wishlist)!,
                      onActionClicked: () => {_wishlistWidget()}),
                  _buildProfileSection(
                      assetPath: AppAssetPaths.paymentIcon,
                      title: translate(LocalizationKeys.invoices)!,
                      onActionClicked: _invoicesClicked),
                  _buildProfileSection(
                      assetPath: AppAssetPaths.bookingsIcon,
                      title: translate(LocalizationKeys.myDocuments)!,
                      onActionClicked: _openMyDocumentsScreen),
                  _buildProfileSection(
                      assetPath: AppAssetPaths.reportProblemIcon,
                      title: translate(
                          LocalizationKeys.reportProblemInTheApartment)!,
                      onActionClicked: _openMyProblemScreen),
                  _buildProfileSection(
                      assetPath: AppAssetPaths.supportChatIcon,
                      title: translate(LocalizationKeys.support)!,
                      onActionClicked: _supportChatClicked),
                  _buildProfileSection(
                      assetPath: AppAssetPaths.notificationsIcon,
                      title: translate(LocalizationKeys.notifications)!,
                      onActionClicked: _openNotificationScreen),
                ],
                _buildProfileSection(
                    assetPath: AppAssetPaths.languageIcon,
                    title: translate(LocalizationKeys.language)!,
                    onActionClicked: _changeLanguageClicked),
                if (!isGuestMode) ...[
                  GestureDetector(
                    onTap: _deleteAccountClicked,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssetPaths.deleteAccountIcon),
                            SizedBox(width: 16.h),
                            Text(translate(LocalizationKeys.deleteacc)!,
                                style: themeData.textTheme.labelMedium
                                    ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.lisTileTitle))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  const Divider(
                      thickness: 0.5, color: AppColors.dividerBackground),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: _logoutClicked,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssetPaths.signOutIcon),
                            SizedBox(width: 16.h),
                            Text(translate(LocalizationKeys.signOut)!,
                                style: themeData.textTheme.labelMedium
                                    ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.lisTileTitle))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14)
          ],
        ),
      ),
    );
  }

  Widget _buildImageNameWidget(
      ProfileInfoApiModel? profileInfo, bool isGuestMode) {
    final profilePic = profileInfo?.profileImageUrl;
    return Card(
        elevation: 3,
        color: Colors.white,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 32.w, top: 15.h, bottom: 13.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: profilePic == null
                    ? Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    AppAssetPaths.profileDefaultAvatar))),
                      )
                    : ClipOval(
                        child: AppCachedNetworkImage(
                          imageUrl: profilePic,
                          width: 88,
                          height: 88,
                          boxFit: BoxFit.cover,
                          placeholder: Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        AppAssetPaths.profileDefaultAvatar))),
                          ),
                        ),
                      ),
              ),
              isGuestMode
                  ? AppTextButton.withTitle(
                      title: translate(LocalizationKeys.logIn)!,
                      onPressed: _openLoginScreen,
                    )
                  : Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileInfo?.fullName ?? "",
                              style: themeData.textTheme.labelMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              profileInfo?.email.emailMask ?? "",
                              style: themeData.textTheme.labelMedium?.copyWith(
                                  color: AppColors.appFormFieldTitle,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  height: 2),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ));
  }

  Widget _buildProfileSection(
      {required String assetPath,
      required String title,
      required Function() onActionClicked}) {
    return GestureDetector(
      onTap: onActionClicked,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(assetPath, color: AppColors.textMainColor,),
              SizedBox(width: 16.h),
              Text(title,
                  style: themeData.textTheme.labelMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lisTileTitle)),
              const Spacer(),
              SvgPicture.asset(AppAssetPaths.forwardNextIcon),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(thickness: 0.5, color: AppColors.dividerBackground),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  ProfileBloc get currentBloc => BlocProvider.of<ProfileBloc>(context);

  void _getProfileData() {
    currentBloc.add(GetProfileData());
  }

  void _logoutClicked() {
    currentBloc.add(LogoutClickedEvent());
  }

  void _deleteAccountClicked() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: DeleteBottomSheetWidget(_deleteAccountClickedEvent),
        title: translate(LocalizationKeys.deleteacc)!);
  }

  void _deleteAccountClickedEvent() {
    currentBloc.add(DeleteAccountClickedEvent());
  }

  Future<void> _openEditPersonalInfoScreen(ProfileInfoApiModel? profile) async {
    if (profile != null) {
      await PersonalInformation.open(context, profile)
          .then((value) => _getProfileData());
      /*
      await EditPersonalInformationScreen.open(context, profile)
          .then((value) => _getProfileData());

       */
    }
  }

  void _wishlistWidget() {
    WishlistScreen.open(context, false);
  }

  void _openLoginScreen() {
    LoginScreen.open(context);
  }

  void _deletedAccount() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
  }

  void _openNotificationScreen() async {
    await NotificationListScreen.open(context);
  }

  Future<void> _invoicesClicked() async {
    await InvoicesScreen.open(context);
  }

  Future<void> _openMyDocumentsScreen() async {
    await MyDocumentsScreen.open(context);
  }

  Future<void> _openMyProblemScreen() async {
    await MyProblemScreen.open(context);
  }

  void _supportChatClicked() async {
    await ContactSupportScreen.open(context);
    // await ComplaintsListScreen.open(context);
  }

  void _changeLanguageClicked() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: const ChangeLanguageWidget(),
        title: translate(LocalizationKeys.changeLanguage)!);
  }
}

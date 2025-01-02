import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/profile_api_manger.dart';
import 'package:vivas/feature/profile/edit_personal_information/edit_personal_info_screen.dart';
import 'package:vivas/feature/profile/profile_screen/bloc/profile_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../../apis/models/profile/profile_info_api_model.dart';
import '../../../../utils/feedback/feedback_message.dart';
import '../bloc/profile_repository.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  static const routeName = '/personal_information-screen';
  static const argumentProfileInfoApiModel = 'ProfileInfoApiModel';

  static Future<void> open(
      BuildContext context, ProfileInfoApiModel profile) async {
    await Navigator.of(context).pushNamed(routeName,
        arguments: {argumentProfileInfoApiModel: profile});
  }

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  ProfileInfoApiModel profileInfoApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[PersonalInformation.argumentProfileInfoApiModel]
          as ProfileInfoApiModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(ProfileRepository(
        profileApiManger: ProfileApiManger(dioApiManager , context),
        preferencesManager: GetIt.I<PreferencesManager>(),
      )),
      child:  PersonalInformationView(profile: profileInfoApiModel(context),),
    );
  }
}

class PersonalInformationView extends BaseStatefulScreenWidget {
  final ProfileInfoApiModel profile;

  const PersonalInformationView({required this.profile, super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return PersonalInformationState();
  }
}

class PersonalInformationState
    extends BaseScreenState<PersonalInformationView> {
  late ProfileInfoApiModel profile;
  @override
  void initState() {
    profile = widget.profile;
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorPrimary,
        title: Text(
          translate(LocalizationKeys.profile)!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: BlocConsumer<ProfileBloc , GetProfileState>(
        listener: (context, state) {
          if (state is GetProfileLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is GetProfileLoadedState) {
            profile = state.data;
          }
          else if (state is GetProfileErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          }
        },
          builder: (context, state) {
            return state  is GetProfileLoadingState ? Container(child: const Center(child: CircularProgressIndicator(),),): Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      child: SizedBox(
                        width: 400.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 180.h,
                              width: 400.w,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage(AppAssetPaths.containerBg),
                                    fit: BoxFit.fill),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: ()  {
                                       EditPersonalInformationScreen.open(
                                              context, profile)
                                          .then((value) => _getProfileData());
                                    },
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              width: 20.w,
                                              height: 20.h,
                                              decoration: BoxDecoration(
                                                  color: AppColors.badgeColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: AppColors.colorPrimary,
                                                  size: 15,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 83.w,
                                    height: 83.h,
                                    margin: EdgeInsets.symmetric(vertical: 8.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      image: profile.profileImageUrl.contains("http")
                                          ? DecorationImage(
                                          image: CachedNetworkImageProvider(profile.profileImageUrl),
                                          fit: BoxFit.cover)
                                          : const DecorationImage(
                                          image:
                                          AssetImage(AppAssetPaths
                                              .profileDefaultAvatar),
                                          fit: BoxFit.fitWidth),

                                    ),
                                  ),
                                  // Container(
                                  //   width: 83.w,
                                  //   height: 83.h,
                                  //   child: CircleAvatar(
                                  //     foregroundColor: Colors.white,
                                  //     backgroundColor: Colors.white,
                                  //     radius: 80,
                                  //     child: widget.profile.profileImageUrl
                                  //             .contains("http")
                                  //         ? Image.network(
                                  //             widget.profile.profileImageUrl,
                                  //             fit: BoxFit.cover)
                                  //         : Image.asset(AppAssetPaths
                                  //             .profileDefaultAvatar),
                                  //   ),
                                  // ),
                                  Text(
                                   profile.fullName,
                                    style: const TextStyle(
                                      color: Color(0xFF423E5B),
                                      fontSize: 24,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: const Text(
                                      'Personal Information',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF13263E),
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        translate(LocalizationKeys.email)!,
                                        style: const TextStyle(
                                          color: Color(0xFF13263E),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      // Text(
                                      //  profile.mailVerified
                                      //       ? "Verified"
                                      //       : "UnVerified",
                                      //   style: TextStyle(
                                      //     color: profile.mailVerified
                                      //         ? AppColors.colorPrimary
                                      //         : Colors.red,
                                      //     fontSize: 12,
                                      //     fontFamily: 'Poppins',
                                      //     fontWeight: FontWeight.w800,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    profile.email.emailMask,
                                    style: const TextStyle(
                                      color: Color(0xFF787579),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    translate(LocalizationKeys.about)!,
                                    style: const TextStyle(
                                      color: Color(0xFF13263E),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    profile.about == ""
                                        ? "You are not set about "
                                        : profile.about,
                                    style: const TextStyle(
                                      color: Color(0xFF787579),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        translate(
                                            LocalizationKeys.whatsAppNumber)!,
                                        style: const TextStyle(
                                          color: Color(0xFF13263E),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        profile.phoneVerified
                                            ? "Verified"
                                            : "UnVerified",
                                        style: TextStyle(
                                          color: profile.phoneVerified
                                              ? AppColors.colorPrimary
                                              : Colors.red,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    profile.mobile.phoneMask,
                                    style: const TextStyle(
                                      color: Color(0xFF787579),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },

      ),
    );
  }

  ProfileBloc get currentBloc => BlocProvider.of<ProfileBloc>(context);

  void _getProfileData() {
    currentBloc.add(GetProfileData());
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivas/_core/widgets/base_dialog_widget.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/profile_api_manger.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/profile/edit_personal_information/otp/otp_screen_wrapper.dart';
import 'package:vivas/feature/profile/profile_screen/bloc/profile_repository.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/picker_option_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../widgets/text_field/phone_number_form_filed_widget.dart';
import 'bloc/edit_profile_bloc.dart';

class EditPersonalInformationScreen extends StatelessWidget {
  static const routeName = '/edit_personal_information-screen';

  const EditPersonalInformationScreen({super.key});

  static const argumentProfileInfoApiModel = 'ProfileInfoApiModel';

  static Future<void> open(
    BuildContext context,
    ProfileInfoApiModel profile,
  ) async {
    await Navigator.of(context).pushNamed(
        EditPersonalInformationScreen.routeName,
        arguments: {argumentProfileInfoApiModel: profile});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (context) => EditProfileBloc(ProfileRepository(
        profileApiManger: ProfileApiManger(GetIt.I<DioApiManager>(), context),
        preferencesManager: GetIt.I<PreferencesManager>(),
      )),
      child:
          EditPersonalInformationScreenWithBloc(profileInfoApiModel(context)),
    );
  }

  ProfileInfoApiModel profileInfoApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[EditPersonalInformationScreen.argumentProfileInfoApiModel]
          as ProfileInfoApiModel;
}

//ignore: must_be_immutable
class EditPersonalInformationScreenWithBloc extends BaseStatefulScreenWidget {
  ProfileInfoApiModel profileInfo;

  EditPersonalInformationScreenWithBloc(this.profileInfo, {super.key});

  @override
  BaseScreenState<EditPersonalInformationScreenWithBloc>
      baseScreenCreateState() {
    return _EditPersonalInformationScreenWithBloc();
  }
}

class _EditPersonalInformationScreenWithBloc
    extends BaseScreenState<EditPersonalInformationScreenWithBloc>
    with AuthValidate {
  File? _profileImage;
  final _picker = ImagePicker();

  late TextEditingController nameController;

  late TextEditingController aboutController;

  late TextEditingController emailController;

  late TextEditingController phoneController;

  late String _fullName = widget.profileInfo.fullName;
  late String _about = widget.profileInfo.about;
  late String _currentEmail = widget.profileInfo.email;
  late String _currentPhoneNumber = widget.profileInfo.mobile;

  String? _newEmail;
  String? _newPhoneNumber;
  String? _password;
  bool isToUpdateEmail = true;

  GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  final TextEditingController otpEditingController = TextEditingController();

  @override
  void initState() {
    nameController = TextEditingController(text: widget.profileInfo.fullName);
    aboutController = TextEditingController(text: widget.profileInfo.about);
    emailController = TextEditingController(text: widget.profileInfo.email.emailMask);
    phoneController = TextEditingController(text: widget.profileInfo.mobile.phoneMask);
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: SvgPicture.asset(
                AppAssetPaths.arrowBackIcon,
              ),
            ),
          ),
          title: Text(
            translate(LocalizationKeys.editPersonalInformation)!,
            style: themeData.textTheme.labelMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18.spMax),
          ),
          centerTitle: true,
        ),
        body: BlocListener<EditProfileBloc, EditProfileState>(
          listener: (context, state) async {
            if (state is EditProfileLoadingState) {
              showLoading();
            } else {
              hideLoading();
            }
            if (state is EditProfileErrorState) {
              showFeedbackMessage(state.isLocalizationKey
                  ? translate(state.errorMassage)!
                  : state.errorMassage);
            } else if (state is BasicDataSuccessfullyUpdatedState) {
              getUpdatedLocalData();
              nameController.text = (await PreferencesManager().getName()) ??
                  widget.profileInfo.fullName;
              aboutController.text = (await PreferencesManager().getAbout()) ??
                  widget.profileInfo.about;
              showFeedbackMessage(state.message);
            } else if (state is ProfileImageSuccessfullyUpdatedState) {
              showFeedbackMessage(state.message);
            } else if (state is EditFormValidatedState) {
              dismissBottomSheet();
              if (isToUpdateEmail) {
                updateEmail();
              } else {
                updatePhoneNumber();
              }
            } else if (state is EditFormNotValidatedState) {
              autoValidateMode = AutovalidateMode.always;
            } else if (state is CurrentEmailSuccessfullyUpdatedState) {
              getUpdatedLocalData();
              emailController.text = ((await PreferencesManager().getEmail()) ??
                  _currentEmail).emailMask;
              _openOtpScreen();
            } else if (state is CurrentPhoneNumberSuccessfullyUpdatedState) {
              getUpdatedLocalData();
              phoneController.text =
                  ((await PreferencesManager().getMobileNumber()) ??
                      _currentPhoneNumber).phoneMask;
              _openOtpScreen();
            } else if (state is LocalDataUpdatedSuccessfullyState) {
              widget.profileInfo = state.data;
            }
          },
          child: buildPersonalInformationWidget(),
        ));
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget buildPersonalInformationWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, left: 23.w, right: 25.w),
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildImageWidget(),
          SizedBox(height: 10.h),
          // const Divider(thickness: 1, color: AppColors.dividerBackground),
          Form(
            child: Column(
              children: [
                AppTextFormField(
                  title: translate(LocalizationKeys.fullName)!,
                  controller: nameController,
                  onSaved: (value) {},
                  hintText: '',
                  readOnly: true,
                  enable: false,
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate(LocalizationKeys.fullName)!
                            .concatenateAsterisk,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.appFormFieldTitle,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppBottomSheet.openAppBottomSheet(
                              context: context,
                              child: _buildEditNameAboutWidget(),
                              title: translate(LocalizationKeys.editInfo)!);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: Icon(
                            Icons.edit,
                            size: 13.r,
                            color: AppColors.suffixIcon,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                AppTextFormField(
                  title: translate(LocalizationKeys.about)!,
                  controller: aboutController,
                  hintText: '',
                  onSaved: (value) {},
                  readOnly: true,
                  enable: false,
                ),
                SizedBox(height: 10.h),
                AppTextFormField(
                  title: translate(LocalizationKeys.email)!,
                  controller: emailController,
                  hintText: '',
                  readOnly: true,
                  textInputType: TextInputType.emailAddress,
                  onSaved: (value) {},
                  suffixIcon: Icons.edit,
                  onTapSuffixIcon: () {
                    AppBottomSheet.openAppBottomSheet(
                        context: context,
                        child: _buildEditEmailWidget(_currentEmail),
                        title: translate(LocalizationKeys.editInfo)!);
                  },
                ),
                SizedBox(height: 10.h),
                AppTextFormField(
                  title: translate(LocalizationKeys.whatsAppNumber)!,
                  controller: phoneController,
                  hintText: '',
                  textInputType: TextInputType.phone,
                  onSaved: (value) {},
                  readOnly: true,
                  suffixIcon: Icons.edit,
                  onTapSuffixIcon: () {
                    AppBottomSheet.openAppBottomSheet(
                        context: context,
                        child:
                            _buildEditPhoneNumberWidget(_currentPhoneNumber),
                        title: translate(LocalizationKeys.editInfo)!);
                  },
                ),
              ],
            ),
          ),
          // Container(
          //   width: 300.w,
          //   height: 40.h,
          //   margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          //   clipBehavior: Clip.antiAlias,
          //   decoration: ShapeDecoration(
          //     color: AppColors.colorPrimary,
          //     shape: RoundedRectangleBorder(
          //       side: const BorderSide(width: 1, color: Color(0xFF798CA4)),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   child: Center(
          //     child: Text(
          //       translate(LocalizationKeys.update)!,
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(
          //         color: Colors.white,
          //         fontSize: 18,
          //         fontFamily: 'Poppins',
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 24.0.h),
          //   child: Row(
          //     children: [
          //       CircleAvatar(
          //         backgroundColor: Colors.white,
          //         child: InkWell(
          //           radius: 100,
          //           onTap: () {
          //             Navigator.pop(context);
          //           },
          //           child: Padding(
          //             padding: EdgeInsets.all(8.h),
          //             child: SvgPicture.asset(AppAssetPaths.arrowBackIcon),
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 16.w),
          //       Text(translate(LocalizationKeys.editPersonalInformation)!,
          //           style: themeData.textTheme.labelMedium?.copyWith(
          //               color: Colors.black,
          //               fontWeight: FontWeight.w500,
          //               fontSize: 18.spMax))
          //     ],
          //   ),
          // ),

          // Padding(
          //     padding: EdgeInsets.symmetric(vertical: 16.h),
          //     child: _buildPersonalInfoSection(
          //         title: translate(LocalizationKeys.fullName)!,
          //         value: widget.profileInfo.fullName,
          //         onActionClicked: () {
          //           showEditBottomSheet(_buildEditNameAboutWidget(),
          //               translate(LocalizationKeys.editInfo)!);
          //         })),
          /*_buildAboutInfoSection(widget.profileInfo.about),
          _buildDivider(),
          _buildPersonalInfoSection(
              title: translate(LocalizationKeys.email)!,
              value: stringMask(widget.profileInfo.email),
              onActionClicked: () {
                showEditBottomSheet(_buildEditEmailWidget(),
                    translate(LocalizationKeys.changeEmail)!);
              }),
          _buildDivider(),
          _buildPersonalInfoSection(
              title: translate(LocalizationKeys.phoneNumber)!,
              value: stringMask(widget.profileInfo.mobile),
              onActionClicked: () {
                showEditBottomSheet(_buildEditPhoneNumberWidget(),
                    translate(LocalizationKeys.changePhoneNumber)!);
              }),*/
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    return Center(
      child: GestureDetector(
        onTap: _pickAttachment,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(75),
                  ),
                  child: _profileImage == null
                      ? Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: AppCachedNetworkImage(
                              imageUrl: widget.profileInfo.profileImageUrl,
                              width: 150,
                              height: 150,
                              boxFit: BoxFit.cover,
                              placeholder: Container(
                                width: 150,
                                height: 150,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(AppAssetPaths
                                            .profileDefaultAvatar))),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(_profileImage!))),
                        )),
              Center(
                child: Container(
                  width: 130.w,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssetPaths.cameraIcon,
                        color: AppColors.colorPrimary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        translate(LocalizationKeys.changePhoto)!,
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w500,
                          color: AppColors.colorPrimary,
                        ),
                      )
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

  Widget _buildPersonalInfoSection(
      {required String title,
      required String value,
      String? actionTitle,
      required Function() onActionClicked}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: themeData.textTheme.labelMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.editTitle,
                )),
            GestureDetector(
              onTap: onActionClicked,
              child: Text(
                actionTitle ?? translate(LocalizationKeys.edit)!,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.transparent,
                    shadows: [
                      Shadow(offset: Offset(0, -2), color: Colors.black)
                    ],
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                    decorationThickness: 2),
              ),
            )
          ],
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
            value,
            style: themeData.textTheme.labelMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.infoText,
                height: 1.5),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _buildAboutInfoSection(String about) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(translate(LocalizationKeys.about)!,
                style: themeData.textTheme.labelMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.editTitle,
                )),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          about,
          style: themeData.textTheme.labelMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.infoText,
              height: 1.5),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const Divider(thickness: 1, color: AppColors.dividerBackground));
  }

  Widget _buildEditNameAboutWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 24.0.h),
      child: Column(
        children: [
          AppTextFormField(
            title: translate(LocalizationKeys.fullName)!,
            requiredTitle: false,
            controller: nameController,
            hintText: translate(LocalizationKeys.enterYourName),
            onSaved: _fullNameSaved,
            onChanged: _fullNameSaved,
            textInputAction: TextInputAction.next,
            validator: textValidator,
            autofillHints: const [AutofillHints.name],
          ),
          SizedBox(height: 24.h),
          AppTextFormField(
            title: translate(LocalizationKeys.about)!,
            requiredTitle: false,
            initialValue: _about,
            hintText: translate(LocalizationKeys.tellUsWhoYouAre),
            onSaved: _aboutSaved,
            onChanged: _aboutSaved,
            textInputAction: TextInputAction.done,
            validator: textValidator,
            maxLines: 5,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: AppColors.appCancelButtonBackground,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: AppTextButton(
                    onPressed: () => {dismissBottomSheet.call()},
                    child: Text(
                      translate(LocalizationKeys.cancel)!,
                      style: themeData.textTheme.labelMedium?.copyWith(
                          color: AppColors.appCancelButton,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: AppTextButton(
                    onPressed: () =>
                        {dismissBottomSheet.call(), updateBasicData()},
                    child: Text(
                      translate(LocalizationKeys.save)!,
                      style: themeData.textTheme.labelMedium?.copyWith(
                          color: AppColors.appSecondButton,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEditEmailWidget(String email) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0.h),
      child: Form(
        key: editFormKey,
        autovalidateMode: autoValidateMode,
        child: AutofillGroup(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              AppTextFormField(
                title: translate(LocalizationKeys.currentEmail)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterCurrentEmail),
                onSaved: _currentEmailSaved,
                onChanged: _currentEmailSaved,
                textInputAction: TextInputAction.next,
                validator: emailValidator,
                textInputType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              SizedBox(height: 24.h),
              AppTextFormField(
                title: translate(LocalizationKeys.newEmail)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterNewEmail),
                onSaved: _newEmailSaved,
                onChanged: _newEmailSaved,
                textInputAction: TextInputAction.next,
                validator: emailValidator,
                textInputType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              SizedBox(height: 24.h),
              AppTextFormField(
                title: translate(LocalizationKeys.password)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterPassword),
                onSaved: _passwordSaved,
                onChanged: _passwordSaved,
                obscure: true,
                showObscure: true,
                textInputAction: TextInputAction.done,
                validator: textValidator,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.appCancelButtonBackground,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: AppTextButton(
                        onPressed: () => {dismissBottomSheet.call()},
                        child: Text(
                          translate(LocalizationKeys.cancel)!,
                          style: themeData.textTheme.labelMedium?.copyWith(
                              color: AppColors.appCancelButton,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: AppTextButton(
                        onPressed: () =>
                            {isToUpdateEmail = true, _validateFormInputs()},
                        child: Text(
                          translate(LocalizationKeys.next)!,
                          style: themeData.textTheme.labelMedium?.copyWith(
                              color: AppColors.appSecondButton,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditPhoneNumberWidget(String phone) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0.h),
      child: Form(
        key: editFormKey,
        autovalidateMode: autoValidateMode,
        child: AutofillGroup(
          child: ListView(
            shrinkWrap: true,
            children: [
              PhoneNumberFormFiledWidget(
                title: translate(LocalizationKeys.currentPhoneNumber)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterCurrentPhoneNumber),
                onSaved: _currentPhoneNumberSaved,
                onChanged: _currentPhoneNumberSaved,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 24.h),
              PhoneNumberFormFiledWidget(
                title: translate(LocalizationKeys.newPhoneNumber)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterNewPhoneNumber),
                onSaved: _newPhoneNumberSaved,
                onChanged: _newPhoneNumberSaved,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 24.h),
              AppTextFormField(
                title: translate(LocalizationKeys.password)!,
                requiredTitle: false,
                hintText: translate(LocalizationKeys.enterPassword),
                onSaved: _passwordSaved,
                onChanged: _passwordSaved,
                textInputAction: TextInputAction.done,
                validator: textValidator,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.appCancelButtonBackground,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: AppTextButton(
                        onPressed: () => {dismissBottomSheet.call()},
                        child: Text(
                          translate(LocalizationKeys.cancel)!,
                          style: themeData.textTheme.labelMedium?.copyWith(
                              color: AppColors.appCancelButton,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: AppTextButton(
                        onPressed: () =>
                            {isToUpdateEmail = false, _validateFormInputs()},
                        child: Text(
                          translate(LocalizationKeys.next)!,
                          style: themeData.textTheme.labelMedium?.copyWith(
                              color: AppColors.appSecondButton,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditSuccessfullyWidget(String description) {
    return Wrap(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 21, right: 19, bottom: 41),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate(LocalizationKeys.done)!,
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 24.spMin,
                          color: AppColors.lisTileTitle,
                        )),
                    SizedBox(height: 16.h),
                    SvgPicture.asset(AppAssetPaths.successIcon),
                    SizedBox(height: 16.h),
                    Text(description,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.editTitle,
                            fontSize: 16.spMin,
                            fontWeight: FontWeight.w500,
                            height: 2)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 19.0.h),
                child: SizedBox(
                  width: double.infinity,
                  child: AppElevatedButton.withTitle(
                    padding:
                        REdgeInsets.symmetric(vertical: 17, horizontal: 29),
                    onPressed: goBackClicked,
                    title: translate(LocalizationKeys.goBack)!,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  EditProfileBloc get currentBloc => BlocProvider.of<EditProfileBloc>(context);

  void updateBasicData() {
    currentBloc.add(UpdateBasicDataEvent(_fullName, _about));
  }

  void getUpdatedLocalData() async {
    currentBloc.add(GetUpdatedLocalDataEvent());
  }

  void updateProfileImage(String imagePath) async {
    currentBloc.add(UpdateProfileImageEvent(imagePath));
  }

  void _validateFormInputs() {
    currentBloc.add(ValidateFormEvent(editFormKey));
  }

  void updateEmail() {
    currentBloc
        .add(UpdateEmailEvent(_currentEmail, _password ?? "", _newEmail ?? ""));
  }

  void updatePhoneNumber() {
    currentBloc.add(UpdatePhoneNumberEvent(
        _currentPhoneNumber, _password ?? "", _newPhoneNumber ?? ""));
  }

  void showEditBottomSheet(Widget widget, String title) {
    AppBottomSheet.openAppBottomSheet(
        context: context, child: widget, title: title);
  }

  void dismissBottomSheet() {
    Navigator.pop(context);
  }

  void _openOtpScreen() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return OtpScreenWrapper(
            uuid: widget.profileInfo.userId,
            otpStateListener: (verifiedState) {
              dismissBottomSheet();
              getUpdatedLocalData();
              if (isToUpdateEmail) {
                showSuccessDialog(translate(
                    LocalizationKeys.yourEmailHasBeenChangedSuccessfully)!);
              } else {
                showSuccessDialog(translate(LocalizationKeys
                    .yourPhoneNumberHasBeenChangedSuccessfully)!);
              }
            },
          );
        });
  }

  void showSuccessDialog(String description) {
    showAppDialog(
      context: context,
      dialogWidget: _buildEditSuccessfullyWidget(description),
      shouldPop: true,
    );
  }

  void goBackClicked() {
    dismissBottomSheet();
    getUpdatedLocalData();
  }

  void _fullNameSaved(String? value) {
    _fullName = value!;
  }

  void _aboutSaved(String? value) {
    _about = value!;
  }

  void _currentEmailSaved(String? value) {
    _currentEmail = value!;
  }

  void _currentPhoneNumberSaved(PhoneNumber? value) {
    _currentPhoneNumber = value!.international.substring(1);
  }

  void _newPhoneNumberSaved(PhoneNumber? value) {
    _newPhoneNumber = value!.international.substring(1);
  }

  void _newEmailSaved(String? value) {
    _newEmail = value!;
  }

  void _passwordSaved(String? value) {
    _password = value!;
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
        updateProfileImage(pickedImage.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
        updateProfileImage(pickedImage.path);
      });
    }
  }

  Future<void> _pickAttachment() async {
    AppBottomSheet.openBaseBottomSheet(
        context: context,
        child: PickerOptionWidget(
          cameraClickedCallBack: _pickImageFromCamera,
          galleryClickedCallBack: _pickImageFromGallery,
        ));
  }

  String stringMask(String inputString) {
    if (inputString.length < 8) {
      return inputString;
    }
    String firstPart = inputString.substring(0, 4);
    String asterisks = '*' * 4;
    String lastPart = inputString.substring(8);

    String result = '$firstPart$asterisks$lastPart';

    return result;
  }
}

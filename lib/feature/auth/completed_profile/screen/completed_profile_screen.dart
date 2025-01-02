import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/feature/auth/_base/base_auth_screen.dart';
import 'package:vivas/feature/auth/completed_profile/bloc/completed_profile_bloc.dart';
import 'package:vivas/feature/auth/completed_profile/bloc/completed_profile_repository.dart';
import 'package:vivas/feature/auth/completed_profile/model/gender_ui_model.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/auth/otp/screen/otp_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/terms_text_widget/terms_text_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/country_picker_form_field_widget.dart';
import 'package:vivas/feature/widgets/text_field/custom_drop_down_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/phone_number_form_filed_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/welcome_screen.dart';

import '../../../../apis/managers/profile_api_manger.dart';
import '../../../../apis/models/auth/login/login_successful_response.dart';
import '../../../../apis/models/profile/profile_info_api_model.dart';

class CompletedProfileScreen extends StatelessWidget {
  CompletedProfileScreen({Key? key, this.uuid = "", this.fromSocial = false})
      : super(key: key);
  static const routeName = '/completed-profile-screen';
  final String uuid;
  final bool fromSocial;

  static Future<void> open(BuildContext context, String uuid,
      {bool fromSocial = false, replacement = false}) async {
    if(replacement){
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CompletedProfileScreen(
                uuid: uuid,
                fromSocial: fromSocial,
              )));
    }else{
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CompletedProfileScreen(
                uuid: uuid,
                fromSocial: fromSocial,
              )));
    }

  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompletedProfileBloc>(
      create: (context) => CompletedProfileBloc(CompletedProfileRepository(
        authApiManager: AuthApiManager(dioApiManager, context),
        profileApiManger: ProfileApiManger(dioApiManager, context),
        preferencesManager: GetIt.I<PreferencesManager>(),
      )),
      child: CompletedProfileScreenWithBloc(uuid, fromSocial),
    );
  }
}

class CompletedProfileScreenWithBloc extends BaseAuthScreen {
  final String uuid;
  final bool fromSocial;

  const CompletedProfileScreenWithBloc(this.uuid, this.fromSocial, {super.key});

  @override
  BaseAuthState<CompletedProfileScreenWithBloc> baseScreenCreateState() {
    return _CompletedProfileScreenWithBloc();
  }
}

class _CompletedProfileScreenWithBloc
    extends BaseAuthState<CompletedProfileScreenWithBloc> with AuthValidate {
  String? _email;
  String? _mobileNumber;
  late String _gender;
  late String _nationality;
  late String _birthday;

  GlobalKey<FormState> completedProfileFormKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _dobController = TextEditingController();
  bool openOtp = false;

  @override
  Widget bodyWidget(BuildContext context) {
    return BlocConsumer<CompletedProfileBloc, CompletedProfileState>(
      listener: (ctx, state) async {
        if (state is CompletedProfileLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is CompletedProfileErrorState) {
          showFeedbackMessage(state.isLocalizationKey
              ? translate(state.errorMassage)!
              : state.errorMassage);
        } else if (state is FormNotValidatedState) {
          autovalidateMode = AutovalidateMode.always;
        } else if (state is FormValidatedState) {
          _completedProfileInfoApiEvent();
        } else if (state is CompletedProfileInfoSuccessfullyState) {
          _saveTokenDataEvent(state.loginSuccessfulResponse);
          // if (widget.useMobile) {
          //   _openOtpScreen();
          // } else {
          //   _openLoginScreen();
          // }
        } else if (state is SaveTokenDataSuccessfullyState) {
          _getUserInfoApiEvent();
        } else if (state is ProfileInfoLoadedState) {
          _saveUserInfoEvent(state.profileInfoApiModel);
          if (state.profileInfoApiModel.phoneVerified) {
            openOtp = true;
          }
        } else if (state is SaveProfileInfoSuccessfullyState) {
          _setAsLoggedUserEvent();
        } else if (state is OpenHomeScreenState) {
          if (openOtp) {
            _openWelcomeAuthScreen();
          } else {
            _openOtpScreen();
          }
        }
      },
      builder: (ctx, state) {
        return buildCompletedProfileWidget();
      },
    );
  }

  void _getUserInfoApiEvent() {
    currentBloc.add(GetUserInfoApiEvent());
  }

  void _saveTokenDataEvent(LoginSuccessfulResponse loginSuccessfulResponse) {
    currentBloc.add(SaveTokenDataEvent(loginSuccessfulResponse));
  }

  void _setAsLoggedUserEvent() {
    currentBloc.add(SetAsLoggedUserEvent());
  }

  void _saveUserInfoEvent(ProfileInfoApiModel profileInfoApiModel) {
    currentBloc.add(SaveUserInfoEvent(profileInfoApiModel));
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget buildCompletedProfileWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 10.h),
            _labelsWidgets(),
            SizedBox(height: 20.h),
            _loginFormWidget(),
            SizedBox(height: 20.h),
            TermsTextWidget(),
            SizedBox(height: 20.h),
            _completedProfileButtonsWidgets(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _labelsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translate(LocalizationKeys.signUp)!,
            style: textTheme.labelLarge?.copyWith(
              fontSize: 24.spMin,
              color: AppColors.loginTitleText,
            )),
      ],
    );
  }

  Widget _loginFormWidget() {
    return Form(
      key: completedProfileFormKey,
      autovalidateMode: autovalidateMode,
      child: AutofillGroup(
        child: Column(
          children: [
            widget.fromSocial
                ? PhoneNumberFormFiledWidget(
                    title: translate(LocalizationKeys.whatsAppNumber)!,
                    hintText: translate(LocalizationKeys.enterYourWhatsApp),
                    autovalidateMode: autovalidateMode,
                    onSaved: _phoneNumberSaved,
                    textInputAction: TextInputAction.next,
                  )
                : AppTextFormField(
                    title: translate(LocalizationKeys.email)!,
                    hintText: translate(LocalizationKeys.enterYourEmail),
                    onSaved: _emailSaved,
                    textInputAction: TextInputAction.next,
                    validator: emailValidator,
                    textInputType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                  ),
            SizedBox(height: 10.h),
            CustomDropDownFormFiledWidget(
              title: translate(LocalizationKeys.gender)!,
              hintText: translate(LocalizationKeys.selectYourGender)!,
              items: GenderUiModel.genders.map((maritalStatus) {
                return CustomDropDownItem(
                    key: maritalStatus.key,
                    value: translate(maritalStatus.value)!);
              }).toList(),
              validator: customDropDownItemValidator,
              onSaved: _genderSaved,
            ),
            SizedBox(height: 10.h),
            DatePickerFormFiledWidget(
              controller: _dobController,
              title: translate(LocalizationKeys.birthday)!,
              hintText: translate(LocalizationKeys.enterYourBirthday),
              onSaved: _birthdaySaved,
              validator: dateTimeValidator,
              initialValue: DateTime((DateTime.now().year - 17)),
              maximumDate: DateTime((DateTime.now().year - 17)),
              minimumDate: DateTime((DateTime.now().year - 100)),
            ),
            SizedBox(height: 10.h),
            CountryPickerFormFieldWidget(
              title: translate(LocalizationKeys.nationality)!,
              hintText: translate(LocalizationKeys.selectYourNationality)!,
              validator: countryPickerValidator,
              onSaved: _nationalityPickerSaved,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _completedProfileButtonsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppElevatedButton.withTitle(
          onPressed: _continueClicked,
          title: translate(LocalizationKeys.continuee)!,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  void _genderSaved(CustomDropDownItem? value) {
    _gender = value!.key;
  }

  void _nationalityPickerSaved(CountryPickerWidgetItem? value) {
    _nationality = value!.key;
  }

  void _emailSaved(String? value) {
    _email = value!;
  }

  void _phoneNumberSaved(PhoneNumber? value) {
    _mobileNumber = value!.international.substring(1);
  }

  void _birthdaySaved(DateTime? value) {
    _birthday = AppDateFormat.formattingApiDate(value!, "en");
  }

  CompletedProfileBloc get currentBloc =>
      BlocProvider.of<CompletedProfileBloc>(context);

  void _continueClicked() {
    currentBloc.add(ValidateFormEvent(completedProfileFormKey));
  }

  void _completedProfileInfoApiEvent() {
    currentBloc.add(CompletedProfileInfoApiEvent(
      birthday: _birthday,
      email: _email,
      genderKey: _gender,
      nationality: _nationality,
      mobileNumber: _mobileNumber,
      uuid: widget.uuid,
      fromSocial: widget.fromSocial,
    ));
  }

  Future<void> _openWelcomeAuthScreen() async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
        WelcomeAuthScreen.routeName, ((route) => false));
  }

  Future<void> _openOtpScreen() async {
    OtpScreen.open(context, widget.uuid,
        openAfterCheckOtp: OpenAfterCheckOtp.welcomeAuthScreen,
        sendOtpWhenOpen: true,replacement: true);
  }
}

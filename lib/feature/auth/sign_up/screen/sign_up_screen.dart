import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/apis/managers/profile_api_manger.dart';
import 'package:vivas/apis/models/auth/login/login_successful_response.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/auth/_base/base_auth_screen.dart';
import 'package:vivas/feature/auth/completed_profile/screen/completed_profile_screen.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/auth/helper/social_auth.dart';
import 'package:vivas/feature/auth/login/screen/login_screen.dart';
import 'package:vivas/feature/auth/otp/screen/otp_screen.dart';
import 'package:vivas/feature/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:vivas/feature/auth/sign_up/bloc/sign_up_repository.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';

import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/phone_number_form_filed_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  static const routeName = '/sign-up-screen';

  static Future<void> open(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(SignUpRepository(
        authApiManager: AuthApiManager(dioApiManager, context),
        preferencesManager: GetIt.I<PreferencesManager>(),
        profileApiManger: ProfileApiManger(dioApiManager, context),
      )),
      child: const SignUpScreenWithBloc(),
    );
  }
}

class SignUpScreenWithBloc extends BaseAuthScreen {
  const SignUpScreenWithBloc({super.key});

  @override
  BaseAuthState<SignUpScreenWithBloc> baseScreenCreateState() {
    return _SignUpScreenWithBloc();
  }
}

class _SignUpScreenWithBloc extends BaseAuthState<SignUpScreenWithBloc>
    with AuthValidate, SocialAuth {
  late PhoneNumber _phoneNumber;
  late String _fullName;
  late String _password;
  String _uuid = "";
  final bool _completedProfile = true;
  bool useSocial = false;

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    iniSocialAuth();
    super.initState();
  }

  @override
  Widget bodyWidget(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (ctx, state) async {
        if (state is SignUpLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is SignUpErrorState) {
          showFeedbackMessage(state.isLocalizationKey
              ? translate(state.errorMassage)!
              : state.errorMassage);
        } else if (state is FormNotValidatedState) {
          autovalidateMode = AutovalidateMode.always;
        } else if (state is FormValidatedState) {
          _signUpEventApi();
        } else if (state is SignUpSuccessfullyState) {
          _uuid = state.authSuccessfulResponse.uuid;
          _openOtpScreen(state.authSuccessfulResponse.uuid);
        } else if (state is SignUpSocialSuccessfullyState) {
          useSocial = true;
          _saveTokenDataEvent(state.loginSuccessfulResponse);
        } else if (state is SaveTokenDataSuccessfullyState) {
          _getUserInfoApiEvent();
        } else if (state is ProfileInfoLoadedState) {
          _saveUserInfoEvent(state.profileInfoApiModel);
        } else if (state is SaveProfileInfoSuccessfullyState) {
          if (_completedProfile) {
            _completedProfileScreen(_uuid, useSocial);
          } else {
            _setAsLoggedUserEvent();
          }
        } else if (state is OpenHomeScreenState) {
          _openHomeScreen();
        } else if (state is OpenSignInScreenState) {
          _openLoginScreen();
        } else if (state is SocialLoginFailState) {
          if (!state.loginFailResponse.profileCompleted) {
            showFeedbackMessage("you need to complete your profile first");
            _completedProfileScreen(state.loginFailResponse.uuid, true);
          } else if (!state.loginFailResponse.accountConfirmed) {
            showFeedbackMessage("please confirm Your phoneNumber first");
            _openOtpScreenToWelcome(state.loginFailResponse.uuid);
          } else {
            showFeedbackMessage(state.loginFailResponse.message);
          }
        }
      },
      builder: (ctx, state) {
        return buildSignUpWidget();
      },
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget buildSignUpWidget() {
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
            _loginButtonsWidgets(),
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
      key: signUpFormKey,
      autovalidateMode: autovalidateMode,
      child: AutofillGroup(
        child: Column(
          children: [
            AppTextFormField(
              title: translate(LocalizationKeys.fullName)!,
              hintText: translate(LocalizationKeys.enterYourName),
              onSaved: _fullNameSaved,
              textInputAction: TextInputAction.next,
              validator: textValidator,
              autofillHints: const [AutofillHints.name],
            ),
            const SizedBox(height: 20),
            PhoneNumberFormFiledWidget(
              title: translate(LocalizationKeys.whatsAppNumber)!,
              hintText: translate(LocalizationKeys.enterYourWhatsApp),
              autovalidateMode: autovalidateMode,
              onSaved: _phoneNumberSaved,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            AppTextFormField(
              helperText: translate(LocalizationKeys.mustBeAtLeast8Characters),
              title: translate(LocalizationKeys.password)!,
              hintText: translate(LocalizationKeys.createPassword),
              controller: _passwordController,
              onSaved: _passwordSaved,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              validator: passwordValidator,
              obscure: true,
              autofillHints: const [
                AutofillHints.newPassword,
              ],
            ),
            SizedBox(height: 10.h),
            AppTextFormField(
              helperText: translate(LocalizationKeys.mustBeAtLeast8Characters),
              title: translate(LocalizationKeys.confirmPassword)!,
              hintText: translate(LocalizationKeys.confirmPassword),
              onSaved: _passwordSaved,
              obscure: true,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  confirmPasswordValidator(v, _passwordController.text),
              onFieldSubmitted: (_) => _continueClicked(),
              autofillHints: const [
                AutofillHints.newPassword,
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _loginButtonsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppElevatedButton.withTitle(
          onPressed: _continueClicked,
          title: translate(LocalizationKeys.continuee)!,
        ),
        const SizedBox(height: 10),
        AppElevatedButton(
          onPressed: _getGoogleUserCredential,
          color: AppColors.loginWithGoogleButtonBackground,
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssetPaths.googleLogo),
              const SizedBox(width: 15),
              FittedBox(
                child: Text(translate(LocalizationKeys.signUpWithGoogle)!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.loginWithGoogleButtonText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (isOnIOS()) ...[
          AppElevatedButton(
            onPressed: _getAppleUserCredential,
            color: AppColors.loginWithAppleButtonBackground,
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssetPaths.appleLogo),
                const SizedBox(width: 15),
                Text(translate(LocalizationKeys.signUpWithApple)!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.loginWithAppleButtonText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ))
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translate(LocalizationKeys.alreadyHaveAnAccount)!,
                style: textTheme.labelLarge),
            const SizedBox(width: 5),
            AppTextButton.withTitle(
                onPressed: _loginClicked,
                padding: EdgeInsets.zero,
                title: translate(LocalizationKeys.logIn)!),
          ],
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  Future<void> _getGoogleUserCredential() async {
    GoogleSignInAccount? googleSignInAccount = await loginWithGoogle();
    if (googleSignInAccount != null) {
      _signInWithGoogleClicked(googleSignInAccount);
    }
  }

  Future<void> _getAppleUserCredential() async {
    AuthorizationCredentialAppleID? appleSignInAccount = await loginWithApple();
    if (appleSignInAccount != null) {
      _signInWithAppleClicked(appleSignInAccount);
    }
  }

  void _phoneNumberSaved(PhoneNumber? value) {
    _phoneNumber = value!;
  }

  void _passwordSaved(String? value) {
    _password = value!;
  }

  void _fullNameSaved(String? value) {
    _fullName = value!;
  }

  SignUpBloc get currentBloc => BlocProvider.of<SignUpBloc>(context);

  void _continueClicked() {
    currentBloc.add(ValidateFormEvent(signUpFormKey));
  }

  void _signUpEventApi() {
    currentBloc.add(SignUpApiEvent(
        _phoneNumber.international.substring(1), _password, _fullName));
  }

  Future<void> _signInWithGoogleClicked(
      GoogleSignInAccount googleSignInAccount) async {
    currentBloc.add(SignUpWithGoogleApiEvent(googleSignInAccount));
  }

  void _signInWithAppleClicked(AuthorizationCredentialAppleID appleID) {
    currentBloc.add(SignUpWithAppleEvent(appleID));
  }

  void _loginClicked() {
    currentBloc.add(LoginClickedEventEvent());
  }

  void _saveTokenDataEvent(LoginSuccessfulResponse loginSuccessfulResponse) {
    currentBloc.add(SaveTokenDataEvent(loginSuccessfulResponse));
  }

  void _setAsLoggedUserEvent() {
    currentBloc.add(SetAsLoggedUserEvent());
  }

  void _getUserInfoApiEvent() {
    currentBloc.add(const GetUserInfoApiEvent());
  }

  void _saveUserInfoEvent(ProfileInfoApiModel profileInfoApiModel) {
    currentBloc.add(SaveUserInfoEvent(profileInfoApiModel));
  }

  Future<void> _openHomeScreen() async {
    BottomNavigationScreen.open(context, 0);
  }

  Future<void> _completedProfileScreen(String uuid, bool fromSocial) async {
    CompletedProfileScreen.open(context, uuid,
        fromSocial: fromSocial, replacement: true);
  }

  Future<void> _openLoginScreen() async {
    LoginScreen.open(context);
  }

  Future<void> _openOtpScreen(String uuid) async {
    OtpScreen.open(context, uuid,
        openAfterCheckOtp: OpenAfterCheckOtp.completeInfoScreen,
        replacement: true);
  }

  Future<void> _openOtpScreenToWelcome(String uuid) async {
    OtpScreen.open(context, uuid,
        openAfterCheckOtp: OpenAfterCheckOtp.welcomeAuthScreen,
        replacement: true);
  }
}

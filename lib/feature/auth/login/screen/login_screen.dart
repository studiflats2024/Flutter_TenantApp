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
import 'package:vivas/app_linking.dart';
import 'package:vivas/feature/auth/_base/base_auth_screen.dart';
import 'package:vivas/feature/auth/completed_profile/screen/completed_profile_screen.dart';
import 'package:vivas/feature/auth/forget_password/screen/forget_password_screen.dart';
import 'package:vivas/feature/auth/forget_password/screen/rest_password_screen_v2.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/auth/helper/social_auth.dart';
import 'package:vivas/feature/auth/login/bloc/login_bloc.dart';
import 'package:vivas/feature/auth/login/bloc/login_repository.dart';
import 'package:vivas/feature/auth/login/screen/Component/email_form_login.dart';
import 'package:vivas/feature/auth/login/screen/Component/phone_form_login.dart';
import 'package:vivas/feature/auth/otp/screen/otp_screen.dart';
import 'package:vivas/feature/auth/sign_up/screen/sign_up_screen.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/logo/app_logo_title_widget.dart';
import 'package:vivas/only_debug/user_debug_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/DeepLink/deep_link_bloc.dart';
import 'package:vivas/utils/build_type/build_type.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key, this.appLinksDeepLink}) : super(key: key);
  static const routeName = '/login-screen';
  static const argumentsIsRoute = 'is_route';
  static const argumentsDeepAppLink = 'deep_link';
  final AppLinksDeepLink? appLinksDeepLink;

  static Future<void> open(BuildContext context,
      {AppLinksDeepLink? appLinksDeepLink, bool isRoute = true}) async {
    if (isRoute) {
      await Navigator.pushNamedAndRemoveUntil(
          context, routeName, (route) => false,
          arguments: {
            argumentsDeepAppLink: appLinksDeepLink,
            argumentsIsRoute: isRoute,
          });
    } else {
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen(
                    appLinksDeepLink: appLinksDeepLink,
                  )),
          (_) => false);
    }
  }

  AppLinksDeepLink? deepLink(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      return (arguments as Map)[argumentsDeepAppLink];
    } else {
      return null;
    }
  }





  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(LoginRepository(
        authApiManager: AuthApiManager(dioApiManager, context),
        profileApiManger: ProfileApiManger(dioApiManager, context),
        preferencesManager: GetIt.I<PreferencesManager>(),
      )),
      child: LoginScreenWithBloc(
        appLinksDeepLink: deepLink(context),
      ),
    );
  }
}

class LoginScreenWithBloc extends BaseAuthScreen {
  final AppLinksDeepLink? appLinksDeepLink;

  const LoginScreenWithBloc({super.key, this.appLinksDeepLink});

  @override
  BaseAuthState<LoginScreenWithBloc> baseScreenCreateState() {
    return _LoginScreenWithBloc();
  }
}

class _LoginScreenWithBloc extends BaseAuthState<LoginScreenWithBloc>
    with AuthValidate, SocialAuth {
  late PhoneNumber _phoneNumber;
  late String _password, _email;
  PhoneNumber? _initialPhoneNumber;
  String? _initialPassword, _initialEmail;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  int loginOption = 0;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    iniSocialAuth();
    initSsoLogin();

    _startWhatsAppSessionEvent();
    super.initState();
    if (isDebugMode()) _setDebugEmailPasswordAutomatic();
    Future.delayed(const Duration(milliseconds: 1500) , (){
      if (widget.appLinksDeepLink != null &&
          widget.appLinksDeepLink?.status == AppLinkStatus.apartment) {
        UnitDetailsScreen.open(context, widget.appLinksDeepLink?.id ?? "");
      }
    });
  }



  initSsoLogin() {
    var deepLink = context.read<DeepLinkBloc>();
    if (deepLink.loginSuccessfulResponse != null) {
      _saveTokenDataEvent(deepLink.loginSuccessfulResponse!);
    }
  }

  @override
  Widget bodyWidget(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (ctx, state) => listener(ctx, state),
      builder: (ctx, state) => buildLoginWidget(ctx, state),
    );
  }

  listener(BuildContext ctx, LoginState state) async {
    if (state is LoginLoadingState) {
      showLoading();
    } else {
      hideLoading();
    }
    if (state is LoginErrorState) {
      showFeedbackMessage(state.isLocalizationKey
          ? translate(state.errorMassage)!
          : state.errorMassage);
    } else if (state is PhoneAndPasswordNotValidatedState) {
      autovalidateMode = AutovalidateMode.always;
    } else if (state is PhoneAndPasswordValidatedState) {
      _loginEventApi();
    } else if (state is LoginSuccessfullyState) {
      _saveTokenDataEvent(state.loginSuccessfulResponse);
    } else if (state is LoginFailState) {
      if (state.fromSocial) {
        if (!state.loginFailResponse.profileCompleted) {
          showFeedbackMessage("you need to complete your profile first");
          _completedProfileScreen(state.loginFailResponse.uuid, true);
        } else if (!state.loginFailResponse.accountConfirmed) {
          showFeedbackMessage("please confirm Your phoneNumber first");
          _openOtpScreen(state.loginFailResponse.uuid, true);
        } else {
          showFeedbackMessage(state.loginFailResponse.message);
        }
      } else {
        if (!state.loginFailResponse.accountConfirmed) {
          showFeedbackMessage("please confirm Your phoneNumber first");
          _openOtpScreen(state.loginFailResponse.uuid, state.fromSocial);
        } else if (!state.loginFailResponse.profileCompleted) {
          showFeedbackMessage("you need to complete your profile first");
          _completedProfileScreen(
              state.loginFailResponse.uuid, state.fromSocial);
        } else {
          showFeedbackMessage(state.loginFailResponse.message);
        }
      }
    } else if (state is SaveTokenDataSuccessfullyState) {
      (state.loginSuccessfulResponse.mustChangePassword ?? false)
          ? ResetPasswordScreenV2.open(
              context,
              state.loginSuccessfulResponse.uuid,
              state.loginSuccessfulResponse.accessToken)
          : _getUserInfoApiEvent();
    } else if (state is ProfileInfoLoadedState) {
      _saveUserInfoEvent(state.profileInfoApiModel);
    } else if (state is SaveProfileInfoSuccessfullyState) {
      _setAsLoggedUserEvent();
    } else if (state is OpenHomeScreenState) {
      _openHomeScreen();
    } else if (state is OpenForgetPasswordScreenState) {
      _openRecoveryPasswordScreen();
    } else if (state is OpenSignUpScreenState) {
      _openRegisterScreen();
    }
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget buildLoginWidget(BuildContext ctx, LoginState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 20.h),
            const Center(child: AppLogoTitleWidget()),
            SizedBox(height: 25.h),
            _labelsWidgets(),
            SizedBox(height: 30.h),
            Text(
              "Login Options  :",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio(
                        value: 0,
                        groupValue: loginOption,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              loginOption = value;
                            });
                          }
                        }),
                    Text(
                      translate(LocalizationKeys.whatsAppNumber)!,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20.w,
                ),
                Row(
                  children: [
                    Radio(
                        value: 1,
                        groupValue: loginOption,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              loginOption = value;
                            });
                          }
                        }),
                    Text(
                      translate(LocalizationKeys.email)!,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            loginOption == 0
                ? LoginPhoneForm(
                    loginFormKey: loginFormKey,
                    initialPassword: _initialPassword,
                    initialPhoneNumber: _initialPhoneNumber,
                    phoneNumberSaved: _phoneNumberSaved,
                    passwordSaved: _passwordSaved,
                    passwordValidator: passwordValidator,
                    forgotPasswordClicked: _forgotPasswordClicked,
                    loginClicked: _loginClicked)
                : LoginEmailForm(
                    loginFormKey: loginFormKey,
                    initialEmail: _initialEmail,
                    initialPassword: _initialPassword,
                    emailSaved: _emailSaved,
                    passwordSaved: _passwordSaved,
                    emailValidator: emailValidator,
                    passwordValidator: passwordValidator,
                    forgotPasswordClicked: _forgotPasswordClicked,
                    loginClicked: _loginClicked),
            _loginButtonsWidgets(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _labelsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(translate(LocalizationKeys.logInToYourAccount)!,
            style: textTheme.labelLarge?.copyWith(
              fontSize: 24.spMin,
              color: AppColors.loginTitleText,
            )),
        SizedBox(height: 10.h),
        Text(translate(LocalizationKeys.welcomeBackPleaseEnterYourDetails)!,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.loginSubTitleText,
              fontSize: 16.spMin,
            )),
      ],
    );
  }

  Widget _loginButtonsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppElevatedButton.withTitle(
          onPressed: _loginClicked,
          title: translate(LocalizationKeys.signIn)!,
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
                child: Text(translate(LocalizationKeys.signInWithGoogle)!,
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
                Text(translate(LocalizationKeys.signInWithApple)!,
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
            Text(translate(LocalizationKeys.dontHaveAnAccount)!,
                style: textTheme.labelLarge),
            const SizedBox(width: 5),
            AppTextButton.withTitle(
                onPressed: _createNewAccountClicked,
                padding: EdgeInsets.zero,
                title: translate(LocalizationKeys.signUp)!),
          ],
        ),
        _continueAsGuestButton(),
      ],
    );
  }

  Widget _continueAsGuestButton() {
    return AppTextButton.withTitle(
        onPressed: _continueAsGuestClicked,
        padding: EdgeInsets.zero,
        title: translate(LocalizationKeys.continueAsGuest)!);
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

  void _setDebugEmailPasswordAutomatic() {
    _initialEmail = UserDebugModel.email;
    _initialPhoneNumber = UserDebugModel.phoneNumber;
    _initialPassword = UserDebugModel.usersPassword;
  }

  void _phoneNumberSaved(PhoneNumber? value) {
    _phoneNumber = value!;
  }

  void _passwordSaved(String? value) {
    _password = value!;
  }

  void _emailSaved(String? value) {
    _email = value!;
  }

  LoginBloc get currentBloc => BlocProvider.of<LoginBloc>(context);

  void _loginClicked() {
    currentBloc.add(ValidatePhonePasswordEvent(loginFormKey));
  }

  void _loginEventApi() {
    currentBloc.add(LoginWithPhonePasswordEvent(
        loginOption == 0 ? _phoneNumber.international.substring(1) : _email,
        _password));
  }

  Future<void> _signInWithGoogleClicked(
      GoogleSignInAccount googleSignInAccount) async {
    currentBloc.add(LoginWithGoogleApiEvent(googleSignInAccount));
  }

  void _startWhatsAppSessionEvent() {
    currentBloc.add(StartWhatsAppSessionEvent());
  }

  void _signInWithAppleClicked(AuthorizationCredentialAppleID appleID) {
    currentBloc.add(LoginWithAppleEvent(appleID));
  }

  void _createNewAccountClicked() {
    currentBloc.add(SignUpClickedEventEvent());
  }

  void _forgotPasswordClicked() {
    currentBloc.add(ForgotPasswordClickedEvent());
  }

  void _saveTokenDataEvent(LoginSuccessfulResponse loginSuccessfulResponse) {
    currentBloc.add(SaveTokenDataEvent(loginSuccessfulResponse));
  }

  void _setAsLoggedUserEvent() {
    currentBloc.add(SetAsLoggedUserEvent());
  }

  void _getUserInfoApiEvent() {
    currentBloc.add(GetUserInfoApiEvent());
  }

  void _saveUserInfoEvent(ProfileInfoApiModel profileInfoApiModel) {
    currentBloc.add(SaveUserInfoEvent(profileInfoApiModel));
  }

  Future<void> _continueAsGuestClicked() async {
    BottomNavigationScreen.open(context, 0);
  }

  Future<void> _openHomeScreen() async {
    BottomNavigationScreen.open(context, 0);
  }

  Future<void> _completedProfileScreen(String uuid, bool useMobile) async {
    CompletedProfileScreen.open(context, uuid, fromSocial: useMobile);
  }

  Future<void> _openOtpScreen(String uuid, bool fromSocial) async {
    OtpScreen.open(context, uuid,
        openAfterCheckOtp: OpenAfterCheckOtp.completeInfoScreen,
        useMobile: fromSocial);
  }

  Future<void> _openRegisterScreen() async {
    SignUpScreen.open(context);
  }

  Future<void> _openRecoveryPasswordScreen() async {
    await Navigator.of(context).pushNamed(ForgetPasswordScreen.routeName);
  }
}

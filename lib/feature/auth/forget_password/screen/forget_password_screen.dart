import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/feature/auth/_base/base_auth_screen.dart';
import 'package:vivas/feature/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:vivas/feature/auth/forget_password/bloc/forget_password_repository.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/auth/otp/screen/otp_screen.dart';

import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/logo/app_logo_title_widget.dart';
import 'package:vivas/feature/widgets/text_field/phone_number_form_filed_widget.dart';
import 'package:vivas/only_debug/user_debug_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_colors.dart';

import 'package:vivas/utils/build_type/build_type.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);
  static const routeName = '/forget-password-screen';

  static Future<void> open(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
    );
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgetPasswordBloc>(
      create: (context) => ForgetPasswordBloc(ForgetPasswordRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        authApiManager: AuthApiManager(dioApiManager , context),
      )),
      child: const ForgetPasswordScreenWithBloc(),
    );
  }
}

class ForgetPasswordScreenWithBloc extends BaseAuthScreen {
  const ForgetPasswordScreenWithBloc({super.key});

  @override
  BaseAuthState<ForgetPasswordScreenWithBloc> baseScreenCreateState() {
    return _ForgetPasswordScreenWithBloc();
  }
}

class _ForgetPasswordScreenWithBloc
    extends BaseAuthState<ForgetPasswordScreenWithBloc> with AuthValidate {
  late String _phoneNumber;
  PhoneNumber? _initialPhoneNumber;

  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    if (isDebugMode()) _setDebugUserNameAutomatic();
  }

  @override
  Widget bodyWidget(BuildContext context) {
    return BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (ctx, state) async {
        if (state is ForgetPasswordLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is ForgetPasswordErrorState) {
          showFeedbackMessage(state.isLocalizationKey
              ? translate(state.errorMassage)!
              : state.errorMassage);
        } else if (state is FormNotValidatedState) {
          autovalidateMode = AutovalidateMode.always;
        } else if (state is FormValidatedState) {
          _sendRequestOTPEvent();
        } else if (state is RequestOTPApiSuccessfullyState) {
          showFeedbackMessage(state.forgetPasswordSuccessfulResponse.message);
          _openOTPCodeScreen(state.forgetPasswordSuccessfulResponse.uuid,
              state.forgetPasswordSuccessfulResponse.resetToken);
        }
      },
      builder: (ctx, state) {
        return _buildForgetPasswordWidget();
      },
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _buildForgetPasswordWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(child: AppLogoTitleWidget()),
              SizedBox(height: 25.h),
              _labelsWidgets(),
              SizedBox(height: 30.h),
              _loginFormWidget(),
              SizedBox(height: 30.h),
              _forgetPasswordButtonsWidgets(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(translate(LocalizationKeys.forgotPassword)!,
            style: textTheme.labelLarge?.copyWith(
              fontSize: 24.spMin,
              color: AppColors.loginTitleText,
            )),
        SizedBox(height: 10.h),
        Text(
            translate(LocalizationKeys
                .pleaseEnterYourWhatsAppToGetAVerificationCode)!,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.loginSubTitleText,
              fontSize: 16.spMin,
            )),
      ],
    );
  }

  Widget _loginFormWidget() {
    return Form(
      key: forgetPasswordFormKey,
      autovalidateMode: autovalidateMode,
      child: AutofillGroup(
        child: Column(
          children: [
            PhoneNumberFormFiledWidget(
              title: translate(LocalizationKeys.whatsAppNumber)!,
              hintText: translate(LocalizationKeys.enterYourWhatsApp),
              autovalidateMode: autovalidateMode,
              onSaved: _saveUserName,
              initialValue: _initialPhoneNumber,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _validatePhoneNumber(),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _forgetPasswordButtonsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppElevatedButton.withTitle(
          onPressed: _validatePhoneNumber,
          title: translate(LocalizationKeys.getOtp)!,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  void _setDebugUserNameAutomatic() {
    _initialPhoneNumber = UserDebugModel.phoneNumber;
  }

  ForgetPasswordBloc get currentBloc =>
      BlocProvider.of<ForgetPasswordBloc>(context);

  void _validatePhoneNumber() {
    currentBloc.add(ValidateFormEvent(forgetPasswordFormKey));
  }

  void _sendRequestOTPEvent() {
    currentBloc.add(SendRequestOTPEvent(_phoneNumber));
  }

  void _saveUserName(PhoneNumber? userName) {
    _phoneNumber = userName!.international.substring(1);
  }

  void _openOTPCodeScreen(String uuid, String restToken) {
    OtpScreen.open(context, uuid,
        restToken: restToken,
        openAfterCheckOtp: OpenAfterCheckOtp.restPasswordScreen);
  }
}

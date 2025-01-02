import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/feature/auth/_base/base_auth_screen.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/auth/otp/bloc/otp_bloc.dart';
import 'package:vivas/feature/auth/otp/bloc/otp_repository.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ProfileOtpScreen extends StatelessWidget {
  static const routeName = '/profile-otp-screen';
  final String? uuid;
  final String? restToken;
  final bool isEmailUpdated;
  final String? updatedValue;

  final Function(OtpState)? otpStateListener;

  ProfileOtpScreen(
      {Key? key,
      this.uuid,
      this.restToken,
      this.isEmailUpdated = true,
      this.updatedValue,
      this.otpStateListener})
      : super(key: key);

  static open(BuildContext context, String uuid,
      {bool isEmailUpdated = true,
      String? restToken,
      String? updatedValue}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileOtpScreen(
          uuid: uuid,
          restToken: restToken,
          isEmailUpdated: isEmailUpdated,
          updatedValue: updatedValue,
        ),
      ),
    );
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtpBloc>(
      create: (context) => OtpBloc(OtpRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        authApiManager: AuthApiManager(dioApiManager , context),
      )),
      child: OtpScreenWithBloc(uuid ?? "", restToken, isEmailUpdated,
          updatedValue, otpStateListener),
    );
  }
}

class OtpScreenWithBloc extends BaseAuthScreen {
  final String uuid;
  final String? restToken;
  final bool isEmailUpdated;
  final String? updatedValue;

  final Function(OtpState)? otpStateListener;

  const OtpScreenWithBloc(this.uuid, this.restToken, this.isEmailUpdated,
      this.updatedValue, this.otpStateListener,
      {super.key});

  @override
  BaseAuthState<OtpScreenWithBloc> baseScreenCreateState() {
    return _OtpScreenWithBloc();
  }
}

class _OtpScreenWithBloc extends BaseAuthState<OtpScreenWithBloc>
    with AuthValidate {
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController otpEditingController = TextEditingController();
  late String _otpCode;
  @override
  void initState() {
    super.initState();
    if (widget.isEmailUpdated) Future.microtask(_sendRequestOTPAgainEvent);
  }

  @override
  Widget bodyWidget(BuildContext context) {
    return BlocConsumer<OtpBloc, OtpState>(
      listener: (ctx, state) async {
        if (state is OtpLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is OtpErrorState) {
          showFeedbackMessage(state.isLocalizationKey
              ? translate(state.errorMassage)!
              : state.errorMassage);
        } else if (state is OTPNotValidatedState) {
          autovalidateMode = AutovalidateMode.always;
        } else if (state is OTPValidatedState) {
          _checkOTPWithApiEvent();
        } else if (state is RequestOTPAgainApiSuccessfullyState) {
          showFeedbackMessage(state.message);
        } else if (state is CheckOTPApiSuccessfullyState) {
          showFeedbackMessage(state.message);
          widget.otpStateListener?.call(state);
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
              _labelsWidgets(),
              SizedBox(height: 30.h),
              _loginFormWidget(),
              SizedBox(height: 20.h),
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
        Text(translate(LocalizationKeys.verification)!,
            style: textTheme.labelLarge?.copyWith(
              fontSize: 24.spMin,
              color: AppColors.loginTitleText,
            )),
        SizedBox(height: 10.h),
        Text(
            translate(LocalizationKeys
                .pleaseEnterVerificationCodeHasBeenSentToYourWhatsAppNumber)!,
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
      key: otpFormKey,
      autovalidateMode: autovalidateMode,
      child: AutofillGroup(
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: PinCodeTextField(
                useExternalAutoFillGroup: true,
                autovalidateMode: autovalidateMode,
                appContext: context,
                pastedTextStyle: textTheme.bodyMedium,
                length: 4,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                animationType: AnimationType.fade,
                validator: otpValidator,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderWidth: .5,
                  borderRadius: BorderRadius.circular(10.r),
                  fieldHeight: 70.h,
                  inactiveFillColor: AppColors.pinCodeTextFieldFill,
                  selectedFillColor: AppColors.pinCodeTextFieldFill,
                  fieldWidth: 70.h,
                  activeBorderWidth: 1,
                  errorBorderWidth: .5,
                  inactiveBorderWidth: .5,
                  selectedColor: AppColors.pinCodeTextFieldSelected,
                  inactiveColor: AppColors.pinCodeTextFieldInactive,
                  activeColor: AppColors.pinCodeTextFieldActive,
                  activeFillColor: AppColors.pinCodeTextFieldFill,
                  fieldOuterPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                errorTextMargin: const EdgeInsets.symmetric(horizontal: 20),
                errorTextSpace: 30,
                animationDuration: const Duration(milliseconds: 100),
                enableActiveFill: true,
                keyboardType: const TextInputType.numberWithOptions(),
                dialogConfig: DialogConfig(
                  affirmativeText: translate(LocalizationKeys.paste),
                  dialogContent:
                      translate(LocalizationKeys.doYouWantToPasteThisCode),
                  dialogTitle: translate(LocalizationKeys.pasteOtpCode),
                  negativeText: translate(LocalizationKeys.cancel),
                  platform:
                      isOnIOS() ? PinCodePlatform.iOS : PinCodePlatform.other,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                beforeTextPaste: (otpCode) {
                  return true;
                },
                enablePinAutofill: true,
                textInputAction: TextInputAction.next,
                errorTextDirection: Directionality.of(context),
                controller: otpEditingController,
                onSaved: _otpSaved,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgetPasswordButtonsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextButton(
          onPressed: _sendRequestOTPAgainEvent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh, size: 16.h),
              SizedBox(width: 5.w),
              Text(
                translate(LocalizationKeys.resendVerificationCode)!,
                style: const TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10.h),
        AppElevatedButton.withTitle(
          onPressed: continueClicked,
          title: translate(LocalizationKeys.continuee)!,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  OtpBloc get currentBloc => BlocProvider.of<OtpBloc>(context);
  void _otpSaved(String? value) {
    _otpCode = value!;
  }

  void continueClicked() {
    currentBloc.add(ValidateOTPEvent(otpFormKey));
  }

  void _checkOTPWithApiEvent() {
    currentBloc.add(CheckOTPWithApiEvent(widget.uuid, _otpCode));
  }

  void _sendRequestOTPAgainEvent() {
    currentBloc.add(SendRequestOTPAgainEvent(widget.uuid));
  }
}

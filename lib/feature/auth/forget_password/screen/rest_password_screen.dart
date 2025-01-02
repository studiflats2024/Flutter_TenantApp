import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/auth_api_manager.dart';
import 'package:vivas/feature/auth/_base/base_auth_screen.dart';
import 'package:vivas/feature/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:vivas/feature/auth/forget_password/bloc/forget_password_repository.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/auth/login/screen/login_screen.dart';

import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_colors.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class RestPasswordScreen extends StatelessWidget {
  static const routeName = '/rest-password-screen';
  final String? uuid;
  final String? token;
  RestPasswordScreen({
    Key? key,
    this.uuid,
    this.token,
  }) : super(key: key);

  static open(BuildContext context, String uuid, String token) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RestPasswordScreen(
          uuid: uuid,
          token: token,
        ),
      ),
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
      child: RestPasswordScreenWithBloc(
        uuid ?? "",
        token ?? "",
      ),
    );
  }
}

class RestPasswordScreenWithBloc extends BaseAuthScreen {
  final String uuid;
  final String token;
  const RestPasswordScreenWithBloc(this.uuid, this.token, {super.key});

  @override
  BaseAuthState<RestPasswordScreenWithBloc> baseScreenCreateState() {
    return _RestPasswordScreenWithBloc();
  }
}

class _RestPasswordScreenWithBloc
    extends BaseAuthState<RestPasswordScreenWithBloc> with AuthValidate {
  GlobalKey<FormState> restPasswordFormKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _newPasswordController = TextEditingController();
  late String _newPassword;

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
          _resetPasswordApiEvent();
        } else if (state is ResetPasswordApiSuccessfullyState) {
          showFeedbackMessage(state.message);
          _openLoginScreen();
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
        Text(translate(LocalizationKeys.resetPassword)!,
            style: textTheme.labelLarge?.copyWith(
              fontSize: 24.spMin,
              color: AppColors.loginTitleText,
            )),
        SizedBox(height: 10.h),
        Text(translate(LocalizationKeys.pleaseEnterYourNewPasswordAndConfirm)!,
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
      key: restPasswordFormKey,
      autovalidateMode: autovalidateMode,
      child: AutofillGroup(
        child: Column(
          children: [
            AppTextFormField(
              title: translate(LocalizationKeys.newPassword)!,
              hintText: translate(LocalizationKeys.newPassword),
              controller: _newPasswordController,
              onSaved: _newPasswordSaved,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              obscure: true,
              validator: passwordValidator,
              autofillHints: const [
                AutofillHints.newPassword,
              ],
            ),
            SizedBox(height: 10.h),
            AppTextFormField(
              title: translate(LocalizationKeys.confirmPassword)!,
              hintText: translate(LocalizationKeys.confirmPassword),
              onSaved: _newPasswordSaved,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              obscure: true,
              validator: (v) =>
                  confirmPasswordValidator(v, _newPasswordController.text),
              onFieldSubmitted: (_) => resetPasswordClicked(),
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

  Widget _forgetPasswordButtonsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppElevatedButton.withTitle(
          onPressed: resetPasswordClicked,
          title: translate(LocalizationKeys.resetPassword)!,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  ForgetPasswordBloc get currentBloc =>
      BlocProvider.of<ForgetPasswordBloc>(context);

  void resetPasswordClicked() {
    currentBloc.add(ValidateFormEvent(restPasswordFormKey));
  }

  void _resetPasswordApiEvent() {
    currentBloc
        .add(ResetPasswordApiEvent(widget.uuid, widget.token, _newPassword));
  }

  void _newPasswordSaved(String? value) {
    _newPassword = value!;
  }

  void _openLoginScreen() {
    LoginScreen.open(context);
  }
}

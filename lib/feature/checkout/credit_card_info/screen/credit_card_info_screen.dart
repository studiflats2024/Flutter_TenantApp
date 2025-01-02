// ignore_for_file: unused_import, unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/contract_api_manager.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/checkout/checkout_details/bloc/checkout_bloc.dart';
import 'package:vivas/feature/checkout/checkout_details/bloc/checkout_repository.dart';
import 'package:vivas/feature/checkout/checkout_details/widget/checkout_invoice_widget.dart';
import 'package:vivas/feature/checkout/checkout_details/widget/checkout_item_widget.dart';
import 'package:vivas/feature/checkout/credit_card_info/bloc/credit_card_bloc.dart';
import 'package:vivas/feature/checkout/credit_card_info/bloc/credit_card_repository.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/month_picker_form_field_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

class CreditCardInfoScreen extends StatelessWidget {
  CreditCardInfoScreen({super.key});

  static const routeName = '/credit-card-info-screen';
  static const argumentRequestId = 'requestId';

  static Future<void> open(BuildContext context, String requestId) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      argumentRequestId: requestId,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreditCardBloc>(
      create: (context) => CreditCardBloc(CreditCardRepository(
          contractApiManger: ContractApiManger(dioApiManager , context))),
      child: CreditCardInfoScreenWithBloc(requestId(context)),
    );
  }

  String requestId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[CreditCardInfoScreen.argumentRequestId] as String;
}

class CreditCardInfoScreenWithBloc extends BaseStatefulScreenWidget {
  final String requestId;

  const CreditCardInfoScreenWithBloc(this.requestId, {super.key});

  @override
  BaseScreenState<CreditCardInfoScreenWithBloc> baseScreenCreateState() {
    return _CreditCardInfoScreenWithBloc();
  }
}

class _CreditCardInfoScreenWithBloc
    extends BaseScreenState<CreditCardInfoScreenWithBloc> with AuthValidate {
  //GetContractResponse? _contractResponseModel;

  String? _cardHolderName;
  String? _cardNumber;
  String? _cvv;
  DateTime? _expiryMonth;
  DateTime? _expiryYear;
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  bool? _acceptSAveDataCondition;

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(translate(LocalizationKeys.creditOrDebitCard)!)),
      body: BlocConsumer<CreditCardBloc, CreditCardState>(
        listener: (context, state) {
          if (state is CreditCardLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is CreditCardErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is CreditCardPaidSuccessfullyState) {}
        },
        builder: (context, state) => _buildCreditCardInfoWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////
  Widget _buildCreditCardInfoWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _cardInfoForm(),
            ]),
      ),
    );
  }

  Widget _cardInfoForm() {
    return Form(
      child: AutofillGroup(
        child: Column(
          children: [
            AppTextFormField(
              title: translate(LocalizationKeys.cardHolderName)!,
              requiredTitle: false,
              initialValue: _cardHolderName,
              hintText: translate(LocalizationKeys.pleaseEnterYourName),
              onSaved: _cardHolderNameSaved,
              onChanged: _cardHolderNameSaved,
              textInputAction: TextInputAction.done,
              validator: textValidator,
              maxLines: 1,
            ),
            SizedBox(height: 16.h),
            AppTextFormField(
              title: translate(LocalizationKeys.cardNumber)!,
              requiredTitle: false,
              initialValue: _cardNumber,
              hintText:
                  translate(LocalizationKeys.pleaseEnter16DigitCardNumber),
              onSaved: _cardNumberSaved,
              onChanged: _cardNumberSaved,
              textInputAction: TextInputAction.done,
              validator: textValidator,
              maxLines: 1,
            ),
            SizedBox(height: 16.h),
            DatePickerFormFiledWidget(
              controller: _monthController,
              title: translate(LocalizationKeys.expiryMonth)!,
              hintText: translate(LocalizationKeys.pleaseSelectExpiryMonth),
              onSaved: _expiryMonthSaved,
              validator: dateTimeValidator,
              maximumDate: DateTime((DateTime.now().year - 10)),
              minimumDate: DateTime((DateTime.now().year - 100)),
            ),
            MonthPickerFormFieldWidget(
                title: translate(LocalizationKeys.expiryMonth)!,
                hintText: translate(LocalizationKeys.pleaseSelectExpiryMonth),
                onSaved: _expiryMonthSaved,
                maximumDate: DateTime((DateTime.now().year - 10)),
                minimumDate: DateTime((DateTime.now().year - 100))),
            SizedBox(height: 16.h),
            DatePickerFormFiledWidget(
              controller: _yearController,
              title: translate(LocalizationKeys.expiryYear)!,
              hintText: translate(LocalizationKeys.pleaseSelectExpiryYear),
              onSaved: _expiryMonthSaved,
              validator: dateTimeValidator,
              maximumDate: DateTime((DateTime.now().year - 10)),
              minimumDate: DateTime((DateTime.now().year - 100)),
            ),
            SizedBox(height: 16.h),
            AppTextFormField(
              title: translate(LocalizationKeys.cvv)!,
              requiredTitle: false,
              initialValue: _cvv,
              hintText: translate(LocalizationKeys.pleaseEnterCVV),
              onSaved: _cvvSaved,
              onChanged: _cvvSaved,
              textInputAction: TextInputAction.done,
              validator: textValidator,
              maxLines: 1,
            ),
            _acceptSaveCardDataWidget(),
            _payNowButtonsWidgets()
          ],
        ),
      ),
    );
  }

  Widget _acceptSaveCardDataWidget() {
    return Row(
      children: [
        ColoredBox(
          color: Colors.white,
          child: SizedBox(
            height: 20.0,
            width: 20.0,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: _acceptSAveDataCondition ?? false,
              onChanged: (value) => _changeSaveChBox(value!),
              activeColor: AppColors.colorPrimary,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          translate(LocalizationKeys.saveCardDataForFutureTransactions)!,
          style: const TextStyle(
              color: Color(0xFF1B1B2F),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              decorationThickness: 2),
        ),
      ],
    );
  }

  Widget _payNowButtonsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppElevatedButton.withTitle(
          onPressed: _payNowClicked,
          title: translate(LocalizationKeys.payNow)!,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /*
  * SubmitButtonWidget(
            title:translate(LocalizationKeys.continuee)!,
            onClicked: _payNowClicked,
          )
  * */

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  CreditCardBloc get currentBloc => BlocProvider.of<CreditCardBloc>(context);

  void _payWithCreditEvent() {
    currentBloc.add(PayNowEvent());
  }

  void _payNowClicked() {
    currentBloc.add(PayNowEvent());
  }

  void _cardHolderNameSaved(String? value) {
    _cardHolderName = value!;
  }

  void _cardNumberSaved(String? value) {
    _cardNumber = value!;
  }

  void _expiryMonthSaved(DateTime? value) {
    _expiryMonth = value!;
  }

  void _expiryYearSaved(DateTime? value) {
    _expiryYear = value!;
  }

  void _cvvSaved(String? value) {
    _cvv = value!;
  }

  void _changeSaveChBox(bool? value) {
    _acceptSAveDataCondition = value;
  }
}

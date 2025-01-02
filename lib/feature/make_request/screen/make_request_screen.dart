import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/make_request/bloc/make_request_bloc.dart';
import 'package:vivas/feature/make_request/bloc/make_request_repository.dart';
import 'package:vivas/feature/make_request/model/request_ui_model.dart';
import 'package:vivas/feature/make_request/model/role_ui_model.dart';
import 'package:vivas/feature/make_request/widget/send_request_successfully_dialog.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/terms_text_widget/terms_text_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/custom_drop_down_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import '../../../preferences/preferences_manager.dart';
import '../../widgets/text_field/phone_number_form_filed_widget.dart';

class MakeRequestScreen extends StatelessWidget {
  MakeRequestScreen({Key? key}) : super(key: key);
  static const routeName = '/make-request-screen';
  static const argumentRequestUiModel = 'requestUiModel';

  static Future<void> open(
      BuildContext context, RequestUiModel requestUiModel) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      argumentRequestUiModel: requestUiModel,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MakeRequestBloc>(
      create: (context) => MakeRequestBloc(
          MakeRequestRepository(ApartmentRequestsApiManger(dioApiManager,context))),
      child: MakeRequestScreenWithBloc(requestUiModel(context)),
    );
  }

  RequestUiModel requestUiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[MakeRequestScreen.argumentRequestUiModel] as RequestUiModel;
}

class MakeRequestScreenWithBloc extends BaseStatefulScreenWidget {
  final RequestUiModel requestUiModel;

  const MakeRequestScreenWithBloc(this.requestUiModel, {super.key});

  @override
  BaseScreenState<MakeRequestScreenWithBloc> baseScreenCreateState() {
    return _MakeRequestScreenWithBloc();
  }
}

class _MakeRequestScreenWithBloc
    extends BaseScreenState<MakeRequestScreenWithBloc> with AuthValidate {
  late final RequestUiModel _requestUiModel;
  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  int numberOfGuestsTextFelid = 1;

  late DateTime _startDate = startDateInit;

  @override
  void initState() {
    numberOfGuestsTextFelid = widget.requestUiModel.numberOfGuests ?? 1;
    Future.microtask(_setInitialData);
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.completeYourRequest)!),
      ),
      body: BlocConsumer<MakeRequestBloc, MakeRequestState>(
        listener: (context, state) {
          if (state is MakeRequestLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is MakeRequestErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is FormNotValidatedState) {
            autovalidateMode = AutovalidateMode.always;
          } else if (state is FormValidatedState) {
            _sendRequestApiEvent();
          } else if (state is ChangeNumberOfGuestState) {
            numberOfGuestsTextFelid = state.numberOfGuests;
          } else if (state is StartDateChangedState) {
            _startDate = state.startDate;
            _endDateController.text = AppDateFormat.formattingDatePicker(
                _initialEndDate, appLocale.locale.languageCode);
          } else if (state is SendRequestSuccessfullyState) {
            showSendRequestSuccessfullyDialog(
              message: state.message,
              context: context,
              goBackCallback: _closeScreen,
            );
          }
        },
        builder: (ctx, state) {
          return _requestDetailsWidget();
        },
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _requestDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 20.h),
                  _requestFormWidget(),
                  SizedBox(height: 20.h),
                  TermsTextWidget(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
        _confirmYourRequestWidgets(),
      ],
    );
  }

  Widget _requestFormWidget() {
    return Form(
      key: requestFormKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          DatePickerFormFiledWidget(
            controller: _startDateController,
            title: translate(LocalizationKeys.startDate)!,
            hintText: translate(LocalizationKeys.startDate),
            onSaved: _startDateSave,
            validator: dateTimeValidator,
            maximumDate: maxDateInit,
            minimumDate: startDateInit,
            startDate: _startDate,
          ),
          SizedBox(height: 10.h),
          DatePickerFormFiledWidget(
            controller: _endDateController,
            title: translate(LocalizationKeys.endDate)!,
            hintText: translate(LocalizationKeys.endDate),
            onSaved: _endDateSave,
            validator: dateTimeValidator,
            maximumDate: maxDateInit,
            minimumDate: _initialEndDate,
            startDate: _initialEndDate,
          ),
          SizedBox(height: 10.h),
          CustomDropDownFormFiledWidget(
            initialValue: widget.requestUiModel.numberOfGuests != null
                ? CustomDropDownItem(
                    value: widget.requestUiModel.numberOfGuests.toString(),
                    key: widget.requestUiModel.numberOfGuests.toString(),
                  )
                : null,
            title: translate(LocalizationKeys.numberOfGuests)!,
            hintText: translate(LocalizationKeys.enterNameOfGuest)!,
            items: List.generate(
                widget.requestUiModel.numberOfGuests ?? 1,
                (index) => CustomDropDownItem(
                    key: "${index + 1}", value: "${index + 1}")),
            validator: customDropDownItemValidator,
            onSaved: _numberOfGuestSaved,
            onChanged: _changeNumberOfGuest,
          ),
          SizedBox(height: 10.h),
          ...List.generate(numberOfGuestsTextFelid, (index) {
            return _generateTextField(index);
          }),
          CustomDropDownFormFiledWidget(
            title: translate(LocalizationKeys.selectYourRole)!,
            hintText: translate(LocalizationKeys.selectYourRole)!,
            items: RoleUiModel.roles.map((role) {
              return CustomDropDownItem(
                  key: role.key, value: translate(role.value)!);
            }).toList(),
            validator: customDropDownItemValidator,
            onSaved: _roleSaved,
          ),
          SizedBox(height: 10.h),
          AppTextFormField(
            title: translate(LocalizationKeys.agencyBrokerCode)!,
            requiredTitle: false,
            hintText: translate(LocalizationKeys.eg100),
            onSaved: _agencyBrokerCodeSaved,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 10.h),
          AppTextFormField(
            title: translate(LocalizationKeys.purposeOfComingToGermany)!,
            hintText: translate(LocalizationKeys.enterPurposeOfComingToGermany),
            onSaved: _purposeOfComingToGermanySaved,
            validator: textValidator,
            maxLines: 4,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Widget _confirmYourRequestWidgets() {
    return SubmitButtonWidget(
      title: translate(LocalizationKeys.confirmYourRequest)!,
      onClicked: _confirmClicked,
    );
  }

  Widget _generateTextField(int index) {
    return Column(
      children: [
        AppTextFormField(
          hintText:
              "${translate(LocalizationKeys.enterNameOfGuest)!} ${(index + 1)}",
          title: "${translate(LocalizationKeys.guest)!} ${(index + 1)}",
          onSaved: (value) => _guestNAmeSavedSaved(index, value!),
          validator: textValidator,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 10.h)
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  MakeRequestBloc get currentBloc => BlocProvider.of<MakeRequestBloc>(context);

  void _confirmClicked() {
    currentBloc.add(ValidateFormEvent(requestFormKey));
  }

  void _sendRequestApiEvent() {
    currentBloc.add(SendRequestApiEvent(_requestUiModel));
  }

  void _changeNumberOfGuest(CustomDropDownItem? value) {
    currentBloc.add(ChangeNumberOfGuestEvent(int.parse(value!.key)));
  }

  get startDateInit {
    return DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  late final maxDateInit = _startDate.add(const Duration(days: 365 * 5));

  void _setInitialData() {
    _requestUiModel = RequestUiModel(aptUUID: widget.requestUiModel.aptUUID);
    _requestUiModel.startDate =
        widget.requestUiModel.startDate ?? startDateInit;
    _requestUiModel.endDate = widget.requestUiModel.endDate ?? _initialEndDate;
    _requestUiModel.numberOfGuests = widget.requestUiModel.numberOfGuests;
    _startDate = widget.requestUiModel.startDate ?? startDateInit;
    _startDateController.text = AppDateFormat.formattingDatePicker(
        _startDate, appLocale.locale.languageCode);
    _endDateController.text = AppDateFormat.formattingDatePicker(
        _initialEndDate, appLocale.locale.languageCode);
    _startDateController.addListener(() {
      _changeStartDate(AppDateFormat.appDatePickerParse(
          _startDateController.text, appLocale.locale.languageCode));
    });
  }

  DateTime get _initialEndDate {
    DateTime endDate = _startDate.add(const Duration(days: 155));
    return DateTime(endDate.year, endDate.month, 0);
  }

  void _roleSaved(CustomDropDownItem? value) {
    _requestUiModel.role = value?.key;
  }

  void _numberOfGuestSaved(CustomDropDownItem? value) {
    _requestUiModel.numberOfGuests = int.parse(value!.key);
  }

  void _agencyBrokerCodeSaved(String? value) {
    _requestUiModel.brokerCode = value;
  }

  void _purposeOfComingToGermanySaved(String? value) {
    _requestUiModel.purposeOfComingToGermany = value;
  }

  void _guestNAmeSavedSaved(int index, String value) {
    _requestUiModel.nameOfGuests[index] = value;
  }

  void _startDateSave(DateTime? date) {
    if (date != null) {
      _requestUiModel.startDate = date;
    }
  }

  void _endDateSave(DateTime? date) {
    if (date != null) {
      _requestUiModel.endDate = date;
    }
  }

  void _changeStartDate(DateTime? startDate) {
    currentBloc.add(ChangeStartDateEvent(startDate!));
  }

  void _closeScreen() {
    Navigator.of(context).pop();
  }
}



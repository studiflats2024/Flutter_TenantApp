import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/feature/make_waiting_request/bloc/make_waiting_request_bloc.dart';
import 'package:vivas/feature/make_waiting_request/bloc/make_waiting_request_repository.dart';
import 'package:vivas/feature/make_waiting_request/model/waiting_request_ui_model.dart';
import 'package:vivas/feature/make_waiting_request/widget/send_waiting_request_successfully_dialog.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/custom_drop_down_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/mangers/search_manger.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class MakeWaitingRequestScreen extends StatelessWidget {
  MakeWaitingRequestScreen({Key? key}) : super(key: key);
  static const routeName = '/make-waiting-request-screen';
  static const argumentRequestUiModel = 'requestUiModel';

  static Future<void> open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      // argumentRequestUiModel: requestUiModel,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MakeWaitingRequestBloc>(
      create: (context) => MakeWaitingRequestBloc(MakeWaitingRequestRepository(
          ApartmentRequestsApiManger(dioApiManager,context))),
      child: const MakeWaitingRequestScreenWithBloc(),
    );
  }

  // WaitingRequestUiModel requestUiModel(BuildContext context) =>
  //     (ModalRoute.of(context)!.settings.arguments
  //             as Map)[MakeWaitingRequestScreen.argumentRequestUiModel]
  //         as WaitingRequestUiModel;
}

class MakeWaitingRequestScreenWithBloc extends BaseStatefulScreenWidget {
  final WaitingRequestUiModel? requestUiModel;
  const MakeWaitingRequestScreenWithBloc({this.requestUiModel, super.key});

  @override
  BaseScreenState<MakeWaitingRequestScreenWithBloc> baseScreenCreateState() {
    return _MakeWaitingRequestScreenWithBloc();
  }
}

class _MakeWaitingRequestScreenWithBloc
    extends BaseScreenState<MakeWaitingRequestScreenWithBloc>
    with AuthValidate {
  final WaitingRequestUiModel _requestUiModel = WaitingRequestUiModel();
  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  int numberOfGuestsTextFelid = 20;

  late DateTime _startDate = startDateInit;

  @override
  void initState() {
    // numberOfGuestsTextFelid = widget.requestUiModel.numberOfGuests ?? 1;

    Future.microtask(_setInitialData);
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.waitingList)!),
      ),
      body: BlocConsumer<MakeWaitingRequestBloc, MakeWaitingRequestState>(
        listener: (context, state) {
          if (state is MakeWaitingRequestLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is MakeWaitingRequestErrorState) {
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
            showSendWaitingRequestSuccessfullyDialog(
              // message: state.message,

              context: context,
              goBackCallback: _openHomeScreen,
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
            initialValue: widget.requestUiModel?.numberOfGuests != null
                ? CustomDropDownItem(
                    value: widget.requestUiModel!.numberOfGuests.toString(),
                    key: widget.requestUiModel!.numberOfGuests.toString(),
                  )
                : null,
            title: translate(LocalizationKeys.numberOfGuests)!,
            hintText: translate(LocalizationKeys.enterNameOfGuest)!,
            items: List.generate(
                widget.requestUiModel?.numberOfGuests ??
                    numberOfGuestsTextFelid,
                (index) => CustomDropDownItem(
                    key: "${index + 1}", value: "${index + 1}")),
            validator: customDropDownItemValidator,
            onSaved: _numberOfGuestSaved,
            // onChanged: _changeNumberOfGuest,
          ),
          SizedBox(height: 10.h),
          AppTextFormField(
            title: translate(LocalizationKeys.whatIsTheMaximumBudgetForRent)!,
            hintText: translate(LocalizationKeys.budgetHintText),
            validator: textValidator,
            onSaved: _rentFeesSaved,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 10.h),
          CustomDropDownFormFiledWidget(
            title: translate(LocalizationKeys.city)!,
            hintText: translate(LocalizationKeys.city)!,
            items: GetIt.I<SearchManger>().citiesList.map((area) {
              return CustomDropDownItem(key: area.name, value: area.name);
            }).toList(),
            validator: customDropDownItemValidator,
            onSaved: _citySaved,
          ),
          SizedBox(height: 10.h),
          AppTextFormField(
            title: translate(LocalizationKeys.doYouWantToTellUsMore)!,
            hintText: translate(LocalizationKeys.enterDetails),
            onSaved: _tellMoreSaved,
            validator: textOpticalValidator,
            maxLines: 4,
            requiredTitle: false,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Widget _confirmYourRequestWidgets() {
    return SubmitButtonWidget(
      title: translate(LocalizationKeys.setOnWaitingList)!,
      onClicked: _confirmClicked,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  MakeWaitingRequestBloc get currentBloc =>
      BlocProvider.of<MakeWaitingRequestBloc>(context);

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
    _requestUiModel.startDate =
        widget.requestUiModel?.startDate ?? startDateInit;
    _requestUiModel.endDate = widget.requestUiModel?.endDate ?? _initialEndDate;
    _requestUiModel.numberOfGuests = widget.requestUiModel?.numberOfGuests;
    _startDate = widget.requestUiModel?.startDate ?? startDateInit;
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

  void _citySaved(CustomDropDownItem? value) {
    _requestUiModel.city = value?.key;
  }

  void _numberOfGuestSaved(CustomDropDownItem? value) {
    _requestUiModel.numberOfGuests = int.parse(value!.key);
  }

  void _rentFeesSaved(String? value) {
    _requestUiModel.rentFees = value;
  }

  void _tellMoreSaved(String? value) {
    _requestUiModel.tellMore = value;
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

  void _openHomeScreen() {
    BottomNavigationScreen.open(context, 0);
  }
}

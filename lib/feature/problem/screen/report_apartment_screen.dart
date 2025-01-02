import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/problems_api_manger.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/problem/bloc/my_problem_bloc.dart';
import 'package:vivas/feature/problem/bloc/my_problem_repository.dart';
import 'package:vivas/feature/problem/model/send_problem_model.dart';
import 'package:vivas/feature/problem/widgets/select_image_widget.dart';
import 'package:vivas/feature/problem/widgets/send_problem_successfully_dialog.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_time_form_field_widget.dart';
import 'package:vivas/feature/widgets/text_field/phone_number_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/time_picker_form_field_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ReportApartmentScreen extends StatelessWidget {
  ReportApartmentScreen({Key? key}) : super(key: key);
  static const routeName = '/report_apartment_screen';
  static const argumentUnitUUID = 'UnitUUID';

  static Future<void> open(BuildContext context, String unitUUID) async {
    await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
      argumentUnitUUID: unitUUID,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyProblemBloc>(
      create: (context) => MyProblemBloc(MyProblemRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        problemsApiManger: ProblemsApiManger(dioApiManager , context),
      )),
      child: ReportApartmentScreenWithBloc(unitUUID(context)),
    );
  }

  String unitUUID(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentUnitUUID]
          as String;
}

class ReportApartmentScreenWithBloc extends BaseStatefulScreenWidget {
  final String unitUUID;
  const ReportApartmentScreenWithBloc(this.unitUUID, {super.key});

  @override
  BaseScreenState<ReportApartmentScreenWithBloc> baseScreenCreateState() {
    return _ReportApartmentScreenWithBloc();
  }
}

class _ReportApartmentScreenWithBloc
    extends BaseScreenState<ReportApartmentScreenWithBloc> with AuthValidate {
  late final SendProblemModel _sendProblemModel;
  GlobalKey<FormState> problemFormKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  int numberDateTextFelid = 1;
  Map<int, Widget> dates = {};
  @override
  void initState() {
    _sendProblemModel = SendProblemModel(aptUUID: widget.unitUUID);
    Future.delayed(Duration.zero, _generateDateList);
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.reportProblemInTheApartment)!),
      ),
      body: BlocConsumer<MyProblemBloc, MyProblemState>(
          listener: (context, state) {
        if (state is MyProblemLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is MyProblemErrorState) {
          showFeedbackMessage(state.isLocalizationKey
              ? translate(state.errorMassage)!
              : state.errorMassage);
        } else if (state is FormNotValidatedState) {
          autovalidateMode = AutovalidateMode.always;
        } else if (state is FormValidatedState) {
          _sendReportApiEvent();
        } else if (state is ChangeNumberOfDateAvailableState) {
          numberDateTextFelid = state.numberDate;
          _generateDateList();
        } else if (state is SendProblemSuccessfullyState) {
          showSendProblemSuccessfullyDialog(
            context: context,
            goBackCallback: _closeScreen,
          );
        }
      }, builder: (ctx, state) {
        return Column(
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
                      _reportFormWidget(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
            SubmitButtonWidget(
              title: translate(LocalizationKeys.sendReport)!,
              onClicked: _sendReportClicked,
            ),
          ],
        );
      }),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _reportFormWidget() {
    return Form(
      key: problemFormKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextFormField(
            title: translate(LocalizationKeys.nameOnTheRingBell)!,
            hintText: translate(LocalizationKeys.pleaseEnterNameOnTheRingBell),
            onSaved: _nameSaved,
            validator: textValidator,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 10.h),
          PhoneNumberFormFiledWidget(
            title: translate(LocalizationKeys.phoneNumber)!,
            hintText: translate(LocalizationKeys.pleaseEnterPhoneNumber),
            autovalidateMode: autovalidateMode,
            onSaved: _phoneNumberSaved,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 10.h),
          PhoneNumberFormFiledWidget(
            requiredTitle: false,
            allowEmpty: true,
            title: translate(LocalizationKeys.alternativePhoneNumber)!,
            hintText: translate(LocalizationKeys.pleaseEnterPhoneNumber),
            autovalidateMode: autovalidateMode,
            onSaved: _phoneNumber2Saved,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 10.h),
          SelectImagesWidget(_selectImage),
          SizedBox(height: 10.h),
          AppTextFormField(
            title: translate(LocalizationKeys.problemDescription)!,
            hintText: translate(LocalizationKeys.enterDescription),
            onSaved: _descriptionSaved,
            validator: textValidator,
            maxLines: 4,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 20.h),
          Text(
            translate(LocalizationKeys.listOfAvailableAppointments)!,
            style: const TextStyle(
              color: Color(0xFF475466),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20.h),
          ...dates.values,
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: _changeNumberOfDateAvailableEvent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.add),
                const SizedBox(width: 10),
                Text(
                  translate(LocalizationKeys.addAppointments)!,
                  style: const TextStyle(
                    color: Color(0xFF1151B4),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _generateDateList() {
    if (dates.isEmpty) {
      _sendProblemModel.dateTimeAvailable[0] = {};
      dates[0] = _generateDateField(0);
    }
    if (numberDateTextFelid != dates.length) {
      _sendProblemModel.dateTimeAvailable[numberDateTextFelid - 1] = {};
      dates[numberDateTextFelid - 1] =
          _generateDateField(numberDateTextFelid - 1);
    }
    setState(() {});
  }

  Widget _generateDateField(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DateTimeFormFieldWidget(
                    title: translate(LocalizationKeys.date)!,
                    hintText: translate(LocalizationKeys.date),
                    onSaved: (value) => _dateSavedSaved(index, value!),
                    validator: dateTimeValidator,
                    languageKey: appLocale.locale.languageCode,
                  ),
                ),
                SizedBox(width: 20.h),
                Expanded(
                  child: TimePickerFormFieldWidget(
                    validator: timeValidator,
                    title: translate(LocalizationKeys.time)!,
                    hintText: translate(LocalizationKeys.time),
                    onSaved: (value) => _timeSavedSaved(index, value!),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: index == 0
                  ? null
                  : () {
                      _removeDateField(index);
                    },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ))
        ],
      ),
    );
  }
  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  MyProblemBloc get currentBloc => BlocProvider.of<MyProblemBloc>(context);

  void _sendReportClicked() {
    currentBloc.add(ValidateFormEvent(problemFormKey));
  }

  void _sendReportApiEvent() {
    currentBloc.add(SendProblemApiEvent(_sendProblemModel));
  }

  void _nameSaved(String? value) {
    _sendProblemModel.nameRingBell = value;
  }

  void _phoneNumberSaved(PhoneNumber? value) {
    _sendProblemModel.phoneNumber = value!.international.substring(1);
  }

  void _phoneNumber2Saved(PhoneNumber? value) {
    _sendProblemModel.phoneNumber2 = value?.international.substring(1);
  }

  void _descriptionSaved(String? value) {
    _sendProblemModel.issueDesc = value;
  }

  void _changeNumberOfDateAvailableEvent() {
    currentBloc.add(ChangeNumberOfDateAvailableEvent(++numberDateTextFelid));
  }

  void _dateSavedSaved(int index, DateTime value) {
    _sendProblemModel.dateTimeAvailable[index]!["date"] =
        AppDateFormat.formattingApiDate(value, "en");
  }

  void _timeSavedSaved(int index, TimeOfDay value) {
    _sendProblemModel.dateTimeAvailable[index]!["time"] = value.format(context);
  }

  void _removeDateField(int index) {
    numberDateTextFelid--;
    dates.removeWhere((key, value) => key == index);
    setState(() {
      _sendProblemModel.dateTimeAvailable.remove(index);
    });
  }

  void _closeScreen() {
    Navigator.of(context).pop();
  }

  void _selectImage(List<String> imageList) {
    _sendProblemModel.imagesUrl = imageList;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/contract_api_manager.dart';
import 'package:vivas/apis/models/contract/prepare_check_in/prepare_check_in_send_model.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/contract/prepare_check_in/bloc/prepare_check_in_bloc.dart';
import 'package:vivas/feature/contract/prepare_check_in/bloc/prepare_check_in_repository.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_time_form_field_widget.dart';
import 'package:vivas/feature/widgets/text_field/time_picker_form_field_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

class PrepareCheckInScreen extends StatelessWidget {
  PrepareCheckInScreen({super.key});

  static const routeName = '/check-in-screen';
  static const argumentRequestId = 'requestId';

  static Future<void> open(BuildContext context, String requestId,
      {bool openWithReplacement = false}) async {
    if (openWithReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentRequestId: requestId,
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentRequestId: requestId,
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrepareCheckInBloc>(
      create: (context) => PrepareCheckInBloc(PrepareCheckInRepository(
        contractApiManger: ContractApiManger(dioApiManager , context),
      )),
      child: PrepareCheckInScreenWithBloc(requestId(context)),
    );
  }

  String requestId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[PrepareCheckInScreen.argumentRequestId] as String;
}

class PrepareCheckInScreenWithBloc extends BaseStatefulScreenWidget {
  final String requestId;

  const PrepareCheckInScreenWithBloc(this.requestId, {super.key});

  @override
  BaseScreenState<PrepareCheckInScreenWithBloc> baseScreenCreateState() {
    return _PrepareCheckInScreenWithBloc();
  }
}

class _PrepareCheckInScreenWithBloc
    extends BaseScreenState<PrepareCheckInScreenWithBloc> with AuthValidate {
  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
  }

  DateTime? _arrivalDate;
  TimeOfDay? _arrivalTime;

  bool isYesOptionSelected = false;

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(translate(LocalizationKeys.letsPrepareYourCheckIn)!)),
      body: BlocConsumer<PrepareCheckInBloc, PrepareCheckInState>(
        listener: (context, state) {
          if (state is CheckInLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is CheckInErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is FormNotValidatedState) {
            autovalidateMode = AutovalidateMode.always;
          } else if (state is FormValidatedState) {
            _sendCheckInApi();
          } else if (state is ServiceOptionChangedState) {
            isYesOptionSelected = state.isYesOptionSelected;
          } else if (state is CheckInSuccessfullyState) {
            _closeScreen();
          }
        },
        builder: (context, state) => _checkInWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////
  Widget _checkInWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      translate(LocalizationKeys
                          .pleaseFillInTheFieldsBelowWithYourLoginDetails)!,
                      style: const TextStyle(
                        color: Color(0xFF344054),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _requestFormWidget(),
                    SizedBox(height: 32.h),
                    _optionsWidget()
                  ]),
            ),
          ),
        ),
        _confirmYourRequestWidgets()
      ],
    );
  }

  Widget _requestFormWidget() {
    return Form(
      key: requestFormKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          DateTimeFormFieldWidget(
            title: translate(LocalizationKeys.arrivalDate)!,
            hintText: translate(LocalizationKeys.arrivalDate),
            onSaved: _arrivalDateSave,
            validator: dateTimeValidator,
            maximumDate: maxDate,
            minimumDate: minDate,
            languageKey: appLocale.locale.languageCode,
          ),
          SizedBox(height: 16.h),
          TimePickerFormFieldWidget(
            title: translate(LocalizationKeys.arrivalTime)!,
            hintText: translate(LocalizationKeys.arrivalTime),
            onSaved: _arrivalTimeSave,
            validator: timeValidator,
          ),
        ],
      ),
    );
  }

  Widget _optionsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.doYouNeedMovingServiceWithinBerlin)!,
                style: const TextStyle(
                  color: Color(0xFF344054),
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                translate(LocalizationKeys.freeForNewUsers)!,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  Radio<bool>(
                      value: true,
                      activeColor: AppColors.colorPrimary,
                      groupValue: isYesOptionSelected,
                      onChanged: (value) {
                        _changeServiceOptionEvent(value!);
                      }),
                  Text(
                    translate(LocalizationKeys.yes)!,
                    style: const TextStyle(
                      color: Color(0xFF162447),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Radio<bool>(
                      value: false,
                      activeColor: AppColors.colorPrimary,
                      groupValue: isYesOptionSelected,
                      onChanged: (value) {
                        _changeServiceOptionEvent(value!);
                      }),
                  Text(
                    translate(LocalizationKeys.no)!,
                    style: const TextStyle(
                      color: Color(0xFF162447),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _confirmYourRequestWidgets() {
    return SubmitButtonWidget(
      title: translate(LocalizationKeys.send)!,
      onClicked: _validateFormEvent,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  PrepareCheckInBloc get currentBloc =>
      BlocProvider.of<PrepareCheckInBloc>(context);

  late final minDate = DateTime.now();
  late final maxDate = minDate.add(const Duration(days: 365));

  void _arrivalDateSave(DateTime? date) {
    if (date != null) {
      _arrivalDate = date;
    }
  }

  void _arrivalTimeSave(TimeOfDay? time) {
    if (time != null) {
      _arrivalTime = time;
    }
  }

  void _validateFormEvent() {
    currentBloc.add(ValidateFormEvent(requestFormKey));
  }

  void _changeServiceOptionEvent(bool value) {
    currentBloc.add(ChangeServiceOptionEvent(value));
  }

  void _sendCheckInApi() {
    currentBloc.add(SendCheckInEvent(PrepareCheckInSendModel(
      requestId: widget.requestId,
      checkDate: AppDateFormat.formattingApiDate(_arrivalDate!, "en"),
      checkTime: _arrivalTime!.format(context),
      moveService: isYesOptionSelected,
    )));
  }

  void _closeScreen() {
    Navigator.of(context).pop();
  }
}

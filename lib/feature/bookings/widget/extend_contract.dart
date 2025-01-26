import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/date_manager.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/apis/models/booking/extend_contract_model.dart';
import 'package:vivas/feature/bookings/bloc/booking__bloc.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ExtendContract extends BaseStatelessWidget {
  final ExtendContractModel extendContractModel;
  final Function() afterChange;
  final DateTime availableTo;

  ExtendContract(this.extendContractModel, this.afterChange, this.availableTo,
      {super.key});

  PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();
  DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
        create: (context) => BookingBloc(
              BookingsRepository(
                preferencesManager: preferencesManager,
                apartmentRequestsApiManger: ApartmentRequestsApiManger(
                  dioApiManager,
                  context,
                ),
              ),
            ),
        child: ExtendContractScreen(
            extendContractModel, afterChange, availableTo));
  }
}

class ExtendContractScreen extends BaseStatefulScreenWidget {
  final ExtendContractModel extendContractModel;
  final Function() afterChange;
  final DateTime availableTo;

  const ExtendContractScreen(
    this.extendContractModel,
    this.afterChange,
    this.availableTo,
  );

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _ExtendContractScreen();
  }
}

class _ExtendContractScreen extends BaseScreenState<ExtendContractScreen> {
  late ExtendContractModel extendContractModel;
  late int calculating;

  late int days;
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    extendContractModel = widget.extendContractModel;
    calculating = !DateManager.hasThirtyOneDays(
            extendContractModel.startDate?.year ?? DateTime.now().year,
            extendContractModel.startDate?.month ?? DateTime.now().month)
        ? (31 - (extendContractModel.startDate?.day ?? 0))
        : (30 - (extendContractModel.startDate?.day ?? 0));
    days = !DateManager.hasThirtyOneDays(
            extendContractModel.startDate?.year ?? DateTime.now().year,
            extendContractModel.startDate?.month ?? DateTime.now().month)
        ? calculating > 0
            ? calculating + 30
            : 30
        : calculating > 0
            ? calculating + 31
            : 31;
    super.initState();
  }

  BookingBloc get currentBloc => BlocProvider.of<BookingBloc>(context);

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is ExtendContractLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is SetEndDateState) {
          extendContractModel.endDate = state.endDate;
        } else if (state is ExtendContractSuccessState) {
          widget.afterChange();
          Navigator.of(context).pop();
        } else if (state is ExtendContractFailedState) {
          showFeedbackMessage(state.errorApiModel.message);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Start Date :",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                    " ${DateFormat("dd/MM/yyyy").format(extendContractModel.startDate ?? DateTime.now())}"),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            DatePickerFormFiledWidget(
                title: "EndDate",
                controller: _endDateController,
                maximumDate: widget.availableTo,
                minimumDate: extendContractModel.startDate?.add(
                      Duration(days: days),
                    ) ??
                    DateTime.now(),
                hintText: "Enter your end date for extend",
                onSaved: (val) {
                  if (val != null) {
                    currentBloc.add(SetEndDateEvent(val));
                  }
                }),
            SizedBox(
              height: 15.h,
            ),
            Center(
              child: AppElevatedButton(
                onPressed: () {
                  if (_endDateController.text.isNotEmpty) {
                    extendContractModel.endDate =
                        AppDateFormat.appDatePickerParse(
                            _endDateController.text,
                            appLocale.locale.languageCode);
                    currentBloc.add(ExtendContractEvent(extendContractModel));
                  } else {
                    showFeedbackMessage("choose your end date first");
                  }
                },
                label: Text(
                  translate(LocalizationKeys.continuee)!,
                  style: TextStyle(
                      color: AppColors.appButtonText, fontSize: 14.sp),
                ),
                color: AppColors.colorPrimary,
              ),
            )
          ],
        );
      },
    );
  }
}

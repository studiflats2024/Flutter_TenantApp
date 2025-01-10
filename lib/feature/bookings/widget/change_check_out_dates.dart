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
import 'package:vivas/apis/models/booking/change_check_out_date_model.dart';
import 'package:vivas/apis/models/booking/extend_contract_model.dart';
import 'package:vivas/feature/bookings/bloc/booking__bloc.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/validations/validator.dart';

class ChangeCheckOutDates extends BaseStatelessWidget {
  final ChangeCheckOutDateModel model;
  final Function() afterChange;

  ChangeCheckOutDates(this.model, this.afterChange);

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
        child: ChangeCheckOutDateScreen(model, afterChange));
  }
}

class ChangeCheckOutDateScreen extends BaseStatefulScreenWidget {
  final ChangeCheckOutDateModel model;
  final Function() afterChange;

  ChangeCheckOutDateScreen(this.model, this.afterChange);

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _ChangeCheckOutDateScreen();
  }
}

class _ChangeCheckOutDateScreen
    extends BaseScreenState<ChangeCheckOutDateScreen> {
  late ChangeCheckOutDateModel model;
  final TextEditingController _endDateController = TextEditingController();
  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();

  late int calculating;

  late int days;

  @override
  void initState() {
    model = widget.model;
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
          model.newEndDate = state.endDate;
        }
        if (state is ExtendContractSuccessState) {
          widget.afterChange();
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Form(
            key: requestFormKey,
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Start Date :",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                    " ${DateFormat("dd/MM/yyyy").format(model.startDate ?? DateTime.now())}"),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            DatePickerFormFiledWidget(
              title: translate(LocalizationKeys.checkOut)!,
              controller: _endDateController,
              maximumDate: model.endDate!,
              minimumDate: DateTime.now(),
              hintText: "Enter new checkout date",
              validator: Validator.validateDateTimeNotEmpty,
              onSaved: (val) {
                print("Saved");
                if (val != null) {
                  currentBloc.add(SetEndDateEvent(val));
                }
              },onFieldSubmitted: (val) {
              print("Saved");
              if (val != null) {
                currentBloc.add(SetEndDateEvent(val));
              }
            },
            ),
            SizedBox(
              height: 15.h,
            ),
            Center(
              child: AppElevatedButton(
                onPressed: () {
                  if (requestFormKey.currentState?.validate() ?? false) {
                    model.newEndDate = AppDateFormat.appDatePickerParse(
                        _endDateController.text, appLocale.locale.languageCode);
                    currentBloc.add(ChangeCheckoutDateEvent(model));
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
        ));
      },
    );
  }
}

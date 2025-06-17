import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/arriving_details/Models/arriving_details_request_model.dart';
import 'package:vivas/feature/arriving_details/bloc/arriving_details_bloc.dart';
import 'package:vivas/feature/arriving_details/bloc/arriving_repository.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_time_form_field_widget.dart';
import 'package:vivas/feature/widgets/text_field/time_picker_form_field_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../apis/_base/dio_api_manager.dart';

class ArrivingDetails extends StatelessWidget {
  ArrivingDetails({super.key});

  static const routeName = '/_arriving-details-screen';
  static const argumentArrivingRouteName = '/_arriving-details-screen';
  static const argumentApartmentRequestsApiModel = 'ApartmentRequestsApiModel';

  static Future<void> open(
      BuildContext context,
      ArrivingDetailsRequestModel arrivingDetailsRequestModel,
      BookingDetailsModel bookingDetailsModel,
      bool replacement) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentArrivingRouteName: arrivingDetailsRequestModel,
        argumentApartmentRequestsApiModel: bookingDetailsModel
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentArrivingRouteName: arrivingDetailsRequestModel,
        argumentApartmentRequestsApiModel: bookingDetailsModel
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArrivingDetailsBloc(
        ArrivingRepository(
          apartmentRequestsApiManger: ApartmentRequestsApiManger(
            dioApiManager,context
          ),
        ),
      ),
      child: ArrivingDetailsWithBloc(
          arrivingDetailsRequestModel: arrivingDetailsRequestModel(context),
        bookingDetailsModel: bookingDetailsModel(context),
      ),
    );
  }

  BookingDetailsModel bookingDetailsModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[ArrivingDetails.argumentApartmentRequestsApiModel]
          as BookingDetailsModel;

  ArrivingDetailsRequestModel arrivingDetailsRequestModel(
          BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[ArrivingDetails.argumentArrivingRouteName]
          as ArrivingDetailsRequestModel;
}

class ArrivingDetailsWithBloc extends BaseStatefulScreenWidget {
  ArrivingDetailsRequestModel arrivingDetailsRequestModel;
  BookingDetailsModel bookingDetailsModel;

  ArrivingDetailsWithBloc(
      {super.key,
      required this.arrivingDetailsRequestModel,
      required this.bookingDetailsModel});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _ArrivingDetailsScreenState();
  }
}

class _ArrivingDetailsScreenState
    extends BaseScreenState<ArrivingDetailsWithBloc> with AuthValidate {
  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late ArrivingDetailsRequestModel arrivingDetailsRequestModel;

  DateTime? _arrivalDate;
  TimeOfDay? _arrivalTime;

  ArrivingDetailsBloc get currentBloc =>
      BlocProvider.of<ArrivingDetailsBloc>(context);

  late DateTime minDate ;
  late DateTime maxDate ;

  bool isYesOptionSelected = false;

  @override
  void initState() {
    minDate = DateTime.now();
    // minDate = DateFormat("M/d/yyyy").parse(widget.bookingDetailsModel.checkIn ?? "");
    maxDate = minDate.add(const Duration(days: 365));
    arrivingDetailsRequestModel = widget.arrivingDetailsRequestModel;
    print("minDate: ${minDate.toString()}");
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            translate(LocalizationKeys.arrivingDetails) ?? "",
            style: const TextStyle(
              color: AppColors.appFormFieldTitle,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocConsumer<ArrivingDetailsBloc, ArrivingDetailsState>(
          listener: (context, state) {
            if (state is SendingArrivingDetailsLoading) {
              showLoading();
            } else {
              hideLoading();
            }

            if (state is FormValidatedState) {
              currentBloc
                  .add(SendArrivingDetailsEvent(arrivingDetailsRequestModel));
            }
            if (state is SetArrivingDetailsState) {
              arrivingDetailsRequestModel = state.arrivingDetailsRequestModel;
            }
            if (state is SendingArrivingDetailsSuccess) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate(LocalizationKeys
                                    .pleaseFillArrivingDetails) ??
                                "",
                            style: const TextStyle(
                              color: Color(0xFF344053),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.34,
                            ),
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF5F5F5),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFCECECE)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const Text(
                                //   "Ashraf Salah",
                                //   style: TextStyle(
                                //     color: Color(0xFF344053),
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.w400,
                                //     letterSpacing: 0.37,
                                //   ),
                                // ),
                                SizedBox(height: 10.h),
                                _requestFormWidget(),
                                SizedBox(height: 20.h),
                                // _optionsWidget()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _confirmYourRequestWidgets()
              ],
            );
          },
        ));
  }

  Widget _requestFormWidget() {
    return Form(
      key: requestFormKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          _optionsFromBerlinWidget(),
          SizedBox(
            height: 10.h,
          ),
          DateTimeFormFieldWidget(
            title: translate(LocalizationKeys.arrivalDate)!,
            hintText: translate(LocalizationKeys.arrivalDate),
            onSaved: _arrivalDateSave,
            validator: dateTimeValidator,
            initialValue: minDate,
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
          Visibility(
              visible: !(arrivingDetailsRequestModel.fromBerlin ?? false),
              child: Column(
                children: [
                  AppTextFormField(
                    title: translate(LocalizationKeys.airport)!,
                    requiredTitle: false,
                    hintText: translate(LocalizationKeys.enterAirportName),
                    textInputAction: TextInputAction.next,
                    validator: !(arrivingDetailsRequestModel.fromBerlin ?? true)
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return "${translate(LocalizationKeys.enterAirportName)!}${translate(LocalizationKeys.required)}";
                            }
                            return null;
                          }
                        : (value) {
                            return null;
                          },
                    onSaved: (value) {
                      if (value != null) {
                        arrivingDetailsRequestModel.airportName = value;
                        currentBloc.add(SetArrivingDetailsEvent(
                            arrivingDetailsRequestModel));
                      }
                    },
                  ),
                  SizedBox(height: 8.h),
                  AppTextFormField(
                    title: translate(LocalizationKeys.flightNumber)!,
                    requiredTitle: false,
                    hintText: translate(LocalizationKeys.enterFlightNumber),
                    textInputAction: TextInputAction.next,
                    validator: !(arrivingDetailsRequestModel.fromBerlin ?? true)
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return "${translate(LocalizationKeys.flightNumber)!}${translate(LocalizationKeys.required)}";
                            }
                            return null;
                          }
                        : (value) {
                            return null;
                          },
                    onSaved: (value) {
                      if (value != null) {
                        arrivingDetailsRequestModel.flightNo = value;
                        currentBloc.add(SetArrivingDetailsEvent(
                            arrivingDetailsRequestModel));
                      }
                    },
                  ),
                ],
              )),
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
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                translate(LocalizationKeys.freeToNewUsers)!,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 14,
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
                      groupValue: arrivingDetailsRequestModel.moveService,
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
                      groupValue: arrivingDetailsRequestModel.moveService,
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

  Widget _optionsFromBerlinWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Text(
            translate(LocalizationKeys.willYouBeTravelingFromAnotherCountry)!,
            style: const TextStyle(
              color: Color(0xFF344054),
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
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
                      groupValue: arrivingDetailsRequestModel.fromBerlin,
                      onChanged: (value) {
                        _changeFromBerlinOptionEvent(value!);
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
                      groupValue: arrivingDetailsRequestModel.fromBerlin,
                      onChanged: (value) {
                        _changeFromBerlinOptionEvent(value!);
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

  void _validateFormEvent() {
    currentBloc.add(ValidateFormEvent(requestFormKey));
  }

  void _arrivalDateSave(DateTime? date) {
    if (date != null) {
      _arrivalDate = date;
      arrivingDetailsRequestModel.checkinDate = date.toString();
      currentBloc.add(SetArrivingDetailsEvent(arrivingDetailsRequestModel));
    }
  }

  void _arrivalTimeSave(TimeOfDay? time) {
    if (time != null) {
      _arrivalTime = time;
      arrivingDetailsRequestModel.checkinTime = time.format(context);
      currentBloc.add(SetArrivingDetailsEvent(arrivingDetailsRequestModel));
    }
  }

  void _changeServiceOptionEvent(bool val) {
    // setState(() {
    //   isYesOptionSelected = bool;
    // });
    arrivingDetailsRequestModel.moveService = val;
    currentBloc.add(SetArrivingDetailsEvent(arrivingDetailsRequestModel));
  }

  void _changeFromBerlinOptionEvent(bool val) {
    // setState(() {
    //   isYesOptionSelected = bool;
    // });
    arrivingDetailsRequestModel.fromBerlin = val;
    currentBloc.add(SetArrivingDetailsEvent(arrivingDetailsRequestModel));
  }
}

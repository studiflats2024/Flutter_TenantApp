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
import 'package:vivas/feature/make_request/widget/full_booking.dart';
import 'package:vivas/feature/make_request/widget/send_request_successfully_dialog.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/terms_text_widget/terms_text_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/custom_drop_down_form_filed_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/feedback/feedback_snackbar.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../apis/managers/date_manager.dart';
import '../../../apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import '../../../preferences/preferences_manager.dart';
import '../../widgets/text_field/phone_number_form_filed_widget.dart';

class MakeRequestScreenV2 extends StatelessWidget {
  MakeRequestScreenV2({Key? key}) : super(key: key);
  static const routeName = '/make-request-screen-v2';
  static const argumentRequestUiModel = 'requestUiModel';
  static const argumentApartmentDetailsModel = 'apartmentDetails';

  static Future<void> open(BuildContext context, RequestUiModel requestUiModel,
      ApartmentDetailsApiModelV2 apartmentDetailsApiModelV2) async {
    await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
      argumentRequestUiModel: requestUiModel,
      argumentApartmentDetailsModel: apartmentDetailsApiModelV2,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MakeRequestBloc>(
      create: (context) => MakeRequestBloc(MakeRequestRepository(
          ApartmentRequestsApiManger(dioApiManager, context))),
      child: MakeRequestScreenWithBlocV2(
          requestUiModel(context), apartmentDetails(context)),
    );
  }

  RequestUiModel requestUiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[MakeRequestScreenV2.argumentRequestUiModel] as RequestUiModel;

  ApartmentDetailsApiModelV2 apartmentDetails(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[MakeRequestScreenV2.argumentApartmentDetailsModel]
          as ApartmentDetailsApiModelV2;
}

class MakeRequestScreenWithBlocV2 extends BaseStatefulScreenWidget {
  final RequestUiModel requestUiModel;
  final ApartmentDetailsApiModelV2 apartmentDetailsApiModelV2;

  const MakeRequestScreenWithBlocV2(
      this.requestUiModel, this.apartmentDetailsApiModelV2,
      {super.key});

  @override
  BaseScreenState<MakeRequestScreenWithBlocV2> baseScreenCreateState() {
    return _MakeRequestScreenWithBlocV2();
  }

}

class _MakeRequestScreenWithBlocV2 extends BaseScreenState<MakeRequestScreenWithBlocV2> with AuthValidate {
  late RequestUiModel _requestUiModel;
  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final PhoneController phoneController = PhoneController();
  String? initialValueEmail, initialValuePhone;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late DateTime _startDate = startDateInit;
  TextEditingController textEditingController = TextEditingController();
  var preferencesManager = GetIt.I<PreferencesManager>();
  String email = '', mobile = '';
  late int calculating;

  late int days;

  @override
  void initState() {
    super.initState();
    calculating =
        !DateManager.hasThirtyOneDays(DateTime.now().year, DateTime.now().month)
            ? (31 - (DateTime.now().day ?? 0))
            : (30 - (DateTime.now().day ?? 0));
    days =
        !DateManager.hasThirtyOneDays(DateTime.now().year, DateTime.now().month)
            ? calculating > 0
                ? calculating + 30
                : 30
            : calculating > 0
                ? calculating + 31
                : 31;
    currentBloc.add(Init(widget.apartmentDetailsApiModelV2));
    _requestUiModel = widget.requestUiModel;
    Future.microtask(_setInitialData);
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: Text(translate(LocalizationKeys.completeYourRequest)!),
        centerTitle: true,
      ),
      body: BlocConsumer<MakeRequestBloc, MakeRequestState>(
        listener: (context, state) {
          if (state is MakeRequestLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is MakeRequestErrorState) {
            showFeedbackMessage(
                state.isLocalizationKey
                    ? translate(state.errorMassage)!
                    : state.errorMassage,
                feedbackStyle: FeedbackStyle.toast);
          } else if (state is FormNotValidatedState) {
            autovalidateMode = AutovalidateMode.always;
          } else if (state is FormValidatedState) {
            _sendRequestApiEvent();
          } else if (state is ChangeWhereStay) {
            _requestUiModel = state.requestUiModel;
          } else if (state is SetDataOnRequest) {
            _requestUiModel = state.requestUiModel;
          } else if (state is ChangeNumberOfGuestState) {
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
          // DateAndAgencyCode(
          //     startDateController: _startDateController,
          //     endDateController: _endDateController,
          //     startDateSave: _startDateSave,
          //     endDateSave: _endDateSave,
          //     agencyBrokerCodeSaved: _agencyBrokerCodeSaved,
          //     dateTimeValidator: dateTimeValidator,
          //     maxDateInit: maxDateInit,
          //     initialEndDate: _initialEndDate,
          //     startDateInit: startDateInit),
          //
          // SizedBox(height: 10.h),
          widget.apartmentDetailsApiModelV2.isSelectedFullApartment
              ? FullBooking(
                  numberOfGuest: _requestUiModel.numberOfGuests,
                  mobile: mobile,
                  email: email,
                  currentBloc: currentBloc,
                  requestUiModel: _requestUiModel,
                  apartmentDetailsApiModelV2: widget.apartmentDetailsApiModelV2,
                  guestNAmeSavedSaved: _guestNAmeSavedSaved,
                  guestWaNoSaved: _guestWaNoSaved,
                  guestEmailSavedSaved: _guestEmailSavedSaved,
                  phoneController: phoneController)
              : Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Color(0xffEBEBEB),
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0.w, vertical: 16.h),
                    child:
                        (widget.apartmentDetailsApiModelV2
                                        .countOfSelectedRooms ==
                                    1 &&
                                widget.requestUiModel.numberOfGuests == 1)
                            ? currentBloc.apartmentDetailsApiModelV2
                                        ?.apartmentRooms !=
                                    null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...List.generate(1, (bedIndex) {
                                        var bed = currentBloc
                                            .apartmentDetailsApiModelV2!
                                            .apartmentRooms![currentBloc
                                                .apartmentDetailsApiModelV2!
                                                .indexRoom]
                                            .roomBeds![bedIndex];
                                        if (
                                            widget.apartmentDetailsApiModelV2
                                                    .countOfSelectedRooms ==
                                                1) {
                                          if (widget.apartmentDetailsApiModelV2
                                                  .countOfSelectedRooms ==
                                              1) {
                                            _requestUiModel.roomID = currentBloc
                                                    .apartmentDetailsApiModelV2!
                                                    .apartmentRooms![currentBloc
                                                        .apartmentDetailsApiModelV2!
                                                        .indexRoom]
                                                    .roomId ??
                                                "";
                                          } else {}
                                          _requestUiModel
                                              .roomsId[bed.bedNo ?? 0] = {
                                            "room_ID": currentBloc
                                                    .apartmentDetailsApiModelV2!
                                                    .apartmentRooms![currentBloc
                                                        .apartmentDetailsApiModelV2!
                                                        .indexRoom]
                                                    .roomId ??
                                                '',
                                            "bed_ID": bed.bedId ?? "",
                                            "apartment_ID": currentBloc
                                                    .apartmentDetailsApiModelV2!
                                                    .apartmentId ??
                                                '',
                                            "guest_Name": "",
                                            "guest_WA_No": mobile,
                                            "guest_Email": email
                                          };
                                          _requestUiModel.chooseBed = true;
                                          _requestUiModel.chooseWhereStay =
                                              bed.bedId ?? "";

                                          _requestUiModel.bedIndex =
                                              bed.bedNo ?? 0;
                                          initialValueEmail = email;
                                          initialValuePhone = mobile;
                                          _guestWaNoSaved(bed.bedNo ?? 0,
                                              PhoneNumber.parse(mobile),
                                              myPhone: mobile);
                                          _guestEmailSavedSaved(
                                              bed.bedNo ?? 0, email);
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _generateNameTextField(
                                                  bed.bedNo ?? 0),
                                              _generateMainWaNoTextField(
                                                  bed.bedNo ?? 0,
                                                  bed.bedId ?? "",
                                                  PhoneNumber.parse(mobile)),
                                              _generateEmailTextField(
                                                  bed.bedNo ?? 0,
                                                  bed.bedId ?? "",
                                                  email),
                                            ],
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                    ],
                                  )
                                : Container()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: currentBloc
                                        .apartmentDetailsApiModelV2
                                        ?.apartmentRooms!
                                        .length ??
                                    0,
                                itemBuilder: (context, roomIndex) {
                                  if (currentBloc
                                          .apartmentDetailsApiModelV2!
                                          .apartmentRooms![roomIndex]
                                          .isSelected ||
                                      currentBloc
                                          .apartmentDetailsApiModelV2!
                                          .apartmentRooms![roomIndex]
                                          .haveBedsSelected) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentBloc
                                                  .apartmentDetailsApiModelV2!
                                                  .isStudio
                                              ? translate(LocalizationKeys
                                                      .studioBeds) ??
                                                  ""
                                              : "${currentBloc.apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].roomType} ${translate(LocalizationKeys.room)}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 10.h),
                                        ...List.generate(
                                            currentBloc
                                                .apartmentDetailsApiModelV2!
                                                .apartmentRooms![roomIndex]
                                                .roomBeds!
                                                .length, (bedIndex) {
                                          var bed = currentBloc
                                              .apartmentDetailsApiModelV2!
                                              .apartmentRooms![roomIndex]
                                              .roomBeds![bedIndex];
                                          if (bed.isSelected) {
                                            if (currentBloc
                                                    .apartmentDetailsApiModelV2!
                                                    .countOfSelectedBeds ==
                                                1) {
                                              _requestUiModel.bedID =
                                                  bed.bedId ?? "";
                                              _requestUiModel
                                                  .roomsId[bed.bedNo ?? 0] = {
                                                "room_ID": currentBloc
                                                        .apartmentDetailsApiModelV2!
                                                        .apartmentRooms![
                                                            roomIndex]
                                                        .roomId ??
                                                    '',
                                                "bed_ID": bed.bedId ?? "",
                                                "apartment_ID": currentBloc
                                                        .apartmentDetailsApiModelV2!
                                                        .apartmentId ??
                                                    '',
                                                "guest_Name": "",
                                                "guest_WA_No": mobile,
                                                "guest_Email": email
                                              };
                                              _requestUiModel.chooseBed = true;
                                              _requestUiModel.chooseWhereStay =
                                                  bed.bedId ?? "";

                                              _requestUiModel.bedIndex =
                                                  bed.bedNo ?? 0;
                                              initialValueEmail = email;
                                              initialValuePhone = mobile;
                                              _guestWaNoSaved(bed.bedNo ?? 0,
                                                  PhoneNumber.parse(mobile),
                                                  myPhone: mobile);
                                              _guestEmailSavedSaved(
                                                  bed.bedNo ?? 0, email);
                                            } else {
                                              _requestUiModel
                                                  .roomsId[bed.bedNo ?? 0] = {
                                                "room_ID": currentBloc
                                                        .apartmentDetailsApiModelV2!
                                                        .apartmentRooms![
                                                            roomIndex]
                                                        .roomId ??
                                                    '',
                                                "bed_ID": bed.bedId ?? "",
                                                "apartment_ID": currentBloc
                                                        .apartmentDetailsApiModelV2!
                                                        .apartmentId ??
                                                    '',
                                                "guest_Name": "",
                                                "guest_WA_No": "",
                                                "guest_Email": ""
                                              };
                                            }

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    height: 1.h,
                                                    color: AppColors.divider),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0.h),
                                                  child: Text(
                                                    "${translate(LocalizationKeys.bed)!} ${(bed.bedNo)}",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                currentBloc.apartmentDetailsApiModelV2
                                                            ?.countOfSelectedBeds !=
                                                        1
                                                    ? Visibility(
                                                        visible: (_requestUiModel
                                                                        .chooseWhereStay ==
                                                                    "" &&
                                                                (!(_requestUiModel
                                                                        .chooseBed ??
                                                                    false))) ||
                                                            (_requestUiModel
                                                                        .chooseWhereStay ==
                                                                    bed.bedId &&
                                                                (_requestUiModel
                                                                        .chooseBed ??
                                                                    false)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Do you plan to stay here?",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Radio(
                                                                      value:
                                                                          true,
                                                                      groupValue:
                                                                          _requestUiModel
                                                                              .chooseBed,
                                                                      activeColor:
                                                                          AppColors
                                                                              .colorPrimary,
                                                                      onChanged:
                                                                          (value) async {
                                                                        if (value ==
                                                                            true) {
                                                                          _requestUiModel.chooseBed =
                                                                              value;
                                                                          _requestUiModel.chooseWhereStay =
                                                                              bed.bedId ?? "";

                                                                          _requestUiModel.bedIndex =
                                                                              bed.bedNo ?? 0;
                                                                          initialValueEmail =
                                                                              email;
                                                                          initialValuePhone =
                                                                              mobile;
                                                                          setState(
                                                                              () {});
                                                                          _guestWaNoSaved(
                                                                              bed.bedNo ?? 0,
                                                                              PhoneNumber.parse(mobile),
                                                                              myPhone: mobile);
                                                                          _guestEmailSavedSaved(
                                                                              bed.bedNo ?? 0,
                                                                              email);
                                                                        }
                                                                      },
                                                                    ),
                                                                    Transform
                                                                        .translate(
                                                                      offset: Offset(
                                                                          -8.w,
                                                                          0),
                                                                      // Adjust the offset value as needed
                                                                      child:
                                                                          Text(
                                                                        translate(LocalizationKeys.yes) ??
                                                                            "",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Radio(
                                                                      value:
                                                                          false,
                                                                      groupValue:
                                                                          _requestUiModel
                                                                              .chooseBed,
                                                                      activeColor:
                                                                          AppColors
                                                                              .colorPrimary,
                                                                      onChanged:
                                                                          (value) {
                                                                        if (value ==
                                                                            false) {
                                                                          _requestUiModel.chooseBed =
                                                                              value;
                                                                          _requestUiModel.chooseWhereStay =
                                                                              "";
                                                                          _guestWaNoSaved(
                                                                              bed.bedNo ?? 0,
                                                                              null,
                                                                              myPhone: "");
                                                                          _guestEmailSavedSaved(
                                                                              bed.bedNo ?? 0,
                                                                              "");
                                                                          initialValueEmail =
                                                                              null;
                                                                          initialValuePhone =
                                                                              null;
                                                                          _requestUiModel.bedIndex =
                                                                              null;
                                                                          setState(
                                                                              () {});
                                                                        } else {}
                                                                      },
                                                                    ),
                                                                    Transform
                                                                        .translate(
                                                                      offset: Offset(
                                                                          -8.w,
                                                                          0),
                                                                      // Adjust the offset value as needed
                                                                      child:
                                                                          Text(
                                                                        translate(LocalizationKeys.no) ??
                                                                            "",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                                _generateNameTextField(
                                                    bed.bedNo ?? 0),
                                                if (currentBloc
                                                        .apartmentDetailsApiModelV2
                                                        ?.countOfSelectedBeds ==
                                                    1) ...[
                                                  _generateMainWaNoTextField(
                                                      bed.bedNo ?? 0,
                                                      bed.bedId ?? "",
                                                      PhoneNumber.parse(mobile))
                                                ] else if (_requestUiModel
                                                        .chooseWhereStay ==
                                                    bed.bedId) ...[
                                                  _generateMainWaNoTextField(
                                                      bed.bedNo ?? 0,
                                                      bed.bedId ?? "",
                                                      PhoneNumber.parse(
                                                          initialValuePhone ??
                                                              mobile))
                                                ] else ...[
                                                  _generateWaNoTextField(
                                                      bed.bedNo ?? 0,
                                                      bed.bedId ?? "",
                                                      mobile != ''
                                                          ? PhoneNumber.parse(
                                                              mobile)
                                                          : null)
                                                ],
                                                currentBloc.apartmentDetailsApiModelV2
                                                            ?.countOfSelectedBeds ==
                                                        1
                                                    ? _generateMainEmailTextField(
                                                        bed.bedNo ?? 0,
                                                        bed.bedId ?? "",
                                                )
                                                    : _requestUiModel
                                                                .chooseWhereStay ==
                                                            bed.bedId
                                                        ? _generateMainEmailTextField(
                                                            bed.bedNo ?? 0,
                                                            bed.bedId ?? "")
                                                        : _generateEmailTextField(
                                                            bed.bedNo ?? 0,
                                                            bed.bedId ?? "",
                                                            null),
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        })
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                  ),
                ),
          SizedBox(height: 10.h),
          Card(
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: AppColors.cardColor,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(LocalizationKeys.personalInformation) ?? "",
                    style: textTheme.labelLarge?.copyWith(
                      fontSize: 18.spMin,
                      color: AppColors.loginTitleText,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(height: 1.h, color: AppColors.divider),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomDropDownFormFiledWidget(
                    title: translate(LocalizationKeys.selectYourRole)!,
                    hintText: translate(LocalizationKeys.selectYourRole)!,
                    items: RoleUiModel.roles.map((role) {
                      return CustomDropDownItem(
                          key: role.key, value: translate(role.value)!);
                    }).toList(),
                    validator: customDropDownItemValidator,
                    // onSaved: _roleSaved,
                    onChanged: _roleSaved,
                  ),
                  SizedBox(height: 10.h),
                  AppTextFormField(
                    title: _requestUiModel.role != RoleApiKey.student &&
                            _requestUiModel.role != null
                        ? translate(LocalizationKeys.workplaceName) ?? ""
                        : translate(LocalizationKeys.universityName)!,
                    hintText: _requestUiModel.role != RoleApiKey.student &&
                            _requestUiModel.role != null
                        ? translate(LocalizationKeys.workplaceNameHint) ?? ""
                        : translate(LocalizationKeys.universityNameHint),
                    onSaved: _universityName,
                    validator: textValidator,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
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
                    title: translate(LocalizationKeys.promoCode)!,
                    requiredTitle: false,
                    hintText: translate(LocalizationKeys.eg100),
                    onSaved: _promoCode,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  setRoomDataOnRequest(int roomBed, var bed, String aptId) {
    _requestUiModel.roomsId[roomBed] = {
      "room_ID": bed.roomId ?? '',
      "bed_ID": bed.bedId ?? "",
      "apartment_ID": aptId,
      "guest_Name": "",
      "guest_WA_No": "",
      "guest_Email": ""
    };
  }

  Widget _confirmYourRequestWidgets() {
    return SubmitButtonWidget(
      title: translate(LocalizationKeys.confirmYourRequest)!,
      onClicked: _confirmClicked,
    );
  }

  Widget _generateNameTextField(int index) {
    return Column(
      children: [
        AppTextFormField(
          hintText: "${translate(LocalizationKeys.enterNameOfGuest)!} ",
          title:
              "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.name)!}",
          titleStyle: textTheme.titleMedium?.copyWith(
              fontSize: FontSize.fontSize12,
              color: AppColors.appFormFieldTitle,
              fontWeight: FontWeight.w600),
          onSaved: (value) => _guestNAmeSavedSaved(index, value!),
          validator: textValidator,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 10.h)
      ],
    );
  }

  Widget _generateWaNoTextField(int index, bedId, PhoneNumber? phoneNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhoneNumberFormFiledWidget(
          title:
              "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.whatsAppNumber)!}",
          hintText: bedId == _requestUiModel.chooseWhereStay
              ? phoneNumber?.nsn ??
                  initialValuePhone?.replaceFirst(
                      phoneNumber?.countryCode ??
                          initialValuePhone?.substring(0, 2) ??
                          "",
                      "") ??
                  "ex.1234567890"
              : "ex.1234567890",
          initialValue: bedId == _requestUiModel.chooseWhereStay &&
                  phoneNumber != null
              ? PhoneNumber(isoCode: phoneNumber.isoCode, nsn: phoneNumber.nsn)
              : null,
          enable: bedId != _requestUiModel.chooseWhereStay,
          autovalidateMode: autovalidateMode,
          onSaved: (value) => _guestWaNoSaved(index, value),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _generateMainWaNoTextField(int index, bedId, PhoneNumber phoneNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.whatsAppNumber)!}"
                .concatenateAsterisk,
            style: textTheme.titleMedium?.copyWith(
                fontSize: FontSize.fontSize12,
                color: AppColors.appFormFieldTitle,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        PhoneFormField(
          autovalidateMode: autovalidateMode,
          autofillHints: const [AutofillHints.telephoneNumber],
          countrySelectorNavigator:
              const CountrySelectorNavigator.draggableBottomSheet(),
          initialValue: PhoneNumber.parse(phoneController.value.international),
          decoration: InputDecoration(
            hintText: "ex.1234567890",
            fillColor: AppColors.appFormFieldFill,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            hintStyle: textTheme.labelMedium?.copyWith(
              color: AppColors.formFieldHintText,
              fontWeight: FontWeight.w400,
              fontSize: 16.spMin,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.enabledAppFormFieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.formFieldFocusIBorder,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          enabled: bedId != _requestUiModel.chooseWhereStay,
          countryButtonStyle: CountryButtonStyle(
              textStyle: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.formFieldText),
              flagSize: 20.r,
              showFlag: true,
              showDropdownIcon: false),
          cursorColor: Theme.of(context).colorScheme.primary,
          onSaved: (value) => _guestWaNoSaved(index, value),
          textInputAction: TextInputAction.done,
          isCountrySelectionEnabled: true,
          isCountryButtonPersistent: true,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.formFieldText),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  PhoneNumberInputValidator? _getValidator(BuildContext context) {
    List<PhoneNumberInputValidator> validators = [];

    validators.add(PhoneValidator.validMobile(
        //allowEmpty: allowEmpty,
        context,
        errorText: translate(LocalizationKeys.phoneNumberInvalid)));
    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }

  Widget _generateEmailTextField(int index, bedId, String? initValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFormField(
          hintText: bedId == _requestUiModel.chooseWhereStay
              ? initialValueEmail ??
                  "${translate(LocalizationKeys.enterEmailOfGuest)!} "
              : "${translate(LocalizationKeys.enterEmailOfGuest)!} ",
          enable: bedId != _requestUiModel.chooseWhereStay,
          title:
              "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.email)!}",
          titleStyle: textTheme.titleMedium?.copyWith(
              fontSize: FontSize.fontSize12,
              color: AppColors.appFormFieldTitle,
              fontWeight: FontWeight.w600),
          onSaved: (value) => _guestEmailSavedSaved(index, value!),
          validator:
              bedId == _requestUiModel.chooseWhereStay ? null : emailValidator,
          initialValue: initValue,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 10.h),
        Text(translate(LocalizationKeys.bookingWillSentToEmail) ?? "",
            style: textTheme.bodyMedium?.copyWith(
              fontSize: FontSize.fontSize12,
              color: AppColors.colorPrimary,
            )),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _generateMainEmailTextField(
    int index,
    bedId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.email)!}"
                .concatenateAsterisk,
            style: textTheme.titleMedium?.copyWith(
                fontSize: FontSize.fontSize12,
                color: AppColors.appFormFieldTitle,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextFormField(
          readOnly: bedId == _requestUiModel.chooseWhereStay,
          enabled: bedId != _requestUiModel.chooseWhereStay,
          onSaved: (value) => _guestEmailSavedSaved(index, value!),
          initialValue: email,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          validator: emailValidator,
          decoration: InputDecoration(
            hintText: "${translate(LocalizationKeys.enterEmailOfGuest)!} ",
            fillColor: AppColors.appFormFieldFill,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            hintStyle: textTheme.labelMedium?.copyWith(
              color: AppColors.formFieldHintText,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.enabledAppFormFieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.formFieldFocusIBorder,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          translate(LocalizationKeys.bookingWillSentToEmail) ?? "",
          style: textTheme.bodySmall?.copyWith(
            fontSize: FontSize.fontSize12,
            color: AppColors.colorPrimary,
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  MakeRequestBloc get currentBloc => BlocProvider.of<MakeRequestBloc>(context);

  void _confirmClicked() {
    print("endDate${_requestUiModel.endDate}");
    if (_requestUiModel.numberOfGuests == 1) {
      currentBloc.add(ValidateFormEvent(requestFormKey));
    } else if ((_requestUiModel.chooseBed ?? false)) {
      currentBloc.add(ValidateFormEvent(requestFormKey));
    } else {
      showSnackBarMassage("Please choose where will you Stay", context);
    }
  }

  void _sendRequestApiEvent() {
    currentBloc.add(SendRequestApiEvent(_requestUiModel));
  }

  get startDateInit {
    return DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  late final maxDateInit = _startDate.add(const Duration(days: 365 * 5));

  void _setInitialData() async {
    mobile = await preferencesManager.getMobileNumber() ?? "";
    phoneController.value = PhoneNumber.parse(mobile);
    email = await preferencesManager.getEmail() ?? "";
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
    DateTime endDate = _startDate.add(Duration(days: days));
    return DateTime(endDate.year, endDate.month, 0);
  }

  void _roleSaved(CustomDropDownItem? value) {
    _requestUiModel.role = value?.key;
  }

  void _agencyBrokerCodeSaved(String? value) {
    _requestUiModel.brokerCode = value;
  }

  void _purposeOfComingToGermanySaved(String? value) {
    _requestUiModel.purposeOfComingToGermany = value;
  }

  void _universityName(String? value) {
    _requestUiModel.universityName = value;
  }

  void _promoCode(String? value) {
    _requestUiModel.promoCode = value;
  }

  void _guestNAmeSavedSaved(int index, String value) {
    _requestUiModel.roomsId[index]!["guest_Name"] = value;
  }

  void _guestWaNoSaved(int roomIndex, PhoneNumber? value, {String? myPhone}) {
    if (_requestUiModel.bedIndex == roomIndex) {
      _requestUiModel
          .roomsId[roomIndex]!["guest_WA_No"] = initialValuePhone?.replaceFirst(
              value?.countryCode ?? initialValuePhone?.substring(0, 2) ?? "",
              "") ??
          "";
    } else {
      print("value?.countryCode : ${value?.countryCode}");
      _requestUiModel.roomsId[roomIndex]!["guest_WA_No"] =
          myPhone?.replaceFirst(
                  value?.countryCode ?? myPhone.substring(0, 2), "") ??
              value?.international.substring(1) ??
              "";
    }
  }

  void _guestEmailSavedSaved(int roomIndex, String value) {
    if (_requestUiModel.bedIndex == roomIndex) {
      _requestUiModel.roomsId[roomIndex]!["guest_Email"] =
          initialValueEmail ?? "";
    } else {
      _requestUiModel.roomsId[roomIndex]!["guest_Email"] = value;
    }
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

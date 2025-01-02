import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/make_request/bloc/make_request_bloc.dart';
import 'package:vivas/feature/make_request/bloc/make_request_repository.dart';
import 'package:vivas/feature/make_request/model/request_ui_model.dart';
import 'package:vivas/feature/make_request/screen/make_request_screen_v2.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/res/app_icons.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../res/app_colors.dart';

class ApartmentRequestView extends StatelessWidget {
  ApartmentRequestView({Key? key}) : super(key: key);
  static const routeName = '/studio-request-screen';
  static const argumentRequestUiModel = 'requestUiModel';
  static const argumentApartmentDetailsModel = 'apartmentDetails';
  static const argumentFunctionBack = 'function-call-back';

  static Future<void> open(
      BuildContext context,
      RequestUiModel requestUiModel,
      ApartmentDetailsApiModelV2 apartmentDetailsApiModelV2,
      Function() callBack) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      argumentRequestUiModel: requestUiModel,
      argumentApartmentDetailsModel: apartmentDetailsApiModelV2,
      argumentFunctionBack: callBack,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MakeRequestBloc>(
      create: (context) => MakeRequestBloc(
        MakeRequestRepository(
          ApartmentRequestsApiManger(dioApiManager, context),
        ),
      ),
      child: StudioRequestScreenWithBloc(requestUiModel(context),
          apartmentDetails(context), callBack(context)),
    );
  }

  RequestUiModel requestUiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[ApartmentRequestView.argumentRequestUiModel]
          as RequestUiModel;

  Function() callBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[ApartmentRequestView.argumentFunctionBack] as Function();

  ApartmentDetailsApiModelV2 apartmentDetails(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[ApartmentRequestView.argumentApartmentDetailsModel]
          as ApartmentDetailsApiModelV2;
}

class StudioRequestScreenWithBloc extends BaseStatefulScreenWidget {
  final RequestUiModel requestUiModel;
  final ApartmentDetailsApiModelV2 apartmentDetails;
  final Function() callBack;

  const StudioRequestScreenWithBloc(
      this.requestUiModel, this.apartmentDetails, this.callBack,
      {super.key});

  @override
  BaseScreenState<StudioRequestScreenWithBloc> baseScreenCreateState() {
    return _MakeRequestScreenWithBloc();
  }
}

class _MakeRequestScreenWithBloc
    extends BaseScreenState<StudioRequestScreenWithBloc> with AuthValidate {
  late final RequestUiModel _requestUiModel;
  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  int numberOfGuestsTextFelid = 1;
  int? invoicesType = 0;

  @override
  void initState() {
    numberOfGuestsTextFelid = widget.requestUiModel.numberOfGuests ?? 1;
    currentBloc.add(Init(widget.apartmentDetails));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          translate(LocalizationKeys.select)!,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<MakeRequestBloc, MakeRequestState>(
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
              padding: EdgeInsets.symmetric(horizontal: 14.w),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: (currentBloc
                      .apartmentDetailsApiModelV2?.apartmentRentByApartment ??
                  true) &&
              !(widget.apartmentDetails.haveUnAvailableBedsByDateRange(
                  DateTimeRange(
                      start: widget.requestUiModel.startDate!,
                      end: widget.requestUiModel.endDate!),
                  DateTimeRange(
                      start: widget.apartmentDetails.availableFrom!,
                      end: widget.apartmentDetails.availableTo!))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translate(LocalizationKeys.full)} ${widget.apartmentDetails.apartmentType}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Transform.scale(
                    scale: 1.15,
                    child: Checkbox(
                      value: currentBloc.apartmentDetailsApiModelV2
                              ?.isSelectedFullApartment ??
                          false,
                      onChanged: (onChanged) {
                        currentBloc.add(const OnSelectedFull());
                      },
                      side: const BorderSide(
                          color: AppColors.colorPrimary, width: 2),
                      activeColor: AppColors.colorPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  )
                ],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${translate(LocalizationKeys.price)} : ',
                      style: const TextStyle(
                        color: AppColors.formFieldText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${widget.apartmentDetails.apartmentPrice.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        color: AppColors.colorPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1.h,
                margin: EdgeInsets.symmetric(
                  vertical: 10.h,
                ),
                decoration: const BoxDecoration(color: AppColors.divider),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              bool roomAvailability = !widget
                  .apartmentDetails.apartmentRooms![index]
                  .haveUnAvailableBedsByRangeDate(
                      DateTimeRange(
                          start: widget.requestUiModel.startDate!,
                          end: widget.requestUiModel.endDate!),
                      DateTimeRange(
                          start: widget.apartmentDetails.availableFrom!,
                          end: widget.apartmentDetails.availableTo!));
              int countOfAvailableBed = widget
                  .apartmentDetails.apartmentRooms![index]
                  .countOfAvailableBedByDateRange(
                      DateTimeRange(
                          start: widget.requestUiModel.startDate!,
                          end: widget.requestUiModel.endDate!),
                      DateTimeRange(
                          start: widget.apartmentDetails.availableFrom!,
                          end: widget.apartmentDetails.availableTo!));
              return Visibility(
                  visible: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.apartmentDetails.isStudio
                                ? translate(LocalizationKeys.studioBeds) ?? ""
                                : "${widget.apartmentDetails.apartmentRooms![index].roomType ?? ""} ${translate(LocalizationKeys.room)} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Visibility(
                              visible: roomAvailability,
                              child: Transform.scale(
                                scale: 1.15,
                                child: Checkbox(
                                  value: (currentBloc.apartmentDetailsApiModelV2
                                          ?.apartmentRooms![index].isSelected ??
                                      false),
                                  onChanged: (onChanged) {
                                    if (onChanged ?? false) {
                                      if (widget.requestUiModel.numberOfGuests >
                                              (currentBloc
                                                      .apartmentDetailsApiModelV2
                                                      ?.countOfSelectedBeds ??
                                                  0.0) &&
                                          roomAvailability) {
                                        if ((countOfAvailableBed -
                                                (currentBloc
                                                        .apartmentDetailsApiModelV2
                                                        ?.apartmentRooms![index]
                                                        .countOfSelectedBed ??
                                                    0)) <=
                                            (widget.requestUiModel
                                                    .numberOfGuests -
                                                (currentBloc
                                                        .apartmentDetailsApiModelV2
                                                        ?.countOfSelectedBeds ??
                                                    0.0))) {
                                          currentBloc.add(
                                              OnSelectedRoom(roomIndex: index));
                                        } else if (widget.requestUiModel
                                                    .numberOfGuests ==
                                                1 &&
                                            roomAvailability) {
                                          currentBloc.add(
                                              OnSelectedRoom(roomIndex: index));
                                        } else {
                                          if (widget.requestUiModel
                                                  .numberOfGuests ==
                                              1) {
                                            if (currentBloc
                                                    .apartmentDetailsApiModelV2
                                                    ?.apartmentRentByApartment ??
                                                false) {
                                              showFeedbackMessage(
                                                  "Can't Select Room cause You choose ${translate(LocalizationKeys.room)} you can selected full option if you need");
                                            } else {
                                              showFeedbackMessage(
                                                  "Can't Select Room cause You choose ${translate(LocalizationKeys.room)} ");
                                            }
                                          } else {
                                            showFeedbackMessage(
                                                "Can't Select Room cause You choose ${currentBloc.apartmentDetailsApiModelV2?.countOfSelectedBeds} ${translate(LocalizationKeys.beds)} to ${widget.requestUiModel.numberOfGuests} ${translate(LocalizationKeys.guest)}");
                                          }
                                        }
                                      } else {
                                        if (widget.requestUiModel
                                                .numberOfGuests ==
                                            1) {
                                          if (currentBloc
                                                  .apartmentDetailsApiModelV2
                                                  ?.apartmentRentByApartment ??
                                              false) {
                                            showFeedbackMessage(
                                                "Can't Select Room cause You choose ${translate(LocalizationKeys.room)} select full option if you need");
                                          } else {
                                            showFeedbackMessage(
                                                "Can't Select Room cause You choose ${translate(LocalizationKeys.room)} ");
                                          }
                                        } else {
                                          showFeedbackMessage(
                                              "Can't Select Room cause You choose ${currentBloc.apartmentDetailsApiModelV2?.countOfSelectedBeds} ${translate(LocalizationKeys.beds)} to ${widget.requestUiModel.numberOfGuests} ${translate(LocalizationKeys.guest)}");
                                        }
                                      }
                                    } else {
                                      currentBloc.add(
                                          OnSelectedRoom(roomIndex: index));
                                    }
                                  },
                                  side: const BorderSide(
                                      color: AppColors.colorPrimary, width: 2),
                                  activeColor: AppColors.colorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              ))
                        ],
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: widget.apartmentDetails.isStudio
                                  ? translate(LocalizationKeys.studioPrice) ??
                                      ""
                                  : '${translate(LocalizationKeys.roomPrice)} : ',
                              style: const TextStyle(
                                color: AppColors.formFieldText,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${widget.apartmentDetails.apartmentRooms![index].roomPrice?.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                color: AppColors.colorPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${translate(LocalizationKeys.bedPrice)} : ',
                              style: TextStyle(
                                color: AppColors.formFieldText,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${widget.apartmentDetails.apartmentRooms?[index].bedPrice?.toStringAsFixed(2)} €',
                              style: TextStyle(
                                color: AppColors.colorPrimary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, bedIndex) {
                            bool availability = widget.apartmentDetails
                                .apartmentRooms![index].roomBeds![bedIndex]
                                .bedAvailableByDateRange(
                                    DateTimeRange(
                                        start: widget.requestUiModel.startDate!,
                                        end: widget.requestUiModel.endDate!),
                                    DateTimeRange(
                                        start: widget
                                            .apartmentDetails.availableFrom!,
                                        end: widget
                                            .apartmentDetails.availableTo!));
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "${translate(LocalizationKeys.bed)} ${widget.apartmentDetails.apartmentRooms![index].roomBeds![bedIndex].bedNo ?? ""}",
                                      style: TextStyle(
                                        color: AppColors.formFieldText,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Container(
                                      width: availability ? 60.w : 75.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.0.w),
                                      decoration: BoxDecoration(
                                        color: availability
                                            ? const Color(0xffC2FFC4)
                                                .withOpacity(0.5)
                                            : const Color(0xFFFFC5C2)
                                                .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          availability
                                              ? "Available"
                                              : "Unavailable",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color: availability
                                                  ? Color(0xff027A48)
                                                  : Color(0xffB3261E)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                    visible: availability,
                                    child: Transform.scale(
                                      scale: 1.15.h,
                                      child: Checkbox(
                                        value: (currentBloc
                                                .apartmentDetailsApiModelV2
                                                ?.apartmentRooms?[index]
                                                .roomBeds?[bedIndex]
                                                .isSelected ??
                                            false),
                                        onChanged: (onChanged) {
                                          if (onChanged ?? false) {
                                            if (widget.requestUiModel
                                                    .numberOfGuests >
                                                (currentBloc
                                                        .apartmentDetailsApiModelV2
                                                        ?.countOfSelectedBeds ??
                                                    0.0)) {
                                              currentBloc.add(OnSelectedBed(
                                                  bedIndex: bedIndex,
                                                  roomIndex: index,
                                                  numberOfGuest: widget
                                                      .requestUiModel
                                                      .numberOfGuests));
                                            } else {
                                              showFeedbackMessage(
                                                  "You choose ${currentBloc.apartmentDetailsApiModelV2?.countOfSelectedBeds} ${translate(LocalizationKeys.beds)} to ${widget.requestUiModel.numberOfGuests} ${translate(LocalizationKeys.guest)}");
                                            }
                                          } else {
                                            currentBloc.add(OnSelectedBed(
                                                bedIndex: bedIndex,
                                                roomIndex: index,
                                                numberOfGuest: widget
                                                    .requestUiModel
                                                    .numberOfGuests));
                                          }
                                        },
                                        side: const BorderSide(
                                            color: AppColors.colorPrimary,
                                            width: 2),
                                        activeColor: AppColors.colorPrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ))
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 20.w,
                            );
                          },
                          itemCount: widget.apartmentDetails
                                      .apartmentRooms![index].roomBeds !=
                                  null
                              ? widget.apartmentDetails.apartmentRooms![index]
                                  .roomBeds!.length
                              : 0),
                      Container(
                        height: 1.h,
                        margin: EdgeInsets.symmetric(
                          vertical: 10.h,
                        ),
                        decoration:
                            const BoxDecoration(color: AppColors.divider),
                      )
                    ],
                  ));
            },
            itemCount: widget.apartmentDetails.apartmentRooms != null
                ? widget.apartmentDetails.apartmentRooms!.length
                : 0),
        SizedBox(
          height: 10.h,
        ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Text(
              translate(LocalizationKeys.orderSummary)!,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            currentBloc.apartmentDetailsApiModelV2?.isSelectedFullApartment ??
                    false
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${translate(LocalizationKeys.full)} ${currentBloc.apartmentDetailsApiModelV2!.apartmentType}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        Text(
                          "${currentBloc.apartmentDetailsApiModelV2!.apartmentPrice} €",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: currentBloc.apartmentDetailsApiModelV2
                            ?.apartmentRooms?.length ??
                        0,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, roomIndex) {
                      return currentBloc.apartmentDetailsApiModelV2!
                                  .apartmentRooms![roomIndex].isSelected ||
                              currentBloc.apartmentDetailsApiModelV2!
                                  .apartmentRooms![roomIndex].haveBedsSelected
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 10.0.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.apartmentDetails.isStudio
                                            ? translate(LocalizationKeys
                                                    .studioBeds) ??
                                                ""
                                            : "${currentBloc.apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].roomType} Room",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                      currentBloc
                                                  .apartmentDetailsApiModelV2!
                                                  .apartmentRooms![roomIndex]
                                                  .bedsNo ==
                                              1
                                          ? Text(
                                              "${currentBloc.apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].totalBedsSelected} €",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                currentBloc
                                            .apartmentDetailsApiModelV2!
                                            .apartmentRooms![roomIndex]
                                            .bedsNo ==
                                        1
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0.h),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: currentBloc
                                                    .apartmentDetailsApiModelV2!
                                                    .apartmentRooms![roomIndex]
                                                    .roomBeds
                                                    ?.length ??
                                                0,
                                            itemBuilder: (context, bedIndex) {
                                              return currentBloc
                                                      .apartmentDetailsApiModelV2!
                                                      .apartmentRooms![
                                                          roomIndex]
                                                      .roomBeds![bedIndex]
                                                      .isSelected
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Bed ${currentBloc.apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].roomBeds![bedIndex].bedNo}",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18),
                                                        ),
                                                        Text(
                                                          "${currentBloc.apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].bedPrice} €",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 18),
                                                        ),
                                                      ],
                                                    )
                                                  : Container();
                                            }),
                                      ),
                              ],
                            )
                          : Container();
                    }),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${translate(LocalizationKeys.subtotal)} ',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    "${currentBloc.apartmentDetailsApiModelV2 == null ? 0.toStringAsFixed(2) : currentBloc.apartmentDetailsApiModelV2!.subTotalBedsSelected.toStringAsFixed(2)} €",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${translate(LocalizationKeys.securityDeposit2)} ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '${translate(LocalizationKeys.refundable)}',
                          style: const TextStyle(
                            color: AppColors.formFieldHintText,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${currentBloc.apartmentDetailsApiModelV2 == null ? 0.toStringAsFixed(2) : currentBloc.apartmentDetailsApiModelV2!.securityDepositBedsSelectedTotal.toStringAsFixed(2)} €",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${translate(LocalizationKeys.serviceFee)}  ',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    "${currentBloc.apartmentDetailsApiModelV2 == null ? 0.toStringAsFixed(2) : currentBloc.apartmentDetailsApiModelV2!.serviceBedsSelectedTotal.toStringAsFixed(2)} €",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    "${currentBloc.apartmentDetailsApiModelV2 == null ? 0.toStringAsFixed(2) : currentBloc.apartmentDetailsApiModelV2!.totalOrder.toStringAsFixed(2)} €",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.colorPrimary),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget itemRadio(title, value, groupValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          translate(title)!,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
        ),
        Radio(
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              setState(() {
                invoicesType = value;
              });
            }),
      ],
    );
  }

  Widget _confirmYourRequestWidgets() {
    return SubmitButtonWidget(
      title: translate(LocalizationKeys.requestApartment)!,
      onClicked: _confirmClicked,
      // fontSize: 14,
      // padding: EdgeInsets.symmetric(horizontal: 2.w),
      // withoutShape: true,
    );
  }

  MakeRequestBloc get currentBloc => BlocProvider.of<MakeRequestBloc>(context);

  void _confirmClicked() async {
    if ((currentBloc.apartmentDetailsApiModelV2!.isSelectedFullApartment ||
        (widget.requestUiModel.numberOfGuests == 1 ||
            currentBloc.apartmentDetailsApiModelV2!.countOfSelectedBeds ==
                widget.requestUiModel.numberOfGuests))) {
      bool nextStep = await showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          )),
          context: context,
          builder: (ctx) {
            return Container(
              height: 250.h,
              width: 400.w,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.confirmRequestApartment,
                      width: 80.w,
                      height: 80.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${translate(LocalizationKeys.requestApartment)}",
                      style: const TextStyle(
                          color: AppColors.formFieldText,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    const Text(
                      "Are you sure you want to request?",
                      style: TextStyle(
                          color: AppColors.formFieldHintText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0.w, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(ctx).pop(false);
                            },
                            child: Container(
                              width: 160.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.divider),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                    "${translate(LocalizationKeys.cancel)}"),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(ctx).pop(true);
                            },
                            child: Container(
                              width: 160.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  color: AppColors.colorPrimary,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Center(
                                child: Text(
                                  "Request",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
      if (nextStep) {
        MakeRequestScreenV2.open(context, widget.requestUiModel,
                currentBloc.apartmentDetailsApiModelV2!)
            .then((value) => widget.callBack());
      }
      // currentBloc.add(ValidateFormEvent(requestFormKey));
    } else {
      showFeedbackMessage(
          "you have  ${widget.requestUiModel.numberOfGuests - currentBloc.apartmentDetailsApiModelV2!.countOfSelectedBeds} ${translate(LocalizationKeys.guest)} not have ${translate(LocalizationKeys.bed)}  \n please select beds for Guests");
    }
  }
}

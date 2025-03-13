import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/feature/make_request/bloc/make_request_repository.dart';
import 'package:vivas/feature/make_request/model/request_ui_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

part 'make_request_event.dart';

part 'make_request_state.dart';

class MakeRequestBloc extends Bloc<MakeRequestEvent, MakeRequestState> {
  final BaseMakeRequestRepository makeRequestRepository;
  ApartmentDetailsApiModelV2? apartmentDetailsApiModelV2;
  bool isMultiSelectedBeds = false;
  bool isSelectedMultiRooms = false;

  double subTotal = 0.0;
  double securityDeposit = 0.0;
  double serviceFee = 0.0;

  MakeRequestBloc(
    this.makeRequestRepository,
  ) : super(MakeRequestInitial()) {
    on<Init>(init);
    on<ValidateFormEvent>(_validateFormEvent);
    on<SendRequestApiEvent>(_sendRequestApiEvent);
    on<OnSelectedFull>(selectedFull);
    on<OnSelectedRoom>(selectedMultiRooms);
    on<OnSelectedBed>(selectedMultiBeds);
    on<ChangeNumberOfGuestEvent>(_changeNumberOfGuestEvent);
    on<ChangeStartDateEvent>(_changeStartDateEvent);
    on<ChooseWhereWillStay>(_chooseWhereWillStay);
    on<ChangeRequestData>(_setDataOnRequestModel);
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<MakeRequestState> emit) {
    if (event.formKey.currentState?.validate() ?? false) {
      event.formKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidatedState());
    }
  }

  init(Init event, Emitter<MakeRequestState> emit) {
    apartmentDetailsApiModelV2 = event.apartmentDetailsApiModelV2;
    emit(MakeRequestInitial());
  }

  selectedFull(OnSelectedFull event, Emitter<MakeRequestState> emit) {
    emit(MakeRequestInitial());
    apartmentDetailsApiModelV2!.isSelectedFullApartment =
        !apartmentDetailsApiModelV2!.isSelectedFullApartment;
    apartmentDetailsApiModelV2?.apartmentRooms?.forEach((element) {
      element.isSelected = false;
      element.roomBeds?.forEach((bed) {
        bed.isSelected = false;
      });
    });
    // orderSummaryFullApartment();
    emit(const OnSelectedState());
  }

  selectedMultiRooms(OnSelectedRoom event, Emitter<MakeRequestState> emit) {
    emit(MakeRequestInitial());
    if (apartmentDetailsApiModelV2!.isSelectedFullApartment) {
      subTotal = 0;
      securityDeposit = 0;
      serviceFee = 0;
    }
    apartmentDetailsApiModelV2!.isSelectedFullApartment = false;
    apartmentDetailsApiModelV2?.apartmentRooms?[event.roomIndex ?? 0].roomBeds
        ?.forEach((element) {
      if (apartmentDetailsApiModelV2!
              .apartmentRooms![event.roomIndex!].isSelected &&
          element.isSelected) {
        element.isSelected = !element.isSelected;
      } else {
        element.isSelected = true;
      }
    });
    apartmentDetailsApiModelV2!
            .apartmentRooms![event.roomIndex ?? 0].isSelected =
        !apartmentDetailsApiModelV2!
            .apartmentRooms![event.roomIndex ?? 0].isSelected;

    // orderSummaryByRoom(event.roomIndex ?? 0);
    emit(const OnSelectedRoomState());
  }

  selectedMultiBeds(OnSelectedBed event, Emitter<MakeRequestState> emit) {
    emit(MakeRequestInitial());
    if (apartmentDetailsApiModelV2!.isSelectedFullApartment) {
      subTotal = 0;
      securityDeposit = 0;
      serviceFee = 0;
    }

    apartmentDetailsApiModelV2!.isSelectedFullApartment = false;

    apartmentDetailsApiModelV2!.apartmentRooms![event.roomIndex ?? 0]
            .roomBeds![event.bedIndex ?? 0].isSelected =
        !(apartmentDetailsApiModelV2!.apartmentRooms![event.roomIndex ?? 0]
            .roomBeds![event.bedIndex ?? 0].isSelected);
    // orderSummaryByBed(event.roomIndex ?? 0, event.bedIndex ?? 0);
    emit(const OnSelectedBedState());

    allBedSelected(event.roomIndex ?? 0, emit,
        numOfGuest: event.numberOfGuest ?? 0);
  }

  allBedSelected(int roomIndex, Emitter<MakeRequestState> emit,
      {int numOfGuest = 0}) {
    if (apartmentDetailsApiModelV2!
            .apartmentRooms![roomIndex].allBedsSelected &&
        apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].bedsNo ==
            apartmentDetailsApiModelV2!
                .apartmentRooms![roomIndex].roomBeds!.length) {
      apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].isSelected = true;
    } else {
      if (numOfGuest == 1 &&
          apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].isSelected) {
        for (int x = 0;
            x <
                apartmentDetailsApiModelV2!
                    .apartmentRooms![roomIndex].roomBeds!.length;
            x++) {
          if (apartmentDetailsApiModelV2!
              .apartmentRooms![roomIndex].roomBeds![x].isSelected) {
            apartmentDetailsApiModelV2!
                    .apartmentRooms![roomIndex].roomBeds![x].isSelected =
                !apartmentDetailsApiModelV2!
                    .apartmentRooms![roomIndex].roomBeds![x].isSelected;
          }
        }
      }
      apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].isSelected = false;
    }
    emit(const OnSelectedRoomState());
  }

  _chooseWhereWillStay(
      ChooseWhereWillStay event, Emitter<MakeRequestState> emit) {
    RequestUiModel requestUiModel = event.requestUiModel;

    emit(ChangeWhereStay(requestUiModel));
  }

  _setDataOnRequestModel(
      ChangeRequestData event, Emitter<MakeRequestState> emit) {
    RequestUiModel requestUiModel = event.requestUiModel;

    emit(SetDataOnRequest(requestUiModel));
  }

  // orderSummaryFullApartment() {
  //   if (apartmentDetailsApiModelV2!.isSelectedFullApartment) {
  //     subTotal = 0;
  //     securityDeposit = 0;
  //     serviceFee = 0;
  //     subTotal += apartmentDetailsApiModelV2!.apartmentPrice;
  //     securityDeposit += apartmentDetailsApiModelV2!.apartmentSecurityFees;
  //     serviceFee += apartmentDetailsApiModelV2!.apartmentServicesFees;
  //   } else {
  //     if (subTotal - apartmentDetailsApiModelV2!.apartmentPrice < 0) {
  //       subTotal = 0;
  //       securityDeposit = 0;
  //       serviceFee = 0;
  //     } else {
  //       subTotal -= apartmentDetailsApiModelV2!.apartmentPrice;
  //       securityDeposit -= apartmentDetailsApiModelV2!.apartmentSecurityFees;
  //       serviceFee -= apartmentDetailsApiModelV2!.apartmentServicesFees;
  //     }
  //   }
  // }
  //
  // orderSummaryByRoom(int roomIndex) {
  //   if (apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].isSelected) {
  //     subTotal +=
  //         apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].roomPrice!;
  //     securityDeposit += apartmentDetailsApiModelV2!
  //         .apartmentRooms![roomIndex].roomSecurityFees!;
  //     serviceFee += apartmentDetailsApiModelV2!
  //         .apartmentRooms![roomIndex].roomServiceFees!;
  //   } else {
  //     if (subTotal -
  //             apartmentDetailsApiModelV2!
  //                 .apartmentRooms![roomIndex].roomPrice! <
  //         0) {
  //       subTotal = 0;
  //       securityDeposit = 0;
  //       serviceFee = 0;
  //     } else {
  //       subTotal -=
  //           apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].roomPrice!;
  //       securityDeposit -= apartmentDetailsApiModelV2!
  //           .apartmentRooms![roomIndex].roomSecurityFees!;
  //       serviceFee -= apartmentDetailsApiModelV2!
  //           .apartmentRooms![roomIndex].roomServiceFees!;
  //     }
  //   }
  // }
  //
  // orderSummaryByBed(int roomIndex, int bedIndex) {
  //   if (apartmentDetailsApiModelV2!
  //       .apartmentRooms![roomIndex].roomBeds![bedIndex].isSelected) {
  //     subTotal +=
  //         apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].bedPrice!;
  //     securityDeposit += apartmentDetailsApiModelV2!
  //         .apartmentRooms![roomIndex].bedSecurityDeposit!;
  //     serviceFee += apartmentDetailsApiModelV2!
  //         .apartmentRooms![roomIndex].bedServiceFees!;
  //   } else {
  //     if (subTotal -
  //             apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].bedPrice! <
  //         0) {
  //       subTotal = 0;
  //       securityDeposit = 0;
  //       serviceFee = 0;
  //     } else {
  //       subTotal -=
  //           apartmentDetailsApiModelV2!.apartmentRooms![roomIndex].bedPrice!;
  //       securityDeposit -= apartmentDetailsApiModelV2!
  //           .apartmentRooms![roomIndex].bedSecurityDeposit!;
  //       serviceFee -= apartmentDetailsApiModelV2!
  //           .apartmentRooms![roomIndex].bedServiceFees!;
  //     }
  //   }
  // }

  FutureOr<void> _sendRequestApiEvent(
      SendRequestApiEvent event, Emitter<MakeRequestState> emit) async {
    emit(MakeRequestLoadingState());
    bool haveUserRoom = false;
    bool canSendRequest = false;
    if (event.requestUiModel.roomsId.length > 1 &&
        event.requestUiModel.chooseBed != null &&
        event.requestUiModel.chooseBed!) {
      haveUserRoom = true;
      canSendRequest = true;
    } else if (event.requestUiModel.numberOfGuests == 1) {
      haveUserRoom = true;
      canSendRequest = true;
    } else {
      haveUserRoom = false;
      canSendRequest = false;
    }
    if (event.requestUiModel.numberOfGuests == 1) {
    } else {
      for (var entryZ in event.requestUiModel.roomsId.entries) {
        for (var entryI in event.requestUiModel.roomsId.entries) {
          if (entryI.key != entryZ.key &&
              (entryZ.value["guest_WA_No"] == entryI.value["guest_WA_No"] ||
                  entryZ.value["guest_Email"] == entryI.value["guest_Email"])) {
            canSendRequest = false;
          }
        }
      }
    }

    if (canSendRequest && haveUserRoom) {
      emit(await makeRequestRepository.sendRequestApiV2(event.requestUiModel,
          apartmentDetailsApiModelV2?.isSelectedFullApartment ?? false));
    } else {
      if (!haveUserRoom) {
        emit(const MakeRequestErrorState(
            "enter your mobile and email on your room details that you are entered when registered ",
            false));
      } else {
        emit(const MakeRequestErrorState(
            "you can't enter the same email and mobile on other rooms", false));
      }
    }
  }

  FutureOr<void> _changeNumberOfGuestEvent(
      ChangeNumberOfGuestEvent event, Emitter<MakeRequestState> emit) {
    emit(ChangeNumberOfGuestState(event.numberOfGuest));
  }

  FutureOr<void> _changeStartDateEvent(
      ChangeStartDateEvent event, Emitter<MakeRequestState> emit) {
    emit(StartDateChangedState(event.startDate));
  }
}

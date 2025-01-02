part of 'make_request_bloc.dart';

sealed class MakeRequestEvent extends Equatable {
  const MakeRequestEvent();

  @override
  List<Object> get props => [];
}

class Init extends MakeRequestEvent {
  ApartmentDetailsApiModelV2 apartmentDetailsApiModelV2;
   Init(this.apartmentDetailsApiModelV2);

  @override
  List<Object> get props => [];
}

class ValidateFormEvent extends MakeRequestEvent {
  final GlobalKey<FormState> formKey;
  const ValidateFormEvent(this.formKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SendRequestApiEvent extends MakeRequestEvent {
  final RequestUiModel requestUiModel;
  const SendRequestApiEvent(this.requestUiModel);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeNumberOfGuestEvent extends MakeRequestEvent {
  final int numberOfGuest;

  const ChangeNumberOfGuestEvent(this.numberOfGuest);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class OnSelectedFull extends MakeRequestEvent {
  const OnSelectedFull();

  @override
  List<Object> get props => [];
}

class OnSelectedRoom extends MakeRequestEvent {
  final int? roomIndex;

  const OnSelectedRoom({this.roomIndex});

  @override
  List<Object> get props => [];
}

class OnSelectedBed extends MakeRequestEvent {
  final int? roomIndex;
  final int? bedIndex;
  final int? numberOfGuest;

  const OnSelectedBed({this.roomIndex, this.bedIndex , this.numberOfGuest});

  @override
  List<Object> get props => [];
}

class ChangeStartDateEvent extends MakeRequestEvent {
  final DateTime startDate;

  const ChangeStartDateEvent(this.startDate);

  @override
  List<Object> get props => [identityHashCode(this)];
}


class ChooseWhereWillStay extends MakeRequestEvent {
  final RequestUiModel requestUiModel;

  const ChooseWhereWillStay(this.requestUiModel);
}
class ChangeRequestData extends MakeRequestEvent {
  final RequestUiModel requestUiModel;

  const ChangeRequestData(this.requestUiModel);
}
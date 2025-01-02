part of 'complaints_bloc.dart';

sealed class ComplaintsState extends Equatable {
  const ComplaintsState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class ComplaintsInitial extends ComplaintsState {}

class ComplaintsLoadingState extends ComplaintsState {}

class ComplaintsErrorState extends ComplaintsState {
  final String errorMassage;
  final bool isLocalizationKey;
  const ComplaintsErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class ComplaintsListLoadedState extends ComplaintsState {
  final List<ComplaintApiModel> list;

  const ComplaintsListLoadedState(this.list);
  @override
  List<Object> get props => [list];
}

class ComplaintsTypeLoadedState extends ComplaintsState {
  final List<String> list;

  const ComplaintsTypeLoadedState(this.list);
  @override
  List<Object> get props => [list];
}

class ComplaintsDetailsLoadedState extends ComplaintsState {
  final ComplaintDetailsApiModel complaintDetailsApiModel;

  const ComplaintsDetailsLoadedState(this.complaintDetailsApiModel);
  @override
  List<Object> get props => [complaintDetailsApiModel];
}

class ComplaintsAddSuccessfullyState extends ComplaintsState {
  final String message;

  const ComplaintsAddSuccessfullyState(this.message);
  @override
  List<Object> get props => [message];
}

class FormValidatedState extends ComplaintsState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class FormNotValidatedState extends ComplaintsState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

part of 'my_problem_bloc.dart';

sealed class MyProblemState extends Equatable {
  const MyProblemState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class MyProblemInitial extends MyProblemState {}

 class ReadMyProblemMaintenance extends MyProblemState {
  final bool isRead;
  const ReadMyProblemMaintenance(this.isRead);
}

class MyProblemLoadingAsPagingState extends MyProblemState {}

class MyProblemLoadingState extends MyProblemState {}

class MyProblemErrorState extends MyProblemState {
  final String errorMassage;
  final bool isLocalizationKey;
  const MyProblemErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class MyProblemLoadedState extends MyProblemState {
  final List<ProblemApiModel> list;
  final MetaModel pagingInfo;

  const MyProblemLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list, pagingInfo];
}

class UserApartmentsLoadedState extends MyProblemState {
  final List<UserApartmentsApiModel> list;

  const UserApartmentsLoadedState(this.list);
  @override
  List<Object> get props => [list];
}

class FormValidatedState extends MyProblemState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class FormNotValidatedState extends MyProblemState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeNumberOfDateAvailableState extends MyProblemState {
  final int numberDate;

  const ChangeNumberOfDateAvailableState(this.numberDate);
  @override
  List<Object> get props => [numberDate];
}

class SendProblemSuccessfullyState extends MyProblemState {
  const SendProblemSuccessfullyState();
  @override
  List<Object> get props => [identityHashCode(this)];
}

class EditProblemSuccessfullyState extends MyProblemState {
  final AddProblemResponse addProblemResponse;
  const EditProblemSuccessfullyState(this.addProblemResponse);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ProblemDetailsLoadedState extends MyProblemState {
  final ProblemDetailsApiModel problemDetailsApiModel;

  const ProblemDetailsLoadedState(this.problemDetailsApiModel);
  @override
  List<Object> get props => [problemDetailsApiModel];
}

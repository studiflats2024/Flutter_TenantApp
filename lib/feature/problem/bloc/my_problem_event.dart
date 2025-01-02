part of 'my_problem_bloc.dart';

sealed class MyProblemEvent extends Equatable {
  const MyProblemEvent();

  @override
  List<Object> get props => [];
}

class GetMyProblemApiEvent extends MyProblemEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  final ProblemFilter problemFilter;

  const GetMyProblemApiEvent(
      this.pageNumber, this.isSwipeToRefresh, this.problemFilter);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}

class GetUserApartmentsApiEvent extends MyProblemEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetProblemDetailsApiEvent extends MyProblemEvent {
  final String problemId;

  const GetProblemDetailsApiEvent(this.problemId);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class EditDescriptionApiEvent extends MyProblemEvent {
  final String problemId;
  final String description;

  const EditDescriptionApiEvent(this.problemId, this.description);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ValidateFormEvent extends MyProblemEvent {
  final GlobalKey<FormState> formKey;
  const ValidateFormEvent(this.formKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SendProblemApiEvent extends MyProblemEvent {
  final SendProblemModel sendProblemModel;
  const SendProblemApiEvent(this.sendProblemModel);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeNumberOfDateAvailableEvent extends MyProblemEvent {
  final int numberDate;
  const ChangeNumberOfDateAvailableEvent(this.numberDate);
  @override
  List<Object> get props => [identityHashCode(this)];
}

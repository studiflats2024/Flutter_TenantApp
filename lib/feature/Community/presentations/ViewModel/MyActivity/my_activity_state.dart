part of 'my_activity_bloc.dart';

@immutable
sealed class MyActivityState {}

class MyActivityInitial extends MyActivityState {}

class MyActivityLoading extends MyActivityState {}

class GetMyActivityState extends MyActivityState {
  final MyActivityResponse data;
  final bool isFirst;

  GetMyActivityState(this.data, this.isFirst);
}

class UnEnrollState extends MyActivityState {
  final int position;

  UnEnrollState(this.position);
}

class SuccessfullyReviewState extends MyActivityState {
  final int position;

  SuccessfullyReviewState(this.position);
}

class MyActivityErrorState extends MyActivityState {
  final String errorMassage;
  final bool isLocalizationKey;

  MyActivityErrorState(this.errorMassage, this.isLocalizationKey);
}

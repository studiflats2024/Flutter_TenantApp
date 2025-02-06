part of 'activity_details_bloc.dart';

@immutable
sealed class ActivityDetailsEvent {}

class GetActivityDetailsEvent extends ActivityDetailsEvent {
  final ActivityDetailsSendModel activityDetailsSendModel;

  GetActivityDetailsEvent(this.activityDetailsSendModel);
}

class EnrollEvent extends ActivityDetailsEvent {
  final EnrollActivitySendModel model;

  EnrollEvent(this.model);
}

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


class ChooseDayTimeEvent extends ActivityDetailsEvent {
  final ConsultDay day;

  ChooseDayTimeEvent(this.day);
}

class FilterRatingEvent extends ActivityDetailsEvent {
  final String filter;

  FilterRatingEvent(this.filter);
}

class CheckLoggedInEvent extends ActivityDetailsEvent {

  CheckLoggedInEvent();
}

class ChooseTimeEvent extends ActivityDetailsEvent {
  final String time;

  ChooseTimeEvent(this.time);
}
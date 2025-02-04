part of 'activity_details_bloc.dart';

@immutable
sealed class ActivityDetailsEvent {}

class GetActivityDetailsEvent extends ActivityDetailsEvent{
  ActivityDetailsSendModel activityDetailsSendModel;
  GetActivityDetailsEvent(this.activityDetailsSendModel);
}

part of 'my_activity_bloc.dart';

@immutable
sealed class MyActivityEvent {}

class GetMyActivityEvent extends MyActivityEvent {
  final MyActivitySendModel model;
  final bool isFirst;

  GetMyActivityEvent(this.model, this.isFirst);
}

class UnEnrollEvent extends MyActivityEvent {
  final String id;
  final int position;

  UnEnrollEvent(this.id, this.position);
}

class ReviewEvent extends MyActivityEvent {
  final MyActivityRatingSendModel model;
  final int position;

  ReviewEvent(this.model, this.position);
}

part of 'invite_frindes_bloc.dart';

@immutable
sealed class InviteFrindesEvent {}

//ignore: must_be_immutable
class InviteFriendEvent extends InviteFrindesEvent{
  InviteFriendSendModel model;

  InviteFriendEvent(this.model);
}

class GetMyPlanEvent extends InviteFrindesEvent{}

class ChooseDateEvent extends InviteFrindesEvent{
  final DateTime? date;
  ChooseDateEvent(this.date);
}

class GetInvitationsHistoryEvent extends InviteFrindesEvent{
  final PagingListSendModel pagingListSendModel;

  GetInvitationsHistoryEvent(this.pagingListSendModel);
}

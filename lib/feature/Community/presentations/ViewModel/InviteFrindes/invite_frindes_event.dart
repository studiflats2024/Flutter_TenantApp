part of 'invite_frindes_bloc.dart';

@immutable
sealed class InviteFrindesEvent {}

//ignore: must_be_immutable
class InviteFriendEvent extends InviteFrindesEvent{
  InviteFriendSendModel model;

  InviteFriendEvent(this.model);
}
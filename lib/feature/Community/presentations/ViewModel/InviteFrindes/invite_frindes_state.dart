part of 'invite_frindes_bloc.dart';

@immutable
sealed class InviteFrindesState {}

final class InviteFrindesInitial extends InviteFrindesState {}

class InviteFriendsLoading extends InviteFrindesState {}

class InviteFriendState extends InviteFrindesState {
  bool isReminder;

  InviteFriendState({this.isReminder = false});
}

class InviteHistoryFriendState extends InviteFrindesState {
  final InvitationsHistoryModel model;

  InviteHistoryFriendState(this.model);
}

class ChooseDateState extends InviteFrindesState{
  final DateTime? date;
  ChooseDateState(this.date);
}

class GetMyPlanState extends InviteFrindesState {
  final MyPlanModel? model;

  GetMyPlanState(this.model);
}

class ErrorInviteFriendState extends InviteFrindesState {
  final String errorMassage;
  final bool isLocalizationKey;

  ErrorInviteFriendState(this.errorMassage, this.isLocalizationKey);
}

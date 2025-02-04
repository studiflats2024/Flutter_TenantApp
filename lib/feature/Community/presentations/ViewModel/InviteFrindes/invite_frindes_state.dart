part of 'invite_frindes_bloc.dart';

@immutable
sealed class InviteFrindesState {}

final class InviteFrindesInitial extends InviteFrindesState {}

class InviteFriendsLoading extends InviteFrindesState {}

class InviteFriendState extends InviteFrindesState {}

class ErrorInviteFriendState extends InviteFrindesState {
  final String errorMassage;
  final bool isLocalizationKey;

  ErrorInviteFriendState(this.errorMassage, this.isLocalizationKey);
}

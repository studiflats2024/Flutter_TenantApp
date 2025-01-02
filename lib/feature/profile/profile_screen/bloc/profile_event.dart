part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetProfileData extends ProfileEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class EditPersonalInfoClickedEvent extends ProfileEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class LogoutClickedEvent extends ProfileEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class DeleteAccountClickedEvent extends ProfileEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

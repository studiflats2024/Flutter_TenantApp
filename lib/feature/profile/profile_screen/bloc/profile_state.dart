part of 'profile_bloc.dart';

abstract class GetProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetProfileInitialState extends GetProfileState {}

class GetProfileLoadingState extends GetProfileState {}

class GetProfileErrorState extends GetProfileState {
  final String errorMassage;
  final bool isLocalizationKey;
  GetProfileErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage];
}

class GetProfileLoadedState extends GetProfileState {
  final ProfileInfoApiModel data;
  GetProfileLoadedState(this.data);

  @override
  List<Object> get props => [data];
}

class LogoutState extends GetProfileState {}

class DeleteAccountState extends GetProfileState {}

class GuestModeStateState extends GetProfileState {}

part of 'completed_profile_bloc.dart';

abstract class CompletedProfileEvent extends Equatable {
  const CompletedProfileEvent();

  @override
  List<Object> get props => [];
}

class ValidateFormEvent extends CompletedProfileEvent {
  final GlobalKey<FormState> formKey;
  const ValidateFormEvent(this.formKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class CompletedProfileInfoApiEvent extends CompletedProfileEvent {
  final String? email;
  final String? mobileNumber;
  final String genderKey;
  final String birthday;
  final String nationality;
  final String uuid;
  final bool fromSocial;
  const CompletedProfileInfoApiEvent({
    this.email,
    this.mobileNumber,
    required this.genderKey,
    required this.birthday,
    required this.nationality,
    required this.uuid,
    required this.fromSocial,
  });

  @override
  List<Object> get props => [];
}


class SetAsLoggedUserEvent extends CompletedProfileEvent {
  @override
  List<Object> get props => [];
}

class SaveTokenDataEvent extends CompletedProfileEvent {
  final LoginSuccessfulResponse loginSuccessfulResponse;

  SaveTokenDataEvent(this.loginSuccessfulResponse);
  @override
  List<Object> get props => [loginSuccessfulResponse];
}

class GetUserInfoApiEvent extends CompletedProfileEvent {
  GetUserInfoApiEvent();
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SaveUserInfoEvent extends CompletedProfileEvent {
  final ProfileInfoApiModel profileInfoApiModel;
  SaveUserInfoEvent(this.profileInfoApiModel);
  @override
  List<Object> get props => [profileInfoApiModel];
}
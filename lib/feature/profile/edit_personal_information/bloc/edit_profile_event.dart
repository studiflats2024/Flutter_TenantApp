part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent {
  List<Object> get props => [];
}

class UpdateBasicDataEvent extends EditProfileEvent {
  String fullName;
  String about;

  UpdateBasicDataEvent(this.fullName, this.about);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class UpdateProfileImageEvent extends EditProfileEvent {
  String imagePath;
  UpdateProfileImageEvent(this.imagePath);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class ValidateFormEvent extends EditProfileEvent {
  final GlobalKey<FormState> editFormKey;
  ValidateFormEvent(this.editFormKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class UpdateEmailEvent extends EditProfileEvent {
  final String currentEmail;
  final String password;
  final String newEmail;
  UpdateEmailEvent(this.currentEmail, this.password, this.newEmail);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class UpdatePhoneNumberEvent extends EditProfileEvent {
  final String currentPhoneNumber;
  final String password;
  final String newPhoneNumber;
  UpdatePhoneNumberEvent(
      this.currentPhoneNumber, this.password, this.newPhoneNumber);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetUpdatedLocalDataEvent extends EditProfileEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

part of 'app_pages_bloc.dart';

sealed class AppPagesEvent extends Equatable {
  const AppPagesEvent();

  @override
  List<Object> get props => [];
}

class GetTermsConditionsApiEvent extends AppPagesEvent {
  const GetTermsConditionsApiEvent();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetPrivacyPrivacyApiEvent extends AppPagesEvent {
  const GetPrivacyPrivacyApiEvent();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetFaqListApiEvent extends AppPagesEvent {
  const GetFaqListApiEvent();

  @override
  List<Object> get props => [identityHashCode(this)];
}

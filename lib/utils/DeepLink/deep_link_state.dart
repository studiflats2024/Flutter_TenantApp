part of 'deep_link_bloc.dart';

@immutable
sealed class DeepLinkState {}

final class DeepLinkInitial extends DeepLinkState {}

final class LoginDeepLinkSuccess extends DeepLinkState {
  LoginDeepLinkSuccess();
}

final class LoginDeepLinkFailed extends DeepLinkState {
  LoginDeepLinkFailed();
}

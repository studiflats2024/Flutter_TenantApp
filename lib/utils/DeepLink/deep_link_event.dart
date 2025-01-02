part of 'deep_link_bloc.dart';

@immutable
sealed class DeepLinkEvent {}

class LogInEvent extends DeepLinkEvent {
  final LoginSuccessfulResponse? loginSuccessfulResponse;
  final String? token;
  LogInEvent({this.loginSuccessfulResponse, this.token});
}

part of 'app_version_bloc.dart';

@immutable
sealed class AppVersionEvent {}


class GetVersion extends AppVersionEvent {
  final String version;

  GetVersion(this.version);
}
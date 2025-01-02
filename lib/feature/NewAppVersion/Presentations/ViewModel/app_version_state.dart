part of 'app_version_bloc.dart';

@immutable
sealed class AppVersionState {}

final class AppVersionInitial extends AppVersionState {}

final class AppVersionNeedToUpdate extends AppVersionState {}

final class AppVersionReadyForUse extends AppVersionState {}

final class AppVersionFailed extends AppVersionState {
  final ErrorApiModel failure;
  AppVersionFailed(this.failure);
}

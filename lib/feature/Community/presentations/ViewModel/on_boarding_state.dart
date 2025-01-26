part of 'on_boarding_bloc.dart';

@immutable
sealed class OnBoardingState {}

final class OnBoardingInitial extends OnBoardingState {}

final class OnBoardingChangePage extends OnBoardingState {
  final int pageIndex;
  final bool prev;

  OnBoardingChangePage(this.pageIndex, this.prev);
}

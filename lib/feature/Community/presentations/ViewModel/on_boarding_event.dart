part of 'on_boarding_bloc.dart';

@immutable
sealed class OnBoardingEvent {}

class ChangePageEvent extends OnBoardingEvent{
  final int index;
  final bool prev;

  ChangePageEvent(this.index, this.prev);
}

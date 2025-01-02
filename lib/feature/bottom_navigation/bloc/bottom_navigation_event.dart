part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class ItemBottomNavigationClickedEvt extends BottomNavigationEvent {
  final int index;

  const ItemBottomNavigationClickedEvt(this.index);

  @override
  List<Object> get props => [index];
}

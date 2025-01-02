part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();

  @override
  List<Object> get props => [];
}

class BottomNavigationInitial extends BottomNavigationState {}

class HomeClickedSte extends BottomNavigationState {}

class ProfileClickedSte extends BottomNavigationState {}

class WishlistClickedSte extends BottomNavigationState {}

class BookingsClickedSte extends BottomNavigationState {}

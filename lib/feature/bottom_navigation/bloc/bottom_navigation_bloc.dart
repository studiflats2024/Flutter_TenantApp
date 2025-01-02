import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(BottomNavigationInitial()) {
    on<ItemBottomNavigationClickedEvt>(_itemNavClickedEvt);
  }

  FutureOr<void> _itemNavClickedEvt(ItemBottomNavigationClickedEvt event,
      Emitter<BottomNavigationState> emit) {
    switch (event.index) {
      case 1:
        emit(WishlistClickedSte());
        break;
      case 2:
        emit(BookingsClickedSte());
        break;
      case 3:
        emit(ProfileClickedSte());
        break;
      default:
        emit(HomeClickedSte());
    }
  }
}

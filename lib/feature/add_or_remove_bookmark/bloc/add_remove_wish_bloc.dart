import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_remove_wish_repository.dart';

part 'add_remove_wish_event.dart';
part 'add_remove_wish_state.dart';

class AddRemoveWishBloc extends Bloc<AddRemoveWishEvent, AddRemoveWishState> {
  final BaseAddRemoveWishRepository bookmarkRepository;
  AddRemoveWishBloc(this.bookmarkRepository)
      : super(const AddRemoveWishInitialState()) {
    on<ToggleWishEvent>(_onToggleWishEvent);
  }

  FutureOr<void> _onToggleWishEvent(
    ToggleWishEvent event,
    Emitter<AddRemoveWishState> emit,
  ) async {
    emit(AddRemoveWishLoadingState(id: event.id));
    if (event.isAddedToBookmarks) {
      emit(await bookmarkRepository.removeWishListApi(event.id));
    } else {
      emit(await bookmarkRepository.addWishListApi(event.id));
    }
  }
}

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/apartments/apartment_list/apartment_item_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/unit_list/bloc/unit_list_repository.dart';

part 'unit_list_event.dart';
part 'unit_list_state.dart';

class UnitListBloc extends Bloc<UnitListEvent, UnitListState> {
  final BaseUnitListRepository unitListRepository;
  UnitListBloc(this.unitListRepository) : super(UnitListInitial()) {
    on<GetUniListApiEvent>(_getUnitListApiEvent);
  }

  FutureOr<void> _getUnitListApiEvent(
      GetUniListApiEvent event, Emitter<UnitListState> emit) async {
    // emit(UnitListLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? UnitListLoadingState()
          : UnitListLoadingAsPagingState());
    }else{
      emit(UnitListLoadingState());
    }
    emit(await unitListRepository.getUnitListApiV2(event.pageNumber));
  }
}

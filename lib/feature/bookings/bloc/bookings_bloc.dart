import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/booking/booking_list_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final BaseBookingsRepository baseBookingsRepository;

  BookingsBloc(this.baseBookingsRepository) : super(BookingsInitial()) {
    //on<GetActiveBookingsEvent>(_getActiveBookingsEvent);
    on<GetActiveBookingsEvent>(_getActiveBookingsEventV2);
    on<GetExpiredBookingsEvent>(_getExpiredBookingsEventV2);
    on<GetOffersBookingsEvent>(_getOffersBookingsEventV2);
    on<CheckIsLoggedInEvent>(_checkIsLoggedInEvent);
  }

  FutureOr<void> _getActiveBookingsEvent(
      GetActiveBookingsEvent event, Emitter<BookingsState> emit) async {
    emit(BookingsActiveLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? BookingsActiveLoadingState()
          : BookingsActiveLoadingAsPagingState());
    }
    emit(await baseBookingsRepository.getActiveBookingsApi(event.pageNumber));
  }

  FutureOr<void> _getActiveBookingsEventV2(
      GetActiveBookingsEvent event, Emitter<BookingsState> emit) async {
    emit(BookingsActiveLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? BookingsActiveLoadingState()
          : BookingsActiveLoadingAsPagingState());
    }
    emit(await baseBookingsRepository.getActiveBookingsApiV2(event.pageNumber));
  }

  FutureOr<void> _getExpiredBookingsEvent(
      GetExpiredBookingsEvent event, Emitter<BookingsState> emit) async {
    emit(BookingsExpiredLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? BookingsExpiredLoadingState()
          : BookingsExpiredLoadingAsPagingState());
    }
    emit(await baseBookingsRepository.getExpiredBookingsApi(event.pageNumber));
  }
  FutureOr<void> _getExpiredBookingsEventV2(
      GetExpiredBookingsEvent event, Emitter<BookingsState> emit) async {
    emit(BookingsExpiredLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? BookingsExpiredLoadingState()
          : BookingsExpiredLoadingAsPagingState());
    }
    emit(await baseBookingsRepository.getExpiredBookingsApiV2(event.pageNumber));
  }

  FutureOr<void> _getOffersBookingsEvent(
      GetOffersBookingsEvent event, Emitter<BookingsState> emit) async {
    emit(BookingsOffersLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? BookingsOffersLoadingState()
          : BookingsOffersLoadingAsPagingState());
    }
    emit(await baseBookingsRepository.getOffersBookingsApi(event.pageNumber));
  }
  FutureOr<void> _getOffersBookingsEventV2(
      GetOffersBookingsEvent event, Emitter<BookingsState> emit) async {
    emit(BookingsOffersLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? BookingsOffersLoadingState()
          : BookingsOffersLoadingAsPagingState());
    }
    emit(await baseBookingsRepository.getOffersBookingsApiV2(event.pageNumber));
  }

  Future<FutureOr<void>> _checkIsLoggedInEvent(
      CheckIsLoggedInEvent event, Emitter<BookingsState> emit) async {
    emit(await baseBookingsRepository.checkLoggedIn());
  }
}

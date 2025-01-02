import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/booking/extend_contract_model.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';

part 'booking__event.dart';

part 'booking__state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingsRepository bookingsRepository;

  BookingBloc(this.bookingsRepository) : super(BookingInitial()) {
    on<SetEndDateEvent>(_setEndDate);
    on<ExtendContractEvent>(_extendContract);
  }

  _setEndDate(SetEndDateEvent setEndDate, Emitter<BookingState> emit) {
    emit(SetEndDateState(setEndDate.endDate));
  }

  _extendContract(ExtendContractEvent extendContractEvent,
      Emitter<BookingState> emit) async {
    emit(ExtendContractLoadingState());
    emit(await bookingsRepository
        .extendContract(extendContractEvent.extendContractModel));
  }
}

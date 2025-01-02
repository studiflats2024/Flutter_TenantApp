import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';

part 'select_tenant_for_pay_event.dart';

part 'select_tenant_for_pay_state.dart';

class SelectTenantForPayBloc
    extends Bloc<SelectTenantForPayEvent, SelectTenantForPayState> {
  SelectTenantForPayBloc(this.baseBookingsRepository)
      : super(SelectTenantForPayInitial()) {
    on<SelectTenantForPayInitEvent>(_init);
    on<ChoosePayOptionEvent>(_choosePayOption);
    on<ChooseRoommateEvent>(_chooseRoommate);
  }

  BaseBookingsRepository baseBookingsRepository;
  BookingDetailsModel? bookingDetailsModel;

  _init(SelectTenantForPayInitEvent event, Emitter<SelectTenantForPayState> emit) {
    bookingDetailsModel = event.bookingDetailsModel;
    emit(SelectTenantForPayInitial());
  }

  _choosePayOption(ChoosePayOptionEvent event, Emitter<SelectTenantForPayState> emit) {
    if (event.payOption != 2) {
      for (int i = 0; i < bookingDetailsModel!.guests!.length; i++) {
        bookingDetailsModel!.guests![i].isSelected = false;
      }
      bookingDetailsModel!.payOption = event.payOption;
      emit(SelectTenantForPayInitial());
    } else {
      bookingDetailsModel!.payOption = event.payOption;
      _chooseRoommate(ChooseRoommateEvent(0), emit);
    }
  }

  _chooseRoommate(ChooseRoommateEvent event, Emitter<SelectTenantForPayState> emit) {
    if (bookingDetailsModel!.payOption != 2) {
      bookingDetailsModel!.payOption = 2;
    }
    if (event.index != 0 && !bookingDetailsModel!.guests![0].isSelected) {
      bookingDetailsModel!.guests![bookingDetailsModel!.guestIndex].isSelected =
          !bookingDetailsModel!
              .guests![bookingDetailsModel!.guestIndex].isSelected;
    }
    bookingDetailsModel!.guests![event.index].isSelected =
        !bookingDetailsModel!.guests![event.index].isSelected;
    emit(SelectTenantForPayInitial());

    if (bookingDetailsModel!.allTenantsSelected) {
      _choosePayOption(ChoosePayOptionEvent(1), emit);
    }
    if (bookingDetailsModel!.payOption == 2) {
      if (!bookingDetailsModel!
          .guests![bookingDetailsModel!.guestIndex].isSelected) {
        _choosePayOption(ChoosePayOptionEvent(0), emit);
      }
    }
  }
}

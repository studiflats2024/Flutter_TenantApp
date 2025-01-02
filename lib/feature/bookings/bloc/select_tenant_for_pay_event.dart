part of 'select_tenant_for_pay_bloc.dart';

@immutable
sealed class SelectTenantForPayEvent {}

class SelectTenantForPayInitEvent extends SelectTenantForPayEvent {
  final BookingDetailsModel bookingDetailsModel;

  SelectTenantForPayInitEvent(this.bookingDetailsModel);
}


class ChoosePayOptionEvent extends SelectTenantForPayEvent {
  final int payOption;
  ChoosePayOptionEvent(this.payOption);
}

class ChooseRoommateEvent extends SelectTenantForPayEvent {
  final int index;
  ChooseRoommateEvent(this.index);
}
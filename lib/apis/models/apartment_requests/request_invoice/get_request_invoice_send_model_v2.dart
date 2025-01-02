import 'package:equatable/equatable.dart';

class GetRequestInvoiceSendModelV2 extends Equatable {
  final String requestId;
  final String guestId;
  const GetRequestInvoiceSendModelV2({
    required this.requestId,
    required this.guestId,
  });

  Map<String, dynamic> toMap() => {
    'Booking_ID': requestId,
    'Guest_ID': guestId,
  };

  @override
  List<Object?> get props {
    return [
      requestId,
      guestId,
    ];
  }
}

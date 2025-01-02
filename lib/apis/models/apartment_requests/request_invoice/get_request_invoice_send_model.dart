import 'package:equatable/equatable.dart';

class GetRequestInvoiceSendModel extends Equatable {
  final String requestId;
  final int paidPercentage;
  const GetRequestInvoiceSendModel({
    required this.requestId,
    required this.paidPercentage,
  });

  Map<String, dynamic> toMap() => {
        'Req_ID': requestId,
        'Paid_Perc': paidPercentage,
      };

  @override
  List<Object?> get props {
    return [
      requestId,
      paidPercentage,
    ];
  }
}

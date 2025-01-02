import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';

class InvoicesListWrapper extends Equatable {
  final List<InvoiceApiModel> data;
  final MetaModel pagingInfo;

  const InvoicesListWrapper({
    required this.data,
    required this.pagingInfo,
  });

  factory InvoicesListWrapper.fromJson(Map<String, dynamic> json) =>
      InvoicesListWrapper(
        data: (json["data"] as List<dynamic>)
            .map((e) => InvoiceApiModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagingInfo: (json['totalRecords'] != null)
            ? MetaModel.fromJson(json)
            : MetaModel.getEmptyOne(),
      );

  @override
  List<Object?> get props {
    return [data];
  }
}

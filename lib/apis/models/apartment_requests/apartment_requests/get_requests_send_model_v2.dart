import 'package:equatable/equatable.dart';

class GetRequestsSendModelV2 extends Equatable {
  final bool? active;
  final bool? offered;
  final int pageNumber;
  final int pageSize;
  const GetRequestsSendModelV2({
    this.active = false,
    this.offered = false,
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toMap() => {
    'Page_No': pageNumber,
    'Page_Size': pageSize,
    "Active": active,
    "Offered": offered,
  };

  @override
  List<Object?> get props {
    return [
      pageNumber,
      pageSize,
    ];
  }
}

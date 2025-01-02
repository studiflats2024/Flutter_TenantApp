import 'package:equatable/equatable.dart';

class GetRequestsSendModel extends Equatable {
  final bool? status;
  final int pageNumber;
  final int pageSize;
  const GetRequestsSendModel({
    this.status,
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toMap() => {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        "status": status,
      };

  @override
  List<Object?> get props {
    return [
      pageNumber,
      pageSize,
    ];
  }
}

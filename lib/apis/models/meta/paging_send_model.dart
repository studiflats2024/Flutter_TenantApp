import 'package:equatable/equatable.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

class PagingListSendModel extends Equatable {
  final int? pageNumber;
  final int pageSize;
  final String? status;
  final String? issueStatus;

  const PagingListSendModel({
    this.pageNumber,
    this.pageSize = 10,
    this.status,
    this.issueStatus,
  });

  Map<String, dynamic> toJson() => {
        'pageNumber': pageNumber ?? 1,
        'pageSize': pageSize,
        if (!status.isNullOrEmpty) 'status': status,
        if (!issueStatus.isNullOrEmpty) 'issue_Status': issueStatus,
      };

  @override
  List<Object?> get props {
    return [
      pageNumber,
      pageSize,
    ];
  }
}


class PagingListSendModel2 extends Equatable {
  final int? pageNumber;
  final int pageSize;
  final String? status;
  final String? issueStatus;

  const PagingListSendModel2({
    this.pageNumber,
    this.pageSize = 10,
    this.status,
    this.issueStatus,
  });

  Map<String, dynamic> toJson() => {
    'Page_No': pageNumber ?? 1,
    'Page_Size': pageSize,
    if (!status.isNullOrEmpty) 'status': status,
    if (!issueStatus.isNullOrEmpty) 'issue_Status': issueStatus,
  };

  @override
  List<Object?> get props {
    return [
      pageNumber,
      pageSize,
    ];
  }
}


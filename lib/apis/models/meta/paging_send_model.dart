import 'package:equatable/equatable.dart';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
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

class PagingCommunityActivitiesListSendModel extends Equatable {
  final int? pageNumber;
  final int pageSize;
  final ActivitiesType? activitiesType;

  const PagingCommunityActivitiesListSendModel({
    this.pageNumber,
    this.pageSize = 10,
    this.activitiesType ,
  });

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber ?? 1,
    'pageSize': pageSize,
  };

  Map<String, dynamic> toParameters() => {
    '_Type': activitiesType?.name.capitalize??ActivitiesType.all.name.capitalize
  };

  @override
  List<Object?> get props {
    return [
      pageNumber,
      pageSize,
    ];
  }
}

import 'package:equatable/equatable.dart';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/utils/extensions/extension_string.dart';

class PagingCommunityActivitiesListSendModel extends Equatable {
  final int? pageNumber;
  final int pageSize;
  final bool isHome;
  final ActivitiesType? activitiesType;

  const PagingCommunityActivitiesListSendModel({
    this.pageNumber,
    this.isHome = false,
    this.pageSize = 10,
    this.activitiesType ,
  });

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber ?? 1,
    'pageSize': pageSize,
  };

  Map<String, dynamic> toParameters() => {
    '_Type': activitiesType?.filter?? ActivitiesType.all.filter,
    "is_Home": isHome
  };

  @override
  List<Object?> get props {
    return [
      pageNumber,
      pageSize,
    ];
  }
}
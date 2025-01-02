import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/my_problems/user_apartments_api_model.dart';

class UserApartmentsListWrapper extends Equatable {
  final List<UserApartmentsApiModel> data;

  const UserApartmentsListWrapper({
    required this.data,
  });

  factory UserApartmentsListWrapper.fromJson(List<dynamic> json) =>
      UserApartmentsListWrapper(
        data: json
            .map((e) =>
                UserApartmentsApiModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props {
    return [data];
  }
}

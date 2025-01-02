import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class WaitingRequestUiModel extends Equatable {
  DateTime? startDate;
  DateTime? endDate;
  int? numberOfGuests;
  String? rentFees;
  String? city;
  String? tellMore;

  WaitingRequestUiModel({
    this.startDate,
    this.endDate,
    this.numberOfGuests,
    this.rentFees,
    this.city,
    this.tellMore,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        numberOfGuests,
        rentFees,
        city,
        tellMore,
      ];
}

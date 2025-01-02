import 'package:equatable/equatable.dart';

class ComplaintTypeListWrapper extends Equatable {
  final List<String> data;

  const ComplaintTypeListWrapper({
    required this.data,
  });

  factory ComplaintTypeListWrapper.fromJson(List<dynamic> json) =>
      ComplaintTypeListWrapper(
        data: (json).map((e) => e.toString()).toList(),
      );

  @override
  List<Object?> get props {
    return [
      data,
    ];
  }
}

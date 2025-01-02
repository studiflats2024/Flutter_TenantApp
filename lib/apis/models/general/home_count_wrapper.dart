import 'package:equatable/equatable.dart';

// ApartmentDetailsWrapper
class HomeCountWrapper extends Equatable {
  final int chatsCount;
  final int notificationsCount;

  const HomeCountWrapper({
    required this.chatsCount,
    required this.notificationsCount,
  });

  factory HomeCountWrapper.fromJson(Map<String, dynamic> json) =>
      HomeCountWrapper(
        chatsCount: json['chats'] as int,
        notificationsCount: json['notifications'] as int,
      );

  @override
  List<Object?> get props {
    return [
      chatsCount,
      notificationsCount,
    ];
  }
}

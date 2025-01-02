import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProfileInfoApiModel extends Equatable {
  final String userId;
  final String fullName;
  final String email;
  final String mobile;
  final String profileImageUrl;
  final String about;
  final bool phoneVerified;
  final bool mailVerified;
  final bool profileVerified;

  const ProfileInfoApiModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.phoneVerified,
    required this.mailVerified,
    required this.profileVerified,
    required this.profileImageUrl,
    required this.about,
  });

  ProfileInfoApiModel.fromJson(dynamic json)
      : userId = json['user_ID'] as String,
        fullName = json['fullName'] as String? ?? "",
        email = json['email'] as String? ?? "",
        mobile = json['mobile'] as String,
        phoneVerified = json['phone_Verified'] as bool,
        mailVerified = json['mail_Verified'] as bool,
        profileVerified = json['profile_Verified'] as bool,
        profileImageUrl = json['profile_pic'] as String? ?? "",
        about = json['about'] as String? ?? "";

  @override
  List<Object> get props => [
        userId,
        fullName,
        email,
        mobile,
        phoneVerified,
        mailVerified,
        profileVerified,
        profileImageUrl,
        about,
      ];
}

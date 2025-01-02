class AuthSuccessfulResponse {
  final String status;
  final String message;
  final String uuid;
  final bool profileCompleted;

  AuthSuccessfulResponse(
    this.status,
    this.message,
    this.uuid,
    this.profileCompleted,
  );
  static AuthSuccessfulResponse demo =
      AuthSuccessfulResponse("status", "message", "uuid", true);

  AuthSuccessfulResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String? ??"",
        message = json['message'] as String? ??"",
        profileCompleted = json['profile_Completed'] != null
            ? json['profile_Completed'] as bool
            : true,
        uuid = json['uuid'] ??'';

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'uuid': uuid,
        'profile_Completed': profileCompleted,
      };
}

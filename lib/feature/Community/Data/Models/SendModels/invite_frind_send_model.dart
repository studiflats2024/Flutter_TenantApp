class InviteFriendSendModel {
  String name;
  String email;
  String phone;
  DateTime? invitationDate;
  bool isReminder ;

  InviteFriendSendModel.create({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.invitationDate,
    this.isReminder = false
  });

  InviteFriendSendModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.invitationDate,
    this.isReminder = false
  });

  toMap() {
    return {
      "friend_Name": name,
      "friend_Mail": email,
      "friend_Phone": phone,
      "invitation_Date": invitationDate?.toIso8601String(),
      "is_Reminder": isReminder
    };
  }
}

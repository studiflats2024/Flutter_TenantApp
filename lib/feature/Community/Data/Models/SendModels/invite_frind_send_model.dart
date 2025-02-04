class InviteFriendSendModel {
  String name;
  String email;
  String phone;
  DateTime? invitationDate;

  InviteFriendSendModel.create({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.invitationDate,
  });

  InviteFriendSendModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.invitationDate,
  });

  toMap() {
    return {
      "friend_Name": name,
      "friend_Mail": email,
      "friend_Phone": phone,
      "invitation_Date": invitationDate
    };
  }
}

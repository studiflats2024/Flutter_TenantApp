class ReplyComplaintSendModel {
  final String ticketID;
  final String replyDesc;
  final String attach;

  ReplyComplaintSendModel(
      {required this.ticketID, required this.replyDesc, required this.attach});

  Map<String, dynamic> toMap() {
    return {
      "ticket_ID": ticketID,
      "reply_Desc": replyDesc,
      "attach": attach,
    };
  }
}

class CreateTicketSendModel {
  final String ticketType;
  final String ticketDesc;

  CreateTicketSendModel({required this.ticketType, required this.ticketDesc});

  Map<String, dynamic> toMap() {
    return {
      "ticket_Type": ticketType,
      "ticket_Desc": ticketDesc,
    };
  }
}

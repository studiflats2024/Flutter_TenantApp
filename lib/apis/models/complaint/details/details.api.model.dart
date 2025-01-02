import 'reply.api.model.dart';

class ComplaintDetailsApiModel {
  final String ticketId;
  final String ticketCode;
  final String ticketType;
  final String ticketDesc;
  final List<ReplyComplaintApiModel> reply;

  ComplaintDetailsApiModel({
    required this.ticketId,
    required this.ticketCode,
    required this.ticketType,
    required this.ticketDesc,
    required this.reply,
  });

  factory ComplaintDetailsApiModel.fromJson(Map<String, dynamic> json) =>
      ComplaintDetailsApiModel(
        ticketId: json['ticket_ID'] as String,
        ticketCode: json['ticket_Code'] as String,
        ticketType: json['ticket_Type'] as String,
        ticketDesc: json['ticket_Desc'] as String,
        reply: (json['reply'] as List<dynamic>?)
                ?.map((e) =>
                    ReplyComplaintApiModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

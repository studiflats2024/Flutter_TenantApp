import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/chat/chat_list/chat_item_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';

class ChatListWrapper extends Equatable {
  final List<ChatItemModel> data;
  final MetaModel pagingInfo;

  const ChatListWrapper({
    required this.data,
    required this.pagingInfo,
  });

  factory ChatListWrapper.fromJson(Map<String, dynamic> json) =>
      ChatListWrapper(
        pagingInfo: (json['totalRecords'] != null)
            ? MetaModel.fromJson(json)
            : MetaModel.getEmptyOne(),
        data: (json["data"] as List<dynamic>)
            .map((e) => ChatItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props {
    return [
      data,
    ];
  }
}

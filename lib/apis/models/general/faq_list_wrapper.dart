import 'package:equatable/equatable.dart';

// ApartmentDetailsWrapper
class FAQListWrapper extends Equatable {
  final List<FAQModel> data;

  const FAQListWrapper({
    required this.data,
  });

  factory FAQListWrapper.fromJson(List<dynamic>? json) => FAQListWrapper(
        data: json != null
            ? (json)
                .map((e) => FAQModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );

  @override
  List<Object?> get props {
    return [data];
  }
}

class FAQModel extends Equatable {
  final String faqID;
  final String faqQuest;
  final String faqAns;

  const FAQModel({
    required this.faqID,
    required this.faqQuest,
    required this.faqAns,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) => FAQModel(
        faqID: json['faq_ID'] as String,
        faqQuest: json['faq_Quest'] as String,
        faqAns: json['faq_Ans'] as String,
      );

  @override
  List<Object?> get props {
    return [
      faqID,
      faqQuest,
      faqAns,
    ];
  }
}

import 'package:equatable/equatable.dart';

class ReviewsUiModel extends Equatable {
  final String id;
  final String reviewDetails;
  final String reviewTime;
  final String reviewerName;
  final String reviewerImageUrl;
  static List<ReviewsUiModel> demo = List.generate(
    4,
    (index) => ReviewsUiModel(
        id: "$index",
        reviewDetails: "Excellent service ${index + 1}",
        reviewTime: "${index + 1} day ago",
        reviewerName: "Olivia Rhye",
        reviewerImageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6TY8anfEbPg1fGlapThKgplHRl65k2bOSDGPpz1YecqaWbQQhVEokqgIER8DkxgNdQnw&usqp=CAU"),
  );
  const ReviewsUiModel(
      {required this.id,
      required this.reviewDetails,
      required this.reviewTime,
      required this.reviewerName,
      required this.reviewerImageUrl});

  @override
  List<Object?> get props => [
        id,
        reviewDetails,
        reviewTime,
        reviewerName,
        reviewerImageUrl,
      ];
}

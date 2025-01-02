import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UnitUiModel extends Equatable {
  final String uuid;
  final String mainImageUrl;
  final String title;
  final double rate;
  final double price;
  final String location;
  final int roomNumber;
  final int personNumber;
  final double area;
  bool isWishlist;

  UnitUiModel({
    required this.uuid,
    required this.mainImageUrl,
    required this.title,
    required this.isWishlist,
    required this.rate,
    required this.price,
    required this.location,
    required this.roomNumber,
    required this.personNumber,
    required this.area,
  });

  @override
  List<Object?> get props => [uuid];

  static List<UnitUiModel> demoList = [
    demo,
    demo2,
  ];
  static UnitUiModel demo = UnitUiModel(
      uuid: "1",
      mainImageUrl:
          "https://www.bankrate.com/2022/10/26085712/net-effective-rate.jpg?auto=webp&optimize=high&crop=16:9",
      title: "The Aston Vill Hotel",
      isWishlist: true,
      area: 100,
      location: "Alice Springs NT 0870, Germany",
      personNumber: 4,
      price: 2150,
      rate: 5,
      roomNumber: 2);
  static UnitUiModel demo2 = UnitUiModel(
    uuid: "2",
    mainImageUrl:
        "https://images1.cityfeet.com/i2/XvGbVSPc0O7tkzQpL_B_IgtFLJfn51hnob24HLBdnHY/117/image.jpg",
    title: "The Vill Hotel",
    isWishlist: false,
    area: 200,
    location: "Alice NT 0870, Germany",
    personNumber: 3,
    price: 3200,
    rate: 3,
    roomNumber: 3,
  );
}

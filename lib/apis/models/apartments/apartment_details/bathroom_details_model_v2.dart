class BathroomDetail {
  String? bathroomName;
  List<String>? bathroomDetails;

  BathroomDetail({
    this.bathroomName,
    this.bathroomDetails,
  });

  factory BathroomDetail.fromJson(Map<String, dynamic> json) => BathroomDetail(
    bathroomName: json["bathroom_Name"],
    bathroomDetails: json["bathroom_Details"] == null ? [] : List<String>.from(json["bathroom_Details"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "bathroom_Name": bathroomName,
    "bathroom_Details": bathroomDetails == null ? [] : List<dynamic>.from(bathroomDetails!.map((x) => x)),
  };
}
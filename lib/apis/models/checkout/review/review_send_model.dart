class ReviewSendModel {
  final String reqID;
  final int rateApartment;
  final int rateSafety;
  final int rateLocation;
  final int rateService;
  final int rateCleanliness;
  final int rateCommunication;
  final String reviewComment;

  ReviewSendModel(
      {required this.reqID,
      required this.rateApartment,
      required this.rateSafety,
      required this.rateLocation,
      required this.rateService,
      required this.rateCleanliness,
      required this.rateCommunication,
      required this.reviewComment});
  Map<String, dynamic> toMap() {
    return {
      'req_ID': reqID,
      'rate_Apartment': rateApartment,
      'rate_Safety': rateSafety,
      'rate_Location': rateLocation,
      'rate_Service': rateService,
      'rate_Cleanliness': rateCleanliness,
      'rate_Communication': rateCommunication,
      'review_Comment': reviewComment,
    };
  }
}

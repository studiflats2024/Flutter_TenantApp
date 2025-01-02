class ProblemDetailsApiModel {
  final String issueId;
  final String aptName;
  final String statusString;
  final String statusKey;
  final String nameRigel;
  final String phoneNo1;
  final String phoneNo2;
  final String issueDesc;
  final String? issueSolve;
  final List<String> issueImages;
  final List<IssueDate> issueDates;
  final String? newDate;
  final String? newTime;

  ProblemDetailsApiModel(
      {required this.issueId,
      required this.aptName,
      required this.statusString,
      required this.statusKey,
      required this.nameRigel,
      required this.phoneNo1,
      required this.phoneNo2,
      required this.issueDesc,
      required this.issueSolve,
      required this.issueImages,
      required this.issueDates,
      required this.newDate,
      required this.newTime});

  factory ProblemDetailsApiModel.fromJson(Map<String, dynamic> json) {
    return ProblemDetailsApiModel(
      issueId: json['issue_ID'] as String,
      aptName: json['apt_Name'] as String,
      statusString: json['status_String'] as String,
      statusKey: json['issue_Status'] as String,
      nameRigel: json['name_Ringell'] as String,
      phoneNo1: json['phoneNo1'] as String,
      phoneNo2: json['phoneNo2'] as String,
      issueDesc: json['issue_Desc'] as String,
      issueSolve: json['issue_Solve'] as String?,
      newDate: json['new_Date'] as String,
      newTime: json['new_Time'] as String?,
      issueImages: (json['issue_Images'] as List<dynamic>?)
              ?.map((e) => e["img_Url"].toString())
              .toList() ??
          [],
      issueDates: (json['issue_Appt'] as List<dynamic>?)
              ?.map((e) => IssueDate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class IssueDate {
  final String date;
  final String time;

  IssueDate({required this.date, required this.time});

  factory IssueDate.fromJson(Map<String, dynamic> json) => IssueDate(
        date: json['appo_Date'] as String,
        time: json['appo_Time'] as String,
      );
}

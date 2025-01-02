// ignore: file_names
class IssueCheckouts {
  String? issueCode;
  String? issueDesc;
  double? issueCost;
  List<String>? issueImg;

  IssueCheckouts(
      {this.issueCode, this.issueDesc, this.issueCost, this.issueImg});

  IssueCheckouts.fromJson(Map<String, dynamic> json) {
    issueCode = json['issue_Code'];
    issueDesc = json['issue_Desc'];
    issueCost = json['issue_Cost'].toDouble();
    issueImg = json['issue_Img'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['issue_Code'] = this.issueCode;
    data['issue_Desc'] = this.issueDesc;
    data['issue_Cost'] = this.issueCost;
    data['issue_Img'] = this.issueImg;
    return data;
  }
}

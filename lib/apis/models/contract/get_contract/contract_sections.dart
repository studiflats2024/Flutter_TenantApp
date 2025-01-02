class ContractSections {
  final String secName;
  final String secDesc;

  ContractSections({required this.secName, required this.secDesc});

  factory ContractSections.fromJson(Map<String, dynamic> json) =>
      ContractSections(
          secName: json['sec_Name'] as String,
          secDesc: json['sec_Desc'] as String);

  Map<String, dynamic> toJson() => {'sec_Name': secName, 'sec_Desc': secDesc};
}

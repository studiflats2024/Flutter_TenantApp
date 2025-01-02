import 'package:vivas/apis/models/contract/get_contract/contract_sections.dart';

class GetContractResponse {
  final String reqID;
  final String rCLandLord;
  final String rCTenant;
  final String rCStartRent;
  final String rCEndRent;
  final double rCRentPrice;
  final double rCRentDeposit;
  final List<ContractSections> contractSections;

  GetContractResponse(
      {required this.reqID,
      required this.rCLandLord,
      required this.rCTenant,
      required this.rCStartRent,
      required this.rCEndRent,
      required this.rCRentPrice,
      required this.rCRentDeposit,
      required this.contractSections});

  factory GetContractResponse.fromJson(dynamic json) => GetContractResponse(
      reqID: json['req_ID'] as String,
      rCLandLord: json['rC_LandLord'] as String,
      rCTenant: json['rC_Tenant'] as String,
      rCStartRent: json['rC_StartRent'] as String,
      rCEndRent: json['rC_EndRent'] as String,
      rCRentPrice: json['rC_RentPrice'] as double,
      rCRentDeposit: json['rC_RentDeposit'] as double,
      contractSections: json['rC_Sections'] != null
          ? (json['rC_Sections'] as List<dynamic>)
              .map((e) => ContractSections.fromJson(e as Map<String, dynamic>))
              .toList()
          : []);

  Map<String, dynamic> toJson() => {
        'req_ID': reqID,
        'rC_LandLord': rCLandLord,
        'rC_Tenant': rCTenant,
        'rC_StartRent': rCStartRent,
        'rC_EndRent': rCEndRent,
        'rC_RentPrice': rCRentPrice,
        'rC_RentDeposit': rCRentDeposit,
        'rC_Sections': contractSections.map((v) => v.toJson()).toList()
      };
}

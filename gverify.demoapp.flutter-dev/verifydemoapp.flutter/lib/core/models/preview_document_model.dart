import 'dart:io';

class PreviewDocumentModel {
  final String? typeDocument; // Bạn có thể thay đổi thành enum nếu có sẵn
  final String? businessName;
  final RepresentativeModel? representativeModel;
  final String? textType;
  final String? address;
  final String? placeOfIssue;
  final String? signer;
  final String? taxcode;
  final String? phoneNumber;

  PreviewDocumentModel({
    this.typeDocument,
    this.businessName,
    this.representativeModel,
    this.textType,
    this.address,
    this.placeOfIssue,
    this.signer,
    this.taxcode,
    this.phoneNumber,
  });

  factory PreviewDocumentModel.fromJson(Map<String, dynamic> json) {
    return Platform.isAndroid ? PreviewDocumentModel(
      typeDocument: json['typeDocument'] as String?,
      businessName: json['businessName'] as String?,
      representativeModel: json['representativeModel'] != null
          ? RepresentativeModel.fromJson(json['representativeModel'])
          : null,
      textType: json['textType'] as String?,
      address: json['address'] as String?,
      placeOfIssue: json['placeOfIssue'] as String?,
      signer: json['signer'] as String?,
      taxcode: json['taxcode'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    ) : PreviewDocumentModel(
      typeDocument: json['type_document'] as String?,
      businessName: json['business_name'] as String?,
      representativeModel: json['representative_model'] != null
          ? RepresentativeModel.fromJson(json['representative_model'])
          : null,
      textType: json['text_type'] as String?,
      address: json['address'] as String?,
      placeOfIssue: json['place_of_issue'] as String?,
      signer: json['signer'] as String?,
      taxcode: json['taxcode'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'typeDocument': typeDocument,
    'businessName': businessName,
    'representativeModel': representativeModel?.toJson(),
    'textType': textType,
    'address': address,
    'placeOfIssue': placeOfIssue,
    'signer': signer,
    'taxcode': taxcode,
    'phoneNumber': phoneNumber,
  };

  @override
  String toString() {
    return 'PreviewDocumentModel(typeDocument: $typeDocument, businessName: $businessName, representativeModel: $representativeModel, textType: $textType, address: $address, placeOfIssue: $placeOfIssue, signer: $signer, taxcode: $taxcode, phoneNumber: $phoneNumber)';
  }
}

class RepresentativeModel {
  final String? eId;
  final String? fullName;
  final String? dateOfBirth;
  final String? dateOfIssue;
  final String? address;
  final String? nationality;
  final String? ethnicity;
  final String? gender;

  RepresentativeModel({
    this.eId,
    this.fullName,
    this.dateOfBirth,
    this.dateOfIssue,
    this.address,
    this.nationality,
    this.ethnicity,
    this.gender,
  });

  factory RepresentativeModel.fromJson(Map<String, dynamic> json) {
    return Platform.isAndroid ? RepresentativeModel(
      eId: json['eId'] as String?,
      fullName: json['fullName'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      dateOfIssue: json['dateOfIssue'] as String?,
      address: json['address'] as String?,
      nationality: json['nationality'] as String?,
      ethnicity: json['ethnicity'] as String?,
      gender: json['gender'] as String?,
    ) : RepresentativeModel(
      eId: json['id'] as String?,
      fullName: json['name'] as String?,
      dateOfBirth: json['dob'] as String?,
      dateOfIssue: json['document_issue_date'] as String?,
      address: json['address'] as String?,
      nationality: json['nationality'] as String?,
      ethnicity: json['ethnicity'] as String?,
      gender: json['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'eId': eId,
    'fullName': fullName,
    'dateOfBirth': dateOfBirth,
    'dateOfIssue': dateOfIssue,
    'address': address,
    'nationality': nationality,
    'ethnicity': ethnicity,
    'gender': gender,
  };

  @override
  String toString() {
    return 'RepresentativeModel(eId: $eId, fullName: $fullName, dateOfBirth: $dateOfBirth, dateOfIssue: $dateOfIssue, address: $address, nationality: $nationality, ethnicity: $ethnicity, gender: $gender)';
  }
}


class TaxCodeVerifyResponse{
  String? status;
  bool isTaxCodeValid;
  String? taxCode;
  String? phoneNumber;
  String? name;
  String? businessStatus;
  String? companyAddress;
  String? companyRepresentativeId;
  String? companyRepresentative;

  TaxCodeVerifyResponse({
    this.status,
    this.isTaxCodeValid = false,
    this.taxCode,
    this.phoneNumber,
    this.name,
    this.businessStatus,
    this.companyAddress,
    this.companyRepresentative,
    this.companyRepresentativeId
  });
  factory TaxCodeVerifyResponse.fromJson(Map<String, dynamic> json) {
    return Platform.isAndroid ? TaxCodeVerifyResponse(
      status: json['status'],
      taxCode: json['taxCode'],
      isTaxCodeValid: json['isTaxCodeValid'],
      phoneNumber: json['phoneNumber'] ,
      name: json['name'] ,
      businessStatus: json['businessStatus'] ,
      companyAddress: json['companyAddress'],
      companyRepresentativeId: json['companyRepresentativeId'] ,
      companyRepresentative: json['companyRepresentative'],
    ) : TaxCodeVerifyResponse(
      status: json['status'],
      taxCode: json['tax_code'],
      isTaxCodeValid: json['is_tax_code_valid'],
      phoneNumber: json['phone_number'] ,
      name: json['name'] ,
      businessStatus: json['business_status'] ,
      companyAddress: json['company_address'],
      companyRepresentativeId: json['company_representative_id'] ,
      companyRepresentative: json['company_representative'],
    );
  }

}

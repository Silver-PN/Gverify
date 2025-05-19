import 'package:json_annotation/json_annotation.dart';

part 'verify_ocr_response_model.g.dart';

@JsonSerializable()
class VerifyOCRResponseModel {
  String? transactionCode;
  String? fullName;
  String? surName;
  String? givenName;
  String? personNumber;
  String? passportNumber;
  String? dateOfExpiry;
  String? gender;
  String? placeOfOrigin;
  String? placeOfResidence;
  String? issuedAt;
  String? dateOfIssue;
  String? nationality;
  String? dateOfBirth;
  String? frontType;
  bool? frontValid;
  String? backType;
  bool? backValid;
  String? identificationSign;
  double? personNumberConfidence;
  double? fullNameConfidence;
  double? dateOfBirthConfidence;
  double? genderConfidence;
  double? nationalityConfidence;
  double? placeOfOriginConfidence;
  double? placeOfResidenceConfidence;
  double? dateOfExpiryConfidence;
  double? identificationSignConfidence;
  double? dateOfIssueConfidence;
  String? addressDistrict;
  String? addressTown;
  String? addressWard;
  String? hometownDistrict;
  String? hometownTown;
  String? hometownWard;
  String? addressDistrictDigitCode;
  String? addressTownDigitCode;
  String? addressWardDigitCode;
  String? hometownDistrictDigitCode;
  String? hometownTownDigitCode;
  String? hometownWardDigitCode;
  String? addressDistrictAreaCode;
  String? addressTownAreaCode;
  String? addressWardAreaCode;
  String? hometownDistrictAreaCode;
  String? hometownTownAreaCode;
  String? hometownWardAreaCode;
  String? frontInvalidCode;
  String? backInvalidCode;
  String? frontInvalidMessage;
  String? backInvalidMessage;

  VerifyOCRResponseModel({
    this.transactionCode,
    this.fullName,
    this.surName,
    this.givenName,
    this.personNumber,
    this.passportNumber,
    this.dateOfExpiry,
    this.gender,
    this.placeOfOrigin,
    this.placeOfResidence,
    this.issuedAt,
    this.dateOfIssue,
    this.nationality,
    this.dateOfBirth,
    this.frontType,
    this.frontValid,
    this.backType,
    this.backValid,
    this.identificationSign,
    this.personNumberConfidence,
    this.fullNameConfidence,
    this.dateOfBirthConfidence,
    this.genderConfidence,
    this.nationalityConfidence,
    this.placeOfOriginConfidence,
    this.placeOfResidenceConfidence,
    this.dateOfExpiryConfidence,
    this.identificationSignConfidence,
    this.dateOfIssueConfidence,
    this.addressDistrict,
    this.addressTown,
    this.addressWard,
    this.hometownDistrict,
    this.hometownTown,
    this.hometownWard,
    this.addressDistrictDigitCode,
    this.addressTownDigitCode,
    this.addressWardDigitCode,
    this.hometownDistrictDigitCode,
    this.hometownTownDigitCode,
    this.hometownWardDigitCode,
    this.addressDistrictAreaCode,
    this.addressTownAreaCode,
    this.addressWardAreaCode,
    this.hometownDistrictAreaCode,
    this.hometownTownAreaCode,
    this.hometownWardAreaCode,
    this.frontInvalidCode,
    this.backInvalidCode,
    this.frontInvalidMessage,
    this.backInvalidMessage,
  });

  factory VerifyOCRResponseModel.fromJson(Map<String, dynamic> json) => _$VerifyOCRResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOCRResponseModelToJson(this);

  @override
  String toString() {
    return 'VerifyOCRResponseModel{transactionCode: $transactionCode, fullName: $fullName, surName: $surName, givenName: $givenName, personNumber: $personNumber, passportNumber: $passportNumber, dateOfExpiry: $dateOfExpiry, gender: $gender, placeOfOrigin: $placeOfOrigin, placeOfResidence: $placeOfResidence, issuedAt: $issuedAt, dateOfIssue: $dateOfIssue, nationality: $nationality, dateOfBirth: $dateOfBirth, frontType: $frontType, frontValid: $frontValid, backType: $backType, backValid: $backValid, identificationSign: $identificationSign, personNumberConfidence: $personNumberConfidence, fullNameConfidence: $fullNameConfidence, dateOfBirthConfidence: $dateOfBirthConfidence, genderConfidence: $genderConfidence, nationalityConfidence: $nationalityConfidence, placeOfOriginConfidence: $placeOfOriginConfidence, placeOfResidenceConfidence: $placeOfResidenceConfidence, dateOfExpiryConfidence: $dateOfExpiryConfidence, identificationSignConfidence: $identificationSignConfidence, dateOfIssueConfidence: $dateOfIssueConfidence, addressDistrict: $addressDistrict, addressTown: $addressTown, addressWard: $addressWard, hometownDistrict: $hometownDistrict, hometownTown: $hometownTown, hometownWard: $hometownWard, addressDistrictDigitCode: $addressDistrictDigitCode, addressTownDigitCode: $addressTownDigitCode, addressWardDigitCode: $addressWardDigitCode, hometownDistrictDigitCode: $hometownDistrictDigitCode, hometownTownDigitCode: $hometownTownDigitCode, hometownWardDigitCode: $hometownWardDigitCode, addressDistrictAreaCode: $addressDistrictAreaCode, addressTownAreaCode: $addressTownAreaCode, addressWardAreaCode: $addressWardAreaCode, hometownDistrictAreaCode: $hometownDistrictAreaCode, hometownTownAreaCode: $hometownTownAreaCode, hometownWardAreaCode: $hometownWardAreaCode, frontInvalidCode: $frontInvalidCode, backInvalidCode: $backInvalidCode, frontInvalidMessage: $frontInvalidMessage, backInvalidMessage: $backInvalidMessage}';
  }
}

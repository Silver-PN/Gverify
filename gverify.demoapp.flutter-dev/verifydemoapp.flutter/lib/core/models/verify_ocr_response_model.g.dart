// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_ocr_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOCRResponseModel _$VerifyOCRResponseModelFromJson(
        Map<String, dynamic> json) =>
    VerifyOCRResponseModel(
      transactionCode: json['transactionCode'] as String?,
      fullName: json['fullName'] as String?,
      surName: json['surName'] as String?,
      givenName: json['givenName'] as String?,
      personNumber: json['personNumber'] as String?,
      passportNumber: json['passportNumber'] as String?,
      dateOfExpiry: json['dateOfExpiry'] as String?,
      gender: json['gender'] as String?,
      placeOfOrigin: json['placeOfOrigin'] as String?,
      placeOfResidence: json['placeOfResidence'] as String?,
      issuedAt: json['issuedAt'] as String?,
      dateOfIssue: json['dateOfIssue'] as String?,
      nationality: json['nationality'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      frontType: json['frontType'] as String?,
      frontValid: json['frontValid'] as bool?,
      backType: json['backType'] as String?,
      backValid: json['backValid'] as bool?,
      identificationSign: json['identificationSign'] as String?,
      personNumberConfidence:
          (json['personNumberConfidence'] as num?)?.toDouble(),
      fullNameConfidence: (json['fullNameConfidence'] as num?)?.toDouble(),
      dateOfBirthConfidence:
          (json['dateOfBirthConfidence'] as num?)?.toDouble(),
      genderConfidence: (json['genderConfidence'] as num?)?.toDouble(),
      nationalityConfidence:
          (json['nationalityConfidence'] as num?)?.toDouble(),
      placeOfOriginConfidence:
          (json['placeOfOriginConfidence'] as num?)?.toDouble(),
      placeOfResidenceConfidence:
          (json['placeOfResidenceConfidence'] as num?)?.toDouble(),
      dateOfExpiryConfidence:
          (json['dateOfExpiryConfidence'] as num?)?.toDouble(),
      identificationSignConfidence:
          (json['identificationSignConfidence'] as num?)?.toDouble(),
      dateOfIssueConfidence:
          (json['dateOfIssueConfidence'] as num?)?.toDouble(),
      addressDistrict: json['addressDistrict'] as String?,
      addressTown: json['addressTown'] as String?,
      addressWard: json['addressWard'] as String?,
      hometownDistrict: json['hometownDistrict'] as String?,
      hometownTown: json['hometownTown'] as String?,
      hometownWard: json['hometownWard'] as String?,
      addressDistrictDigitCode: json['addressDistrictDigitCode'] as String?,
      addressTownDigitCode: json['addressTownDigitCode'] as String?,
      addressWardDigitCode: json['addressWardDigitCode'] as String?,
      hometownDistrictDigitCode: json['hometownDistrictDigitCode'] as String?,
      hometownTownDigitCode: json['hometownTownDigitCode'] as String?,
      hometownWardDigitCode: json['hometownWardDigitCode'] as String?,
      addressDistrictAreaCode: json['addressDistrictAreaCode'] as String?,
      addressTownAreaCode: json['addressTownAreaCode'] as String?,
      addressWardAreaCode: json['addressWardAreaCode'] as String?,
      hometownDistrictAreaCode: json['hometownDistrictAreaCode'] as String?,
      hometownTownAreaCode: json['hometownTownAreaCode'] as String?,
      hometownWardAreaCode: json['hometownWardAreaCode'] as String?,
      frontInvalidCode: json['frontInvalidCode'] as String?,
      backInvalidCode: json['backInvalidCode'] as String?,
      frontInvalidMessage: json['frontInvalidMessage'] as String?,
      backInvalidMessage: json['backInvalidMessage'] as String?,
    );

Map<String, dynamic> _$VerifyOCRResponseModelToJson(
        VerifyOCRResponseModel instance) =>
    <String, dynamic>{
      'transactionCode': instance.transactionCode,
      'fullName': instance.fullName,
      'surName': instance.surName,
      'givenName': instance.givenName,
      'personNumber': instance.personNumber,
      'passportNumber': instance.passportNumber,
      'dateOfExpiry': instance.dateOfExpiry,
      'gender': instance.gender,
      'placeOfOrigin': instance.placeOfOrigin,
      'placeOfResidence': instance.placeOfResidence,
      'issuedAt': instance.issuedAt,
      'dateOfIssue': instance.dateOfIssue,
      'nationality': instance.nationality,
      'dateOfBirth': instance.dateOfBirth,
      'frontType': instance.frontType,
      'frontValid': instance.frontValid,
      'backType': instance.backType,
      'backValid': instance.backValid,
      'identificationSign': instance.identificationSign,
      'personNumberConfidence': instance.personNumberConfidence,
      'fullNameConfidence': instance.fullNameConfidence,
      'dateOfBirthConfidence': instance.dateOfBirthConfidence,
      'genderConfidence': instance.genderConfidence,
      'nationalityConfidence': instance.nationalityConfidence,
      'placeOfOriginConfidence': instance.placeOfOriginConfidence,
      'placeOfResidenceConfidence': instance.placeOfResidenceConfidence,
      'dateOfExpiryConfidence': instance.dateOfExpiryConfidence,
      'identificationSignConfidence': instance.identificationSignConfidence,
      'dateOfIssueConfidence': instance.dateOfIssueConfidence,
      'addressDistrict': instance.addressDistrict,
      'addressTown': instance.addressTown,
      'addressWard': instance.addressWard,
      'hometownDistrict': instance.hometownDistrict,
      'hometownTown': instance.hometownTown,
      'hometownWard': instance.hometownWard,
      'addressDistrictDigitCode': instance.addressDistrictDigitCode,
      'addressTownDigitCode': instance.addressTownDigitCode,
      'addressWardDigitCode': instance.addressWardDigitCode,
      'hometownDistrictDigitCode': instance.hometownDistrictDigitCode,
      'hometownTownDigitCode': instance.hometownTownDigitCode,
      'hometownWardDigitCode': instance.hometownWardDigitCode,
      'addressDistrictAreaCode': instance.addressDistrictAreaCode,
      'addressTownAreaCode': instance.addressTownAreaCode,
      'addressWardAreaCode': instance.addressWardAreaCode,
      'hometownDistrictAreaCode': instance.hometownDistrictAreaCode,
      'hometownTownAreaCode': instance.hometownTownAreaCode,
      'hometownWardAreaCode': instance.hometownWardAreaCode,
      'frontInvalidCode': instance.frontInvalidCode,
      'backInvalidCode': instance.backInvalidCode,
      'frontInvalidMessage': instance.frontInvalidMessage,
      'backInvalidMessage': instance.backInvalidMessage,
    };

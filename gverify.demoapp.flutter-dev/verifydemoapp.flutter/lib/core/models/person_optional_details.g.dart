// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_optional_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonOptionalDetails _$PersonOptionalDetailsFromJson(
        Map<String, dynamic> json) =>
    PersonOptionalDetails(
      eidNumber: json['eidNumber'] as String?,
      fullName: json['fullName'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      dateOfExpiry: json['dateOfExpiry'] as String?,
      dateOfIssue: json['dateOfIssue'] as String?,
      ethnicity: json['ethnicity'] as String?,
      fatherName: json['fatherName'] as String?,
      gender: json['gender'] as String?,
      motherName: json['motherName'] as String?,
      nationality: json['nationality'] as String?,
      personalIdentification: json['personalIdentification'] as String?,
      placeOfOrigin: json['placeOfOrigin'] as String?,
      placeOfResidence: json['placeOfResidence'] as String?,
      religion: json['religion'] as String?,
      spouseName: json['spouseName'] as String?,
      oldEidNumber: json['oldEidNumber'] as String?,
      unkInfo:
          (json['unkInfo'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PersonOptionalDetailsToJson(
        PersonOptionalDetails instance) =>
    <String, dynamic>{
      'eidNumber': instance.eidNumber,
      'fullName': instance.fullName,
      'dateOfBirth': instance.dateOfBirth,
      'dateOfExpiry': instance.dateOfExpiry,
      'dateOfIssue': instance.dateOfIssue,
      'ethnicity': instance.ethnicity,
      'fatherName': instance.fatherName,
      'gender': instance.gender,
      'motherName': instance.motherName,
      'nationality': instance.nationality,
      'personalIdentification': instance.personalIdentification,
      'placeOfOrigin': instance.placeOfOrigin,
      'placeOfResidence': instance.placeOfResidence,
      'religion': instance.religion,
      'spouseName': instance.spouseName,
      'oldEidNumber': instance.oldEidNumber,
      'unkInfo': instance.unkInfo,
    };

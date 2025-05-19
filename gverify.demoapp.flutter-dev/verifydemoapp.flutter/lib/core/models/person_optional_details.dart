import 'package:json_annotation/json_annotation.dart';

part 'person_optional_details.g.dart';
@JsonSerializable()
class PersonOptionalDetails {
  String? eidNumber;
  String? fullName;
  String? dateOfBirth;
  String? dateOfExpiry;
  String? dateOfIssue;
  String? ethnicity;
  String? fatherName;
  String? gender;
  String? motherName;
  String? nationality;
  String? personalIdentification;
  String? placeOfOrigin;
  String? placeOfResidence;
  String? religion;
  String? spouseName;
  String? oldEidNumber;
  List<String>? unkInfo;



  // Constructor
  PersonOptionalDetails({
    this.eidNumber,
    this.fullName,
    this.dateOfBirth,
    this.dateOfExpiry,
    this.dateOfIssue,
    this.ethnicity,
    this.fatherName,
    this.gender,
    this.motherName,
    this.nationality,
    this.personalIdentification,
    this.placeOfOrigin,
    this.placeOfResidence,
    this.religion,
    this.spouseName,
    this.oldEidNumber,
    this.unkInfo,
  });

  // fromJson factory method
  factory PersonOptionalDetails.fromJson(Map<String, dynamic> json) =>
      _$PersonOptionalDetailsFromJson(json);

  // toJson method
  Map<String, dynamic> toJson() => _$PersonOptionalDetailsToJson(this);

}

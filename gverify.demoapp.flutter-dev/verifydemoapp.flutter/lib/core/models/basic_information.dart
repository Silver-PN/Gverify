
class BasicInformation{
  String? eidNumber;
  String? oldEidNumber;
  String? fullName;
  String? dateOfBirth;
  String? gender;
  String? placeOfResidence;
  String? dateOfIssue;
  String? fatherName;
  String? motherName;

  BasicInformation();

  Map<String, dynamic> toMap() {
    return {
      "eidNumber": eidNumber ?? "",
      "oldEidNumber": oldEidNumber ?? "",
      "fullName": fullName ?? "",
      "dateOfBirth": dateOfBirth ?? "",
      "gender": gender ?? "",
      "placeOfResidence": placeOfResidence ?? "",
      "dateOfIssue": dateOfIssue ?? "",
      "fatherName": fatherName ?? "",
      "motherName": motherName ?? "",
    };
  }

  factory BasicInformation.fromJson(Map<String, dynamic> json) {
    var basicInfo = BasicInformation()
    ..eidNumber = json['eidNumber']
    ..oldEidNumber = json['oldEidNumber']
    ..fullName = json['fullName']
    ..dateOfBirth = json['dateOfBirth']
    ..gender = json['gender']
    ..placeOfResidence = json['placeOfResidence']
    ..dateOfIssue = json['dateOfIssue']
    ..fatherName = json['fatherName']
    ..motherName = json['motherName'];
    return basicInfo;
  }

}
class MrzInfo {
  String documentNumber;
  String dateOfBirth;
  String dateOfExpiry;

  MrzInfo(
      {required this.documentNumber,
      required this.dateOfBirth,
      required this.dateOfExpiry});

  factory MrzInfo.fromJson(Map<String, dynamic> json) {
    return MrzInfo(
        documentNumber: json['documentNumber'],
        dateOfBirth: json['dateOfBirth'],
        dateOfExpiry: json['dateOfExpiry']);
  }

  Map<String, dynamic> toMap() {
    return {
      "documentNumber": documentNumber,
      "dateOfBirth": dateOfBirth,
      "dateOfExpiry": dateOfExpiry,
    };
  }


  @override
  String toString() {
    return 'MrzInfo{documentNumber: $documentNumber, dateOfBirth: $dateOfBirth, dateOfExpiry: $dateOfExpiry}';
  }
}

class VerificationStatus {
  bool? chipAuthenticationStatus = false;
  bool? passiveAuthenticationStatus = false;
  bool? activeAuthenticationStatus = false;
  bool? isValidIdCard = false;

  VerificationStatus({
    required this.chipAuthenticationStatus,
    required this.passiveAuthenticationStatus,
    required this.activeAuthenticationStatus,
    required this.isValidIdCard,

  });

   factory VerificationStatus.fromJson(Map<String, dynamic> json) {
    return VerificationStatus(
        chipAuthenticationStatus: json['chipAuthenticationStatus'],
        passiveAuthenticationStatus: json['passiveAuthenticationStatus'],
        activeAuthenticationStatus: json['activeAuthenticationStatus'],
        isValidIdCard: json['isValidIdCard'],
    );
  }

  @override
  String toString() {
    return 'VerificationStatus{chipAuthenticationStatus: $chipAuthenticationStatus, passiveAuthenticationStatus: $passiveAuthenticationStatus, activeAuthenticationStatus: $activeAuthenticationStatus, isValidIdCard: $isValidIdCard,}';
  }
}

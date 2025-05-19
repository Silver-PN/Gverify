

enum OnboardStatus{
  PENDING(1),
  RAR_VERIFIED(2),
  BIOMETRIC_VERIFIED(3),
  ONBOARD_COMPLETED(4),
  INACTIVE(-1),
  UNKNOWN(0);

  final int code;

  const OnboardStatus(this.code);

  static OnboardStatus fromCode(int? code) {
    return OnboardStatus.values.firstWhere(
          (status) => status.code == code,
      orElse: () => OnboardStatus.UNKNOWN,
    );
  }
}
import 'dart:core';

import '../models/onboarding_status.dart';
import '../models/person_optional_details.dart';
import '../models/verification_status.dart';
import '../models/verify_ocr_response_model.dart';


class OnboardManager {
  static final OnboardManager _instance = OnboardManager._internal();

  static OnboardManager get instance => _instance;
  late BusinessType businessType;

  OnboardManager._internal();

  factory OnboardManager() {
    return _instance;
  }

  PersonOptionalDetails? personOptionalDetails;
  VerificationStatus? verificationStatus;
  String? referenceFaceImagePath = "";
  String? liveFaceImagePath;
  bool? isFaceMatch;
  bool? isValidIdCard;

  VerifyOCRResponseModel? verifyOCRResponseModel;
  String? imageFrontPath;
  String? imageBackPath;



  OnboardStatus? bioCurrentStatus;


  bool isAuthCard() {
    return verificationStatus?.chipAuthenticationStatus == true &&
        verificationStatus?.passiveAuthenticationStatus == true &&
        verificationStatus?.activeAuthenticationStatus == true;
  }
}

enum BusinessType {
  VERIFY_EID,
  VERIFY_EID_ACTIVE_EKYC,
  VERIFY_EID_SIMPLE_EKYC,
  VERIFY_EID_PASSIVE_EKYC,
  VERIFY_BANK_TRANSFER,
  VERIFY_OCR,
  VERIFY_EKYB,
}

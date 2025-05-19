import 'package:flutter/material.dart';

enum DocumentType {
  DKKD_DN, // business_certificate
  DKKD_CN, // branch_registration_certificate
  DKKD_HKD // business_household
}

extension DocumentTypeExtension on DocumentType {

  /// Mô phỏng getLocalized(context)
  String getLocalized() {
    switch (this) {
      case DocumentType.DKKD_DN:
        return 'Đăng ký kinh doanh - Doanh nghiệp';
      case DocumentType.DKKD_CN:
        return 'Đăng ký kinh doanh - Chi nhánh';
      case DocumentType.DKKD_HKD:
        return 'Đăng ký kinh doanh - Hộ kinh doanh';
    }
  }

  /// Mô phỏng companion object - reference(type: String)
  static DocumentType reference(String type) {
    switch (type) {
      case 'business_certificate':
        return DocumentType.DKKD_DN;
      case 'branch_registration_certificate':
        return DocumentType.DKKD_CN;
      case 'business_household':
        return DocumentType.DKKD_HKD;
      default:
        return DocumentType.DKKD_DN;
    }
  }
}

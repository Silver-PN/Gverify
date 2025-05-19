import 'package:flutter/material.dart';




class AppRouters{
  static const String mainPage = '/';

  static const  String scanMrzView = "/scanMrzView";
  static const  String scanNfcView = "/scanNfcView";
  static const String importMrzView = "/importMrzView";
  static const String livenessView = "/livenessView";
  static const String scanQrcode = "/scanQrcode";
  static const String verifyEkycSuccess = "/verify_ekyc_success";

  //EID
  static const String verifyEid = "/verifyEid";
  static const String verifyEidSuccess = '/verifyEid/success';
  
  //BIO
  static const String introBiometric = "/biometric";
  
  //Full Ekyc
  static const String verifyActiveEkycMain = '/verifyActiveEkycMain';

  //Simple Ekyc
  static const String simpleVerifyEkyc = '/simple-verify-ekyc';

  //Simple Ekyb
  static const String verifyEkyb = '/simple-verify-ekyb';
  static const String ekybDocumentResult = '/ekyb-document-result';
  static const String verifyEkybSuccess = '/ekyb-verify-success';


  //OCR
  static const String captureOcr = "/captureOcr";
  static const String verifyingOcrView = "/verifyingOcrView";
  static const String ocrInfoScreen ="/ocrInfoScreen";
  static const String ocrFaceMatchingScreen ="/ocrFaceMatchingScreen";
  static const String ocrVerifySuccessScreen ="/ocrVerifySuccessScreen";

  //Bio-2345
  static const String bio2345Main = "/bio2345Main";
  static const String bioVerifyOtp = "/bioVerifyOtp";
  static const String bioOnboardSuccess = "/bioOnboardSuccess";
  static const String transactionSuccess = "/transactionSuccess";
  static const String bioTransferCreate = "/bioTransferCreate";




}
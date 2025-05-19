import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';

import '../../../channels/native_channel_manager.dart';
import '../../../core/manager/onboard_mananger.dart';
import '../../../core/models/basic_information.dart';
import '../../../core/models/mrz_info_model.dart';
import '../../../core/models/person_optional_details.dart';
import '../../../core/models/verification_status.dart';
import '../intro_screen.dart';


enum NfcState { start, finish, verifyingWithRar, error, idle }

class NfcController extends GetxController {
  var appState = NfcState.idle.obs;
  var nativeMessage = ''.obs;
  var  isShowBtnScan = true.obs;

  Future<void> requestStartSessionNfc(ScanMethod method, dynamic data) async {
    isShowBtnScan.value = false;
    appState.value = NfcState.idle;
    final selectMethod;
    var model;
    if (method == ScanMethod.MRZ) {
      selectMethod = "MRZ";
      model = (data as MrzInfo).toMap();
    } else {
      selectMethod = "QRCODE";
      model = (data as BasicInformation).toMap();
    }
    Map<String, dynamic> map = {
      "method": selectMethod!,
      "data": model,
    };
    platform.invokeMethod(VERIFY_EID_METHOD, map);
    _observerDataNative();
  }


  // Because EKYC and Bio_2345 need verify NFC with RAR , but different endpoint api
  //And result from native. You need to handle 2 case
  void _observerDataNative() {
    platform.setMethodCallHandler((caller) async {
      try {
        Map<dynamic, dynamic>? result =
        caller.arguments as Map<dynamic, dynamic>?;

        if (caller.method == ON_START_SESSION_NFC) {
          //Start NFC
          appState.value = NfcState.start;
        }
        else if (caller.method == ON_VERIFYING_EID_WITH_RAR) {
          appState.value = NfcState.verifyingWithRar;
        } else if (caller.method == ON_VERIFY_EID_SUCCESS) {
          if (result != null) {
            if (OnboardManager.instance.businessType ==
                BusinessType.VERIFY_BANK_TRANSFER) {
              _parserDataBioVerifyRar(result);
            } else {
              _parserDataEkycVerifyRar(result);
            }
          }else{
            Fluttertoast.showToast(msg: "An unknown error occurred.",backgroundColor: BrandColors.red);
          }
        } else if (caller.method == ON_ERROR_MESSAGE) {
          if (result != null) {
            String? mess = result['message'] as String?;
            Fluttertoast.showToast(msg: mess ?? "An unknown error occurred.",backgroundColor: BrandColors.red);
            nativeMessage.value = mess ?? "An unknown error occurred.";
            appState.value = NfcState.error;
            isShowBtnScan.value = true;
          }
        }
      } catch (e) {
        nativeMessage.value = "An error occurred during NFC session";
        appState.value = NfcState.error;
        isShowBtnScan.value = true;
        print("Error in startSessionNfc method call handler: $e");
      }
    });
  }

  Future<void> _parserDataEkycVerifyRar(Map<dynamic, dynamic> result) async {
    try {
      Map<String, dynamic> jsonDg13 =
      json.decode(result["personOptionalDetails"]);
      Map<String, dynamic> jsonVerificationStatus =
      json.decode(result["verificationStatus"]);
      OnboardManager.instance.personOptionalDetails =
          PersonOptionalDetails.fromJson(jsonDg13);
      OnboardManager.instance.verificationStatus =
          VerificationStatus.fromJson(jsonVerificationStatus);
      OnboardManager.instance.referenceFaceImagePath = result["faceImage"];
      Get.back(result:  OnboardManager.instance.personOptionalDetails);
    } catch (e) {
      print("Error: ${e.toString()}");
      nativeMessage.value = "An error occurred during verify rar";
      appState.value = NfcState.error;
    }
  }

  Future<void> _parserDataBioVerifyRar(Map<dynamic, dynamic> result) async {
    try {
      if (Platform.isAndroid) {
        OnboardManager.instance.personOptionalDetails =
            PersonOptionalDetails.fromJson(result.cast<String, dynamic>());
      } else {
        Map<String, dynamic> jsonDg13 =
        json.decode(result["personOptionalDetails"]);
        OnboardManager.instance.personOptionalDetails =
            PersonOptionalDetails.fromJson(jsonDg13);
      }
      Get.back(result:  OnboardManager.instance.personOptionalDetails);
    } catch (e) {
      print("Error _parserDataBioVerifyRar: ${e.toString()}");
      nativeMessage.value = "Error _parserDataBioVerifyRar";
      appState.value = NfcState.error;
    }
  }


  @override
  void onInit() {
    super.onInit();
    isShowBtnScan.value = true;
    appState = NfcState.idle.obs;
  }

}

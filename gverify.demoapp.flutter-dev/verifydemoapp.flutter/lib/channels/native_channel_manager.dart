
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xverifydemoapp/core/utils/utils.dart';

import '../core/manager/onboard_mananger.dart';




const platform = MethodChannel(CHANNEL_NAME);

const CHANNEL_NAME = 'APP_CHANNEL';
const ON_NONE_EVENT = "NONE";

//INIT
const SEND_ENV_METHOD = "SEND_ENV_METHOD";
const SEND_BUSINESS_TYPE = "SEND_BUSINESS_TYPE";
const SEND_DEVICE_ID = "SEND_DEVICE_ID";

//---------------------Event (from native)--------------------------------------
const ON_ERROR_MESSAGE = "ON_ERROR_MESSAGE";
const ON_SCAN_QR_CODE_SUCCESS = "ON_SCAN_QR_CODE_SUCCESS";
const ON_FINISH_MRZ = "ON_FINISH_MRZ";
const ON_START_SESSION_NFC = "ON_START_SESSION_NFC";
const ON_FINISH_NFC = "ON_FINISH_NFC";
const ON_VERIFY_EID_SUCCESS = "ON_VERIFY_EID_SUCCESS";
const ON_VERIFYING_EID_WITH_RAR = "ON_VERIFYING_EID_WITH_RAR";

const ON_PLAY_SOUND = "ON_PLAY_SOUND";
const ON_LIVENESS_SUCCESS = "ON_LIVENESS_SUCCESS";
const ON_STEP_LIVENESS = "ON_STEP_LIVENESS";
const ON_VERIFYING_FACE_LIVENESS = "ON_VERIFYING_FACE_LIVENESS";  //Verifying spoof or face
const ON_VERIFY_FACE_LIVENESS_FINISH = "ON_VERIFY_FACE_LIVENESS_FINISH";


//BIO
const ON_RESULT_CHECK_ONBOARDING_STATUS = "ON_RESULT_CHECK_ONBOARDING_STATUS";
const ON_BIO_VERIFY_OTP_SUCCESS = "ON_BIO_VERIFY_OTP_SUCCESS";
const ON_BIO_VERIFY_FACE_MATCHING_SUCCESS = "ON_BIO_VERIFY_FACE_MATCHING_SUCCESS";//Bio : Onboarding and transfer


//----------------------- REQUEST --------------------------------------------

//COMMON
const GET_CARD_TYPE = "GET_CARD_TYPE";
//Eid
const DECODE_MRZ_BY_PATH = "DECODE_MRZ_BY_PATH";
const VERIFY_EID_METHOD = "VERIFY_EID_METHOD";
const CANCEL_SESSION_NFC = "CANCEL_SESSION_NFC";

//EKYC
const VERIFY_EKYC_METHOD = "VERIFY_EKYC_METHOD";
const ON_FINISH_EKYC = "ON_FINISH_EKYC";



//OCR
const REQUEST_VERIFY_OCR = "REQUEST_VERIFY_OCR";
const ON_VERIFY_OCR_SUCCESS = "ON_VERIFY_OCR_SUCCESS";

//BIO-2345
const REQUEST_CHECK_ONBOARDING_STATE = "REQUEST_CHECK_ONBOARDING_STATE";
const REQUEST_VERIFY_FACE_BIOMETRIC = "REQUEST_VERIFY_FACE_BIOMETRIC";
const REQUEST_BIO_VERIFY_FACE_TRANSFER = "REQUEST_BIO_VERIFY_FACE_TRANSFER";
const REQUEST_BIO_VERIFY_OTP = "REQUEST_BIO_VERIFY_OTP";
const REQUEST_GET_DATA_ONBOARD_SUCCESS = "REQUEST_GET_DATA_ONBOARD_SUCCESS";
const REQUEST_GET_DATA_TRANSFER_SUCCESS = "REQUEST_GET_DATA_TRANSFER_SUCCESS";

//EKYB
const REQUEST_SCAN_EKYB = "REQUEST_SCAN_EKYB";
const VERIFY_TAX_CODE_ADVANCE = "VERIFY_TAX_CODE_ADVANCE";

//------------------------------ CALL NATIVE ---------------------- //

Future<void> sendEnvironmentVariablesToNative() async {
  try {
    await dotenv.load(fileName: ".env");

    Map<String, String> mapEnv = {};

    if (Platform.isAndroid) {
      mapEnv = {
        "API_BASE_URL": dotenv.env['API_BASE_URL']!,
        "API_BIO2345_BASE_URL": dotenv.env['API_BIO2345_BASE_URL']!,
        "API_KEY": dotenv.env['API_KEY']!,
        "CUSTOMER_CODE": dotenv.env['CUSTOMER_CODE']!,
      };
    } else if (Platform.isIOS) {
      mapEnv = {
        "API_BASE_URL": dotenv.env['IOS_API_BASE_URL']!,
        "API_BIO2345_BASE_URL": dotenv.env['IOS_API_BIO2345_BASE_URL']!,
        "API_KEY": dotenv.env['API_KEY']!,
        "CUSTOMER_CODE": dotenv.env['CUSTOMER_CODE']!,
      };
    }

    // Send variables to the native layer
    await platform.invokeMethod(SEND_ENV_METHOD, mapEnv);
  } catch (e) {
    print("Error: ${e.toString()}");
  }
}

Future<void> sendDeviceIdToNative() async{
  String deviceId = kReleaseMode? await Utils().getDeviceId():Utils().randomUuid();
  platform.invokeMethod(SEND_DEVICE_ID, {'deviceId': deviceId});

}

Future<void> sendBusinessTypeToNative() async{
  if(OnboardManager.instance.businessType == BusinessType.VERIFY_BANK_TRANSFER){
    await dotenv.load(fileName: ".env.test");
    Map<String, String> mapEnv = {};
    mapEnv = {
      "API_BASE_URL": dotenv.env['API_BASE_URL']!,
      "API_BIO2345_BASE_URL": dotenv.env['API_BIO2345_BASE_URL']!,
      "API_KEY": dotenv.env['API_KEY']!,
      "CUSTOMER_CODE": dotenv.env['CUSTOMER_CODE']!,
    };
    await platform.invokeMethod(SEND_ENV_METHOD, mapEnv);
  }else{
    sendEnvironmentVariablesToNative();
  }

  platform.invokeMethod(SEND_BUSINESS_TYPE, {"business": OnboardManager.instance.businessType.name});
}







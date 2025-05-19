import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xverifydemoapp/channels/native_channel_manager.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';

import '../../../core/manager/onboard_mananger.dart';
import '../../../core/models/ekyc_liveness_guide.dart';
import '../../../core/models/onboarding_status.dart';
import '../../bio2345/bio_verify_otp_screen.dart';
import '../../ekyb/verify_ekyb_success_view.dart';
import '../../ocr/verify_ocr_success_screen.dart';
import '../verify_ekyc_success_view.dart';



enum LivenessState {verifying, verifiedFinish, done ,ide}

class LivenessController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var appState = LivenessState.ide.obs;
  var isLoading = false.obs;
  List<String> actions = List.empty();
  late bool isRandomFace;
  late bool isVerifySpoof;
  RxString guide =
      "Giữ điện thoại cố định, đưa khuôn mặt của bạn vào khung hình và nhìn thẳng"
          .obs;


  @override
  void onInit() {
    guide.value = "Giữ điện thoại cố định, đưa khuôn mặt của bạn vào khung hình và nhìn thẳng";
    actions = [];
    isLoading.value = false;
    isRandomFace = true;
    isVerifySpoof = true;
    super.onInit();
  }


  ///You need to transmit steps[FACE_CENTER, SMILE, LEFT,...] and isRandom from SDK ,
  ///SDK will use actions and liveness
  Future<void> initCameraLiveness([String? fromPage]) async {
    Map<String, dynamic> args = {
      "isRandom": isRandomFace,
      "actions": actions,
      "verifySpoof": isVerifySpoof,
      "business": OnboardManager.instance.businessType.name
    };
    try {
      platform.invokeMethod(VERIFY_EKYC_METHOD, args);
      observe(fromPage);
    } on PlatformException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }


  ///Below are the callback functions from native for liveness
  ///ON_STEP_LIVENESS : current step to notification for user: ex: LOOK RIGHT, LOOK STRAIGHT,....
  ///ON_PLAY_SOUND: Play sound when handle finish once step
  ///ON_VERIFYING_FACE_LIVENESS: SDK verifying anti face spoof or verifying face center, face right, face left
  ///ON_VERIFY_FACE_LIVENESS_FINISH: SDK verified
  ///ON_LIVENESS_SUCCESS: finish all steps

  Future<void> observe([String? fromPage]) async{
    try {
      platform.setMethodCallHandler((caller) async {
        Map<dynamic, dynamic>? result = caller.arguments as Map<dynamic,
            dynamic>?;
        if (caller.method == ON_STEP_LIVENESS) {
          _guideLiveness(result);
        } else if (caller.method == ON_PLAY_SOUND) {
          playSound();
        }else if(caller.method == ON_VERIFYING_FACE_LIVENESS){
          isLoading.value = true;
          guide.value = "Đang xác thực khuôn mặt";
        }else if(caller.method == ON_VERIFY_FACE_LIVENESS_FINISH){
          isLoading.value = false;
        }else if(caller.method == ON_BIO_VERIFY_FACE_MATCHING_SUCCESS){
          Get.off(const BioVerifyOtpScreen());
        }
        else if(caller.method == ON_LIVENESS_SUCCESS){
          if (result != null) {
            bool isFaceMatch = result['isMatching'] != null ? result['isMatching'] as bool : false;
            bool isVerifyLiveness = result['isVerifyLiveness'] != null ? result['isVerifyLiveness'] as bool : false;
            String facePath = result['image'] ?? "";

            OnboardManager.instance.liveFaceImagePath = facePath;
            OnboardManager.instance.isFaceMatch = isFaceMatch;

            if (facePath.isEmpty) {
              Fluttertoast.showToast(msg: "Image path is missing", backgroundColor: BrandColors.failed);
              return;
            }
            if (OnboardManager.instance.businessType == BusinessType.VERIFY_BANK_TRANSFER) {
              _verifyFaceMatching(facePath);
            }else if(OnboardManager.instance.businessType == BusinessType.VERIFY_OCR){
              Get.off(const VerifyOcrSuccessScreen());
            }else if(OnboardManager.instance.businessType == BusinessType.VERIFY_EKYB){
              Get.off(VerifyEkybSuccessView());
            }
            else {
              Get.off(const VerifyEkycSuccessView());
            }
          } else {
            Fluttertoast.showToast(msg: "No data received from Native", backgroundColor: BrandColors.failed);
          }

        }
        else if (caller.method == ON_ERROR_MESSAGE) {
          isLoading.value = false;
          String? mess = result?['message'] as String?;
          print("LivenessScreen ERROR: $mess");
          Fluttertoast.showToast(msg:  mess ?? "Có lỗi xảy ra, thử lại sau",backgroundColor: BrandColors.failed);
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg:  "Có lỗi xảy ra, thử lại sau",backgroundColor: BrandColors.failed);
      print("LivenessScreen ERROR: ${e.toString()}");
    }
  }


  ///Receive step by step from native, then we need to display guide for users
  void _guideLiveness(Map<dynamic, dynamic>? result){
    if (result != null) {
      String step = result['step'] as String;
      for (var value in EkycLivenessGuide.values) {
        if (value.name == step) {
          guide.value = value.guide;
          break;
        }
      }
    }
  }


  Future<void> playSound() async {
    try {
      _audioPlayer.play(AssetSource("raw/sound_beep.wav"));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  //======================= BIO 2345 ===========================//
  Future<void> _verifyFaceMatching(String path) async {
    isLoading.value = true;
    guide.value = "Đang xác thực khuôn mặt";

    if (OnboardManager.instance.bioCurrentStatus ==
        OnboardStatus.ONBOARD_COMPLETED) {
      platform.invokeMethod(REQUEST_BIO_VERIFY_FACE_TRANSFER, {"path": path});
    } else {
      platform.invokeMethod(REQUEST_VERIFY_FACE_BIOMETRIC, {"path": path});
    }
  }



  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}

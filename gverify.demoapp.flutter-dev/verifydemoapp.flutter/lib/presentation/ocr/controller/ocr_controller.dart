
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';

import '../../../channels/native_channel_manager.dart';
import '../../../core/manager/onboard_mananger.dart';
import '../../../core/models/card_type_enums.dart';
import '../../../core/models/verify_ocr_response_model.dart';
import '../ocr_info_screen.dart';
import '../verifying_ocr_screen.dart';


class OcrController extends GetxController{

  String? image_front;
  String? image_back;


  @override
  void onInit() {
    image_front = null;
    image_back = null;
    super.onInit();
  }

  void captureImage(String imgFront, String imgBack){
    if(imgFront.isEmpty || imgBack.isEmpty){
      Fluttertoast.showToast(msg: "Image path is null");
      return;
    }
    image_back = imgBack;
    image_front = imgFront;
    Get.off(const VerifyingOcrScreen());
  }

  Future<void> verifyOcrImage() async{
    final Map<String,String> map = {
      "image_front": image_front!,
      "image_back" : image_back!
    };

    platform.invokeMethod(REQUEST_VERIFY_OCR,map);
    platform.setMethodCallHandler((caller) async {
      Map<dynamic, dynamic>? result =
      caller.arguments as Map<dynamic, dynamic>?;
      if (caller.method == ON_VERIFY_OCR_SUCCESS) {
        if (result != null) {
          OnboardManager.instance.verifyOCRResponseModel = VerifyOCRResponseModel.fromJson(result.cast<String,dynamic>());
          OnboardManager.instance.imageFrontPath = image_front;
          OnboardManager.instance.imageBackPath = image_back;

          String? typeCard = await _checkCardType();
          if(typeCard!=null){
            Get.off(OcrInfoScreen(typeCard: typeCard,),);
            // if(Get.arguments?['fromPage']!=null){
            //   Get.off(const OcrInfoScreen(), arguments: {"type_card": typeCard,"fromPage":Get.arguments?['fromPage']});
            // }else{
            //   Get.off(const OcrInfoScreen(), arguments: {"type_card": typeCard});
            // }
            // Navigator.pushNamed(context, AppRouter.ocrInfoScreen,
            //     arguments: {"type_card": typeCard});
          }
        }
      } else if (caller.method == ON_ERROR_MESSAGE) {
        String? mess = result?['message'] as String?;
        print("Fail: $mess");
        Fluttertoast.showToast(
            msg: "Mặt trước và mặt sau không cùng loại giấy tờ", backgroundColor: BrandColors.failed);
        Get.back();
      }
    });
  }

  Future<String?> _checkCardType() async{
    var typeCardFront = CardTypeEnums.getType(OnboardManager.instance.verifyOCRResponseModel?.frontType??"");
    var typeCardBack = CardTypeEnums.getType(OnboardManager.instance.verifyOCRResponseModel?.backType??"");

    if(OnboardManager.instance.verifyOCRResponseModel?.frontValid == false && OnboardManager.instance.verifyOCRResponseModel?.backValid == false){
      debugPrint("OCR Fail: Front-message: ${OnboardManager.instance.verifyOCRResponseModel?.frontInvalidMessage} - Back-message: ${OnboardManager.instance.verifyOCRResponseModel?.backInvalidMessage}");
      Fluttertoast.showToast(
          msg:"Hình ảnh không hợp lệ, Vui lòng thử lại sau", backgroundColor: BrandColors.failed);
      Get.back();
      return null;
    }

    if(typeCardFront == CardTypeEnums.PASSPORT.define || (typeCardFront == typeCardBack)){
      return typeCardFront;
    }else{
      Fluttertoast.showToast(
          msg:"Lỗi, Mặt trước và mặt sau không cùng loại giấy tờ", backgroundColor: BrandColors.failed);
      Get.back();
      return null;
    }

  }

}
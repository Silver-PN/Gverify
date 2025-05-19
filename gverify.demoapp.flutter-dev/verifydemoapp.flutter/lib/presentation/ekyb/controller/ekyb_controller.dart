
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xverifydemoapp/app_router.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/models/document_type.dart';
import 'package:xverifydemoapp/core/models/preview_document_model.dart';

import '../../../channels/native_channel_manager.dart';

class EkybController extends GetxController{

  PreviewDocumentModel? previewDocumentModel;
  DocumentType? documentType;
  TaxCodeVerifyResponse? taxCodeVerifyResponse;

  Future<void> requestScanDocuments(List<String> images, String documentType) async{
    if(images.isEmpty){
      Fluttertoast.showToast(msg: "Vui lòng chọn tài liệu và upload giấy tờ của bạn",backgroundColor: BrandColors.failed);
      return;
    }

    Map<String, dynamic> maps = {
      "filePaths": images,
      "documentType": documentType
    };

    try{
      EasyLoading.show(maskType:EasyLoadingMaskType.clear );
      final json = await platform.invokeMethod(REQUEST_SCAN_EKYB, maps);
      if(json == null) {
        Fluttertoast.showToast(
            msg: "Tài liệu không hợp lệ", backgroundColor: BrandColors.failed);
        return;
      }
      PreviewDocumentModel document = PreviewDocumentModel.fromJson(jsonDecode(json));
      previewDocumentModel = document;

      if(document.taxcode == null || document.taxcode?.isEmpty == true){
        Fluttertoast.showToast(msg: "Tài liệu không hợp lệ",backgroundColor: BrandColors.failed);
        return;
      }
      await verifyTaxCode(document.taxcode!);
    }catch(e){
      print("Fail ocrx: $e");
      Fluttertoast.showToast(msg: "Tài liệu không hợp lệ",backgroundColor: BrandColors.failed);
    }finally{
      EasyLoading.dismiss();
    }

  }


  Future<void> verifyTaxCode(String taxCode) async{
    final verifyTaxCode = await platform.invokeMethod(VERIFY_TAX_CODE_ADVANCE, {'taxCode' :taxCode});
    if(verifyTaxCode == null){
      Fluttertoast.showToast(
          msg: "Tài liệu không hợp lệ", backgroundColor: BrandColors.failed);
      return;
    }
    var jsonData = jsonDecode(verifyTaxCode!!);
    taxCodeVerifyResponse = TaxCodeVerifyResponse.fromJson(jsonData);
    Get.toNamed(AppRouters.ekybDocumentResult);
  }

}
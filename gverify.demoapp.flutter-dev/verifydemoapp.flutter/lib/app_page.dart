

import 'package:get/get.dart';
import 'package:xverifydemoapp/app_router.dart';
import 'package:xverifydemoapp/presentation/bio2345/binding/transfer_binding.dart';
import 'package:xverifydemoapp/presentation/bio2345/bio_2345_main_screen.dart';
import 'package:xverifydemoapp/presentation/comman/binding/nfc_binding.dart';
import 'package:xverifydemoapp/presentation/comman/mrz_scanner.dart';
import 'package:xverifydemoapp/presentation/comman/nfc_scanner.dart';
import 'package:xverifydemoapp/presentation/comman/qr_code_scanner.dart';
import 'package:xverifydemoapp/presentation/eid/verify_eid_main.dart';
import 'package:xverifydemoapp/presentation/eid/verify_eid_success_view.dart';
import 'package:xverifydemoapp/presentation/ekyb/ekyb_main_view.dart';
import 'package:xverifydemoapp/presentation/ekyb/ekyb_preview_document_view.dart';
import 'package:xverifydemoapp/presentation/ekyb/verify_ekyb_success_view.dart';
import 'package:xverifydemoapp/presentation/ekyc/binding/liveness_binding.dart';
import 'package:xverifydemoapp/presentation/ekyc/ekyc_main_view.dart';

import 'package:xverifydemoapp/presentation/ekyc/liveness_view.dart';
import 'package:xverifydemoapp/presentation/home/home_view.dart';
import 'package:xverifydemoapp/presentation/ocr/capture_ocr_screen.dart';

class AppPage{
  static List<GetPage> pages = [
    GetPage(name: AppRouters.mainPage, page: ()=> HomeView()),
    GetPage(name: AppRouters.verifyEid, page: ()=> VerifyEidMainPage()),
    GetPage(name: AppRouters.scanMrzView, page: ()=> MrzScanner()),
    GetPage(name: AppRouters.scanQrcode, page: ()=> QrCodeScanner()),
    GetPage(name: AppRouters.scanNfcView, page: ()=> NfcScanner(), binding: NfcBinding()),
    GetPage(name: AppRouters.livenessView, page: ()=> LivenessView(), binding: LivenessBinding()),
    GetPage(name: AppRouters.bio2345Main, page: ()=> Bio2345MainView(), binding: TransferBinding()),
    GetPage(name: AppRouters.verifyEidSuccess, page: ()=> VerifyEidSuccessScreen()),
    GetPage(name: AppRouters.verifyActiveEkycMain, page: ()=> EkycMainScreen()),
    GetPage(name: AppRouters.captureOcr, page: ()=> CaptureOcrScreen()),
    GetPage(name: AppRouters.verifyEkyb, page: ()=> EkybMainView()),
    GetPage(name: AppRouters.ekybDocumentResult, page: ()=> EkybPreviewDocumentView()),
    GetPage(name: AppRouters.verifyEkybSuccess, page: ()=> VerifyEkybSuccessView()),
  ];
}
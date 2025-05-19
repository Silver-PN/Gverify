import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';

import '../../channels/native_channel_manager.dart';
import '../../core/manager/onboard_mananger.dart';
import '../../core/models/basic_information.dart';
import '../widgets/camera_scanner.dart';
import '../widgets/custom_appbar.dart';



class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {

  @override
  Widget build(BuildContext context) {
    _obs();
    return Scaffold(
      appBar: const CustomAppbar(),
      backgroundColor: BrandColors.primary,
      body:  SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          width: 300,
                          height: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child:
                            AspectRatio(aspectRatio: 1, child: CameraScanner(viewType: "<camera_qr_view>")),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.asset(
                            Assets.icons.imageFrame.path,
                            fit: BoxFit.fill,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child:  Text(
                        "DÙNG CAMERA ĐỂ SCAN QR CODE - MÃ NẰM Ở MẶT TRƯỚC THẺ CCCD GẮN CHIP",
                        style: mediumTextStyle(14, Colors.white),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            )
          )),
    );
  }

  Future<void> _obs() async{
    try {
      platform.setMethodCallHandler((caller) async {
        Map<dynamic, dynamic>? result =
        caller.arguments as Map<dynamic, dynamic>?;
        if (caller.method == ON_SCAN_QR_CODE_SUCCESS) {
          if (result != null) {
            OnboardManager.instance.isValidIdCard=true;
            Map<String, dynamic> jsonValue = json.decode(result["basicInformation"]);
            BasicInformation info = BasicInformation.fromJson(jsonValue);
            Get.back(result:info);
          }
        }
      });
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }
}

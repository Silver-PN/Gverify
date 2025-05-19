
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import '../../generated/assets.gen.dart';
import '../../generated/fonts.gen.dart';
import 'controller/ocr_controller.dart';


class VerifyingOcrScreen extends StatelessWidget {

  const VerifyingOcrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OcrController ocrController = Get.find<OcrController>();
   ocrController.verifyOcrImage();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: BrandColors.primary,
            toolbarHeight: 80,
            // leading: const BackButton(
            //   color: AppColors.white,
            // ),
            automaticallyImplyLeading: false,
            title: Assets.icons.icLogoGtel.svg(height: 26, color: Colors.white),
            centerTitle: true,
          ),
          backgroundColor: BrandColors.primary,
          body: SafeArea(
            child:SizedBox(
              width: double.infinity,
              height: double.infinity,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Đang xác thực dữ liệu",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: FontFamily.googleSansMedium,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Lottie.asset(
                   Assets.raw.animationLoading,
                    width: 220,
                    height: 100,
                    fit: BoxFit.fitWidth,
                  )
                ],
              ),
            ),
          )),
    );
  }

}

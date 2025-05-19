

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xverifydemoapp/presentation/ocr/widget/ocr_verify_success_info.dart';

import '../../core/manager/onboard_mananger.dart';
import '../widgets/custom_button.dart';


class OcrVerifyInfoView extends StatelessWidget {
  bool? needPadding;
  OcrVerifyInfoView({this.needPadding,super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                            File(
                                OnboardManager.instance.imageFrontPath ?? ""),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                            File(OnboardManager.instance.imageBackPath ?? ""),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    OcrVerifySuccessInfoRow(
                        title: "Họ và tên",
                        content: OnboardManager
                            .instance.verifyOCRResponseModel?.fullName ??
                            ""),
                    OcrVerifySuccessInfoRow(
                        title: "Số CCCD",
                        content: OnboardManager
                            .instance.verifyOCRResponseModel?.personNumber ??
                            ""),
                    OcrVerifySuccessInfoRow(
                        title: "Ngày sinh",
                        content: OnboardManager
                            .instance.verifyOCRResponseModel?.dateOfBirth
                            ?.replaceAll("-", "/") ??
                            ""),
                    OcrVerifySuccessInfoRow(
                        title: "Ngày hết hạn",
                        content: OnboardManager
                            .instance.verifyOCRResponseModel?.dateOfExpiry ??
                            ""),
                    OcrVerifySuccessInfoRow(
                        title: "Nơi thường trú",
                        content: OnboardManager.instance.verifyOCRResponseModel
                            ?.placeOfResidence ??
                            ""),
                  ],
                ),
              ),
              Spacer(),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: CustomButton(onPressed: (){Navigator.popUntil(context, (route) => route.isFirst);}, content: "XONG"),)
            ],
          )
      ),
    );
  }
}

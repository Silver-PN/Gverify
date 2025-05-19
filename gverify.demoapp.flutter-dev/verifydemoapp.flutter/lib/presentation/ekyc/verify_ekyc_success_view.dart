import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:xverifydemoapp/presentation/ekyc/widget/info_ekyc_row.dart';

import '../../core/manager/onboard_mananger.dart';
import '../../generated/fonts.gen.dart';
import '../widgets/custom_button.dart';



class VerifyEkycSuccessView extends StatelessWidget {
  const VerifyEkycSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333545),
      body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Align(
                      alignment: Alignment.center,
                      child: OnboardManager.instance.isAuthCard()
                          ? Text(
                        "Xác thực thành công".toUpperCase(),
                        style: boldTextStyle(22, Colors.white),
                      )
                          : Text(
                        "Không thành công".toUpperCase(),
                        style: boldTextStyle(25, BrandColors.failed),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      (OnboardManager.instance.isAuthCard() == true &&
                          OnboardManager
                              .instance.verificationStatus?.isValidIdCard ==
                              true &&
                          OnboardManager.instance.isFaceMatch == true)
                          ? const Icon(
                        Icons.check_circle,
                        size: 40,
                        color: Colors.green,
                      )
                          :  Icon(
                        Icons.cancel,
                        size: 40,
                        color: BrandColors.failed,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 140,
                                width: 140,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(File(OnboardManager
                                      .instance.referenceFaceImagePath ??
                                      "")),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text("Ảnh gốc",
                                  style: TextStyle(
                                    fontFamily: FontFamily.googleSansMedium,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 140,
                                width: 140,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(File(OnboardManager
                                      .instance.liveFaceImagePath ??
                                      ""), fit: BoxFit.fitHeight),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text("Hiện tại",
                                  style: TextStyle(
                                    fontFamily: FontFamily.googleSansMedium,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                             Text(
                              "Thông tin cá nhân",
                              style: boldTextStyle(20, BrandColors.colorTextOnSecondary),
                            ),
                            InfoEkycRow(
                                title: "Số CCCD",
                                content: OnboardManager
                                    .instance.personOptionalDetails?.eidNumber),
                            InfoEkycRow(
                                title: "Họ và tên",
                                content: OnboardManager
                                    .instance.personOptionalDetails?.fullName),
                            InfoEkycRow(
                                title: "Ngày sinh",
                                content: OnboardManager
                                    .instance.personOptionalDetails?.dateOfBirth),
                            InfoEkycRow(
                                title: "Giới tính",
                                content: OnboardManager
                                    .instance.personOptionalDetails?.gender),
                            InfoEkycRow(
                                title: "Thường trú",
                                content: OnboardManager
                                    .instance.personOptionalDetails?.placeOfResidence),
                            InfoEkycRow(
                              title: "Toàn vẹn",
                              isSuccess: OnboardManager.instance.isAuthCard(),
                            ),
                            InfoEkycRow(
                              title: "Xác thực CCCD",
                              isSuccess: OnboardManager
                                  .instance.verificationStatus?.isValidIdCard,
                            ),
                            InfoEkycRow(
                                title: "Face Matching",
                                isSuccess: OnboardManager.instance.isFaceMatch),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CustomButton(onPressed: () {
                                Navigator.pop(context);
                              }, content: "Xong"),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:xverifydemoapp/app_router.dart';

import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';

import '../../core/models/steps_face.dart';
import '../../generated/fonts.gen.dart';



class TransferCreateScreen extends StatelessWidget {
  const TransferCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BrandColors.primary,
          toolbarHeight: 80,
          leading: const BackButton(color: Colors.white,),
          title: Assets.icons.icLogoGtel.svg(height: 26, color: Colors.white),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFF333545),
        body: SafeArea(child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust padding as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                       Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Thông tin người chuyển',
                            style: boldTextStyle(17, Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                           Text(
                            'Tài khoản nguồn:',
                            style: mediumTextStyle(13, BrandColors.grey),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white
                              ),
                              child:  Text(
                                '12345688888',
                                style: TextStyle(
                                  color: BrandColors.success,
                                  fontSize: 15.0,
                                  fontFamily: FontFamily.googleSansMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        children: [
                          Text(
                            'Số dư khả dụng:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.0,
                              fontFamily: FontFamily.googleSansMedium,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              '100,000,000 VND',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: FontFamily.googleSansMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        children: [
                          Icon(
                            Icons.supervisor_account,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Thông tin người hưởng',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white
                        ),
                        child:  Text(
                          'Ngân hàng Đầu tư và phát triển Việt Nam (BIDV)',
                          style: TextStyle(
                            color: BrandColors.success,
                            fontSize: 15.0,
                            fontFamily: FontFamily.googleSansMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white
                        ),
                        child:  Text(
                          '38380000888888',
                          style: TextStyle(
                            color: BrandColors.success,
                            fontSize: 15.0,
                            fontFamily: FontFamily.googleSansMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Row(
                        children: [
                          Text(
                            'Tên người hưởng thụ:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.0,
                              fontFamily: FontFamily.googleSansMedium,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              'NGUYEN VAN PHUC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: FontFamily.googleSansMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Row(
                        children: [
                          Icon(
                            Icons.notes,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Thông tin giao dịch',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                        ),
                        child:  Text(
                          '20,000,000 VND',
                          style: TextStyle(
                            color: BrandColors.success,
                            fontSize: 15.0,
                            fontFamily: FontFamily.googleSansMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                        ),
                        child:  Text(
                          'NGUYEN VAN PHUC chuyen tien',
                          style: TextStyle(
                            color: BrandColors.success,
                            fontSize: 15.0,
                            fontFamily: FontFamily.googleSansMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                        ),
                        child: const Text(
                          'Phí giao dịch người chuyển trả',
                          style: TextStyle(
                            color: BrandColors.success,
                            fontSize: 15.0,
                            fontFamily: FontFamily.googleSansMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Continue Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 46.0,
                child: ElevatedButton(
                  onPressed: () {
                    final List<String> actions = [
                      StepsFace.FACE_CENTER.name,
                      StepsFace.SMILE.name,
                    ];
                    Get.toNamed(AppRouters.livenessView, arguments: {"actions":actions,"isRandom":false});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 15.0),
                  ),
                  child: const Text('Tiếp tục', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
        )
    );
  }
}



import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../channels/native_channel_manager.dart';
import '../../core/manager/onboard_mananger.dart';
import '../../generated/fonts.gen.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';


class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(),
        backgroundColor: const Color(0xFF333545),
        body: FutureBuilder<Map<dynamic, dynamic>?>(
          future: _getDataFromNative(),
          builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!;
              String chipImageBase64 = data['chipImageBase64'] ?? '';
              String onboardImageBase64 = data['onboardImageBase64'] ?? '';
              Uint8List  chipImageBytes = const Base64Decoder().convert(chipImageBase64.replaceAll(RegExp(r'\s'), '').split(',').last) ;
              Uint8List onboardImageBytes = const Base64Decoder().convert(onboardImageBase64.replaceAll(RegExp(r'\s'), '').split(',').last) ;
              return SafeArea(child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'TRANSACTION SUCCESS',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.googleSansBold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            '20,000,000 VND',
                            style: TextStyle(
                              fontSize: 21,
                              fontFamily: FontFamily.googleSansBold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Hai mươi triệu đồng',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '15:15 - 10/09/2024',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow('Tài khoản hưởng thụ:', '38380000888888'),
                          _buildInfoRow('Tên người hưởng thụ:', 'NGUYEN VAN PHUC'),
                          _buildInfoRow('Mã giao dịch:', '88888888'),
                          _buildInfoRow('Ngân hàng:', 'BIDV - Ngân hàng Đầu tư và phát triển Việt Nam'),
                          _buildInfoRow('Số tiền:', '20,000,000 VND'),
                          _buildInfoRow('Nội dung:', 'NGUYEN VAN PHUC chuyen tien'),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: chipImageBytes != null
                                        ? Image.memory(chipImageBytes):const Placeholder(),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Hình chip",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: FontFamily.googleSansMedium,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: onboardImageBytes != null
                                        ? Image.memory(onboardImageBytes):const Placeholder(),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Hình onboard",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: FontFamily.googleSansMedium,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Image.file(File(OnboardManager.instance.liveFaceImagePath??"")),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Hiện tại",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: FontFamily.googleSansMedium,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                    child: CustomButton(onPressed: (){Navigator.of(context).popUntil((route) => route.isFirst);}, content: "TRANG CHỦ"),
                  )
                ],
              ),);
            }
            else {
              return const Center(child: Text('No data found'));
            }
          },
        )
    );
  }



  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110, // Thay thế @dimen/_110sdp
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: FontFamily.googleSansMedium,
                fontSize: 14, // @dimen/_11sdp
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: FontFamily.googleSansMedium,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<Map<dynamic, dynamic>?> _getDataFromNative() async{
    try {
      final Map<dynamic, dynamic>? result =
      await platform.invokeMethod(REQUEST_GET_DATA_TRANSFER_SUCCESS);
      return result;
    } catch (e) {
      print("Error in check onboarding state method call handler: $e");
      return null;
    }
  }
}

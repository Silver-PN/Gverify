
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';

import '../../core/constants/colors.dart';
import '../widgets/custom_button.dart';



enum ScanMethod { MRZ, QRCODE}

class IntroScreen extends StatefulWidget {
  final Function(ScanMethod) onOptionSelected;

  const IntroScreen({Key? key, required this.onOptionSelected}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 200,
              width: 200,
              child: Assets.icons.imgSplashEid.svg(width: 200, height: 200),
            ),
          ),
          const SizedBox(height: 12),
           Text(
            "Xác thực CCCD gắn chip",
            style:boldTextStyle(22, Colors.white),
          ),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Text(
              "Xác minh thông tin thật giả của CCCD gắn chip và tích hợp với dịch vụ xác thực của C06.\n\n"
                  "Bước 1: Xác minh toàn vẹn dữ liệu CA/PA/AA.\n"
                  "Bước 2: Xác thực với C06.\n"
                  "Bước 3: Hiển thị thông tin chủ thẻ.",
              style: mediumTextStyle(15, Colors.white),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: CustomButton(onPressed: _requestCameraPermission,content: "Tiếp tục",),
          ),
        ],
      ),
    );
  }

  void _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      _showRadioDialog(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quyền truy cập camera đã bị từ chối')),
      );
    }
  }

  void _showRadioDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Center(
                    child: Text(
                      "Lựa chọn hình thức",
                      style: boldTextStyle(18, BrandColors.colorTextOnSecondary),
                  ),
                   ),
                  const SizedBox(height: 10.0),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: RadioListTile<int>(
                      value: 1,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                        Navigator.of(context).pop();
                        _handleSelection(_selectedOption!);
                      },
                      title:  Text(
                        "Quét mã QRCODE",
                        style: regularTextStyle(14, BrandColors.colorTextOnSecondary),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: RadioListTile<int>(
                      value: 2,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                        Navigator.of(context).pop();
                        _handleSelection(_selectedOption!);
                      },
                      title:  Text(
                        "Quét chuỗi MRZ",
                        style: regularTextStyle(14, BrandColors.colorTextOnSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSelection(int selectedOption) {
    setState(() {
      _selectedOption = null;
    });
    if (selectedOption == 1) {
      widget.onOptionSelected(ScanMethod.QRCODE);
    } else {
      widget.onOptionSelected(ScanMethod.MRZ);
    }
  }
}



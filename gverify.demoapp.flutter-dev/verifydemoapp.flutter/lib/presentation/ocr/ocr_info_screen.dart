import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:xverifydemoapp/app_router.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:xverifydemoapp/presentation/ocr/widget/ocr_info_result_row.dart';

import '../../core/manager/onboard_mananger.dart';
import '../../core/models/basic_information.dart';
import '../../core/models/mrz_info_model.dart';
import '../../core/models/steps_face.dart';
import '../../generated/assets.gen.dart';
import '../comman/intro_screen.dart';
import '../widgets/custom_button.dart';
import 'controller/ocr_controller.dart';

class OcrInfoScreen extends StatefulWidget {
  String typeCard;
  OcrInfoScreen({required this.typeCard,super.key});

  @override
  State<OcrInfoScreen> createState() => _OcrInfoScreenState();
}

class _OcrInfoScreenState extends State<OcrInfoScreen> {
  late OcrController ocrController;
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.primary,
        toolbarHeight: 80,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Assets.icons.icLogoGtel.svg(height: 26, color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: BrandColors.primary,
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.only(left: 20,right: 20),
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
                OcrInfoResultRow(
                    title: "Loại giấy tờ",
                    content: widget.typeCard),
                OcrInfoResultRow(
                    title: "Họ và tên",
                    content: OnboardManager
                        .instance.verifyOCRResponseModel?.fullName ??
                        ""),
                OcrInfoResultRow(
                    title: "Số CCCD",
                    content: OnboardManager
                        .instance.verifyOCRResponseModel?.personNumber ??
                        ""),
                OcrInfoResultRow(
                    title: "Ngày sinh",
                    content: OnboardManager
                        .instance.verifyOCRResponseModel?.dateOfBirth
                        ?.replaceAll("-", "/") ??
                        ""),
                OcrInfoResultRow(
                    title: "Ngày hết hạn",
                    content: OnboardManager
                        .instance.verifyOCRResponseModel?.dateOfExpiry ??
                        ""),
                OcrInfoResultRow(
                    title: "Giới tính",
                    content: OnboardManager
                        .instance.verifyOCRResponseModel?.gender ??
                        ""),
                OcrInfoResultRow(
                    title: "Nơi thường trú",
                    content: OnboardManager.instance.verifyOCRResponseModel
                        ?.placeOfResidence ??
                        ""),

                const Spacer(),
                CustomButton(onPressed: _showRadioDialog, content: "Tiếp tục")
              ],
            )
        ),
      ),
    );
  }

  void _showRadioDialog() {
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




  Future<void> _handleSelection(int selectedOption)  async{
    setState(() {
      _selectedOption = null;
    });
    dynamic result;
    ScanMethod method = ScanMethod.MRZ;
    if (selectedOption == 1) {
      method = ScanMethod.QRCODE;
      result = await Navigator.pushNamed(
        context,
        AppRouters.scanQrcode,
      ) as BasicInformation?;
    } else {
      method = ScanMethod.MRZ;
      result = await Navigator.pushNamed(
        context,
        AppRouters.scanMrzView,
      ) as MrzInfo?;
    }

    if (!context.mounted) return;
    if (result != null) {
      final data = await Navigator.pushNamed(
        context,
        AppRouters.scanNfcView,
        arguments: {"method": method, "data": result},
      );
      if (!context.mounted) return;
      if (data != null) {
        final List<String> actions = [StepsFace.FACE_CENTER.name, StepsFace.SMILE.name];
        OnboardManager.instance.isValidIdCard=true;
        Get.toNamed(AppRouters.livenessView, arguments: {"actions":actions,"isRandom":false});
      }else{
        OnboardManager.instance.isValidIdCard=false;
      }
    }


  }

}
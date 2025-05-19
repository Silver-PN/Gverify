import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xverifydemoapp/app_router.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';

import '../../core/models/basic_information.dart';
import '../../core/models/mrz_info_model.dart';
import '../comman/intro_screen.dart';


class VerifyEidMainPage extends StatefulWidget {
  const VerifyEidMainPage({super.key});

  @override
  State<VerifyEidMainPage> createState() => _VerifyEidMainPageState();
}

class _VerifyEidMainPageState extends State<VerifyEidMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.primary,

        leading: const BackButton(
          color: Colors.white,
        ),
        title:Assets.icons.icLogoGtel.svg(height: 26, color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: BrandColors.primary,
      body: IntroScreen(onOptionSelected: _onOptionSelected),
    );
  }

  void _onOptionSelected(ScanMethod selectedOption) async {
    dynamic result;
    if (selectedOption == ScanMethod.MRZ) {
      result = await Get.toNamed(
        AppRouters.scanMrzView,
      ) as MrzInfo?;
    } else {
      result = await Get.toNamed(
        AppRouters.scanQrcode,
      ) as BasicInformation?;
    }
    if (!context.mounted) return;
    if (result != null) {
      final data = await Get.toNamed(
        AppRouters.scanNfcView,
        arguments: {
          "method": selectedOption,
          "data": result,
        },
      );

      if (!context.mounted) return;
      if (data != null) {
       Get.toNamed(AppRouters.verifyEidSuccess);
      }
    }
  }

}

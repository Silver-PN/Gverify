
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/manager/onboard_mananger.dart';

import '../../app_router.dart';
import '../../core/models/basic_information.dart';
import '../../core/models/mrz_info_model.dart';
import '../../core/models/steps_face.dart';
import '../comman/intro_screen.dart';
import '../widgets/custom_appbar.dart';


class EkycMainScreen extends StatefulWidget {
  EkycMainScreen({super.key});
  final List<String> actions = [
    StepsFace.FACE_CENTER.name,
    StepsFace.SMILE.name,
    StepsFace.RIGHT.name,
    StepsFace.LEFT.name
  ];

  final List<String> simpleActions = [
    StepsFace.FACE_CENTER.name,
    StepsFace.SMILE.name,
  ];

  @override
  State<EkycMainScreen> createState() => _EkycMainScreenState();
}

class _EkycMainScreenState extends State<EkycMainScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
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
      result =await Get.toNamed(
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
        if(OnboardManager.instance.businessType == BusinessType.VERIFY_EID_ACTIVE_EKYC){
          Get.toNamed(AppRouters.livenessView, arguments: {"actions":widget.actions});
        }else{
          Get.toNamed(AppRouters.livenessView, arguments: {"actions":widget.simpleActions});
        }
      }
    }
  }
}

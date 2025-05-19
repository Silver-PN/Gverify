

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import '../../app_router.dart';
import '../../core/manager/onboard_mananger.dart';
import '../../core/models/basic_information.dart';
import '../../core/models/mrz_info_model.dart';
import '../comman/intro_screen.dart';
import '../widgets/custom_appbar.dart';
import 'controller/transfer_controller.dart';

class Bio2345MainView extends GetView<TransferController> {
  const Bio2345MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(),
        backgroundColor: BrandColors.primary,
        body: Obx((){
          switch(controller.appState.value){
            case BioState.pending:
              return _buildView();
            case BioState.loading:
              return const Center(child: CircularProgressIndicator(),);
            default:
              return _buildView();
          }
        })
    );
  }

  Widget _buildView(){
    return IntroScreen(onOptionSelected: (option) => _onOptionSelected(option, Get.context!));
  }


  void _onOptionSelected(ScanMethod selectedOption, BuildContext context) async {
    dynamic result;
    if (selectedOption == ScanMethod.MRZ) {
      result = await Get.toNamed(AppRouters.scanMrzView) as MrzInfo?;
    } else {
      result = await Get.toNamed(AppRouters.scanQrcode) as BasicInformation?;
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
        controller.requestVerifyBiometric();
      }
    }
  }

}



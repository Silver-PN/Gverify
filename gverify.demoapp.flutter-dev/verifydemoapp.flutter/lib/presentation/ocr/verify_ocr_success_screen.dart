import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';

import '../widgets/custom_button.dart';
import 'ocr_result_eid_view.dart';
import 'ocr_result_ekyc_view.dart';
import 'ocr_verify_info_view.dart';


class VerifyOcrSuccessScreen extends StatelessWidget {
  const VerifyOcrSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: BrandColors.primary,
          toolbarHeight: 80,
          title: Assets.icons.icLogoGtel.svg(height: 26,color: Colors.white),
          centerTitle: true,
          bottom: const TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.green,
              tabs: [
                Tab(
                  text: "OCR",
                ),
                Tab(
                  text: "CCCD Chip",
                ),
                Tab(
                  text: "eKYC",
                )
              ]),
        ),
        backgroundColor: BrandColors.primary,
        body: TabBarView(
          children: [
            OcrVerifyInfoView(),
            OcrResultEidView(),
            OcrResultEkycView(),
          ],
        ),
      ),
    );
  }

  Widget body(BuildContext context){
    return Stack(
      children: [
        TabBarView(
          children: [
            OcrVerifyInfoView(),
            OcrResultEidView(),
            OcrResultEkycView(),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding:EdgeInsets.only(left: 20,right: 20),
              width: double.infinity,
              child: CustomButton(onPressed: (){Navigator.popUntil(context, (route) => route.isFirst);}, content: "XONG"),
            ),
          ),
        ),
      ],
    );
  }
}

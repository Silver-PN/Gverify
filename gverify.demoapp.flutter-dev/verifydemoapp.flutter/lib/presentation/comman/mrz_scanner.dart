
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:xverifydemoapp/app_router.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:get/get.dart';
import '../../channels/native_channel_manager.dart';
import '../../core/models/mrz_info_model.dart';
import '../../generated/assets.gen.dart';
import '../widgets/camera_scanner.dart';


class MrzScanner extends StatefulWidget {
  const MrzScanner({super.key});

  @override
  State<MrzScanner> createState() => _MrzScannerState();
}

class _MrzScannerState extends State<MrzScanner> {

  @override
  void initState() {
    try {
      platform.setMethodCallHandler((caller) async {
        Map<dynamic, dynamic>? result =
        caller.arguments as Map<dynamic, dynamic>?;
        if (caller.method == ON_FINISH_MRZ) {
          if (result != null) {
            Map<String, dynamic> jsonValue = json.decode(result["mrzInfo"]);
            MrzInfo mrz = MrzInfo.fromJson(jsonValue);
            Get.back(result: mrz);
          }
        }
      });
    } catch (e) {
      print("Error: ${e.toString()}");
    }
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.primary,
        toolbarHeight: 80,
        leading: const BackButton(
          color: Colors.white,
        ),
        title:Assets.icons.icLogoGtel.svg(height: 26, color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor:  BrandColors.primary,
      body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      width: 350,
                      height: 220,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child:
                        AspectRatio(aspectRatio: 1, child: CameraScanner(viewType: "<camera_mrz_view>")),
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      height: 220,
                      child: Image.asset(
                        "assets/icons/image_frame.png",
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child:  Text(
                      "DÙNG CAMERA ĐỂ SCAN MRZ CODE - CHUỖI KÝ TỰ MẶT SAU THẺ CCCD GẮN CHIP",
                      style: mediumTextStyle(14, Colors.white),
                      textAlign: TextAlign.center),
                ),
                const Spacer(),
                // Container(
                //   width: double.infinity,
                //   margin: const EdgeInsets.all(20),
                //   decoration: const BoxDecoration(
                //       color: AppColors.success,
                //       borderRadius: BorderRadius.all(Radius.circular(20))),
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //       useDecodeByImage();
                //     },
                //     child: const Text(
                //       "SỬ DỤNG THÊM CÁCH KHÁC",
                //       style: TextStyle(color: AppColors.white),
                //     ),
                //   ),
                // )
              ],
            ),
          )),
    );
  }

  Future<void> useDecodeByImage() async {
    final decode = await Navigator.pushNamed(
      context,
      AppRouters.importMrzView,
    );
    if (!context.mounted) return;
    if (decode != null) {
      // final data = await  Navigator.pushNamed(context, AppRouter.scanNfcView);
      // if(data!=null){
      //   Map<dynamic, dynamic> eid = data as Map<dynamic, dynamic>;
      //   _parseData(eid);
      // }
    }
  }

}


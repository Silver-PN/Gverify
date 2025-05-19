
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';

import '../widgets/camera_scanner.dart';
import 'controller/liveness_controller.dart';


class LivenessView extends StatefulWidget {


  const LivenessView({super.key});

  @override
  State<LivenessView> createState() => _LivenessViewState();
}

class _LivenessViewState extends State<LivenessView> {
  late LivenessController livenessController;
  dynamic args;


  @override
  void initState() {
    args = Get.arguments;
    livenessController =  Get.find<LivenessController>();
    livenessController.onInit();
    livenessController.actions = args['actions'];
    livenessController.isRandomFace = args['isRandom']??true;
    livenessController.initCameraLiveness();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BrandColors.primary,
          leading: const BackButton(
            color: Colors.white,
          ),
          title: Assets.icons.icLogoGtel.svg(height: 26, color: Colors.white),
          centerTitle: true,
        ),
        backgroundColor: BrandColors.primary,
        body: SafeArea(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                            width: 270,
                            height: 270,
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(270 / 2)),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: CameraScanner(
                                    viewType: "<camera_liveness_view>"),
                              ),
                            ),
                          ),
                          Container(
                            width: 270,
                            height: 270,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                          ),
                          Lottie.asset(
                           Assets.raw.faceIdLoader,
                            width: 320,
                            height: 320,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return Text(
                        livenessController.guide.value.toUpperCase(),
                        style: mediumTextStyle(16, Colors.white),
                        textAlign: TextAlign.center,
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return Visibility(
                        visible: livenessController.isLoading.value,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 150,
                            width: 250,
                            child: Lottie.asset(
                              Assets.raw.animationLoading,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ))));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

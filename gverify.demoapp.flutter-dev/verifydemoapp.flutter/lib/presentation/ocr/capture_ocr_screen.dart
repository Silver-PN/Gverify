
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';

import '../../generated/fonts.gen.dart';
import '../widgets/custom_button.dart';
import 'controller/ocr_controller.dart';



class CaptureOcrScreen extends StatefulWidget {
  const CaptureOcrScreen({super.key});

  @override
  State<CaptureOcrScreen> createState() => _CaptureOcrScreenState();
}

class _CaptureOcrScreenState extends State<CaptureOcrScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  CameraDescription? selectedCamera;
  late OcrController ocrController;

  String guide = "Chụp ảnh mặt trước CCCD/CMND";

  int currentRequestImage = 0;

  String? image_front;
  String? image_back;

  @override
  void initState() {
    ocrController = Get.put(OcrController());
    ocrController.onInit();
    guide = "Chụp ảnh mặt trước CCCD/CMND";
    currentRequestImage = 0;
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    selectedCamera = cameras?.first;

    controller = CameraController(
      selectedCamera!,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller?.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
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
        title: Assets.icons.icLogoGtel.svg(height: 26, color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: BrandColors.primary,
      body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    controller != null?
                    _cameraPreviewWidget(context):Container(),
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
                  child: Text(
                      currentRequestImage == 0
                          ? "Chụp ảnh mặt trước CCCD/CMND".toUpperCase()
                          : "Chụp ảnh mặt sau CCCD/CMND".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.googleSansMedium,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center),
                ),
                const Spacer(),
                CustomButton(onPressed: _takePicture, content: "CHỤP ẢNH")

              ],
            ),
          )),
    );
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget(BuildContext context) {
    return AspectRatio(
      aspectRatio: 10/6.3,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller!.value.previewSize != null ? controller!.value.previewSize!.height : MediaQuery.of(context).size.width,
            height: controller!.value.previewSize != null ? controller!.value.previewSize!.width : MediaQuery.of(context).size.width,

            child: CameraPreview(controller!),
          ),
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      final image = await controller!.takePicture();
      if (currentRequestImage == 0) {
        image_front = image.path;
        currentRequestImage++;
      } else {
        image_back = image.path;
        ocrController.captureImage(image_front ?? "", image_back ?? "");
        return;
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void deactivate() {

    super.deactivate();
  }
}

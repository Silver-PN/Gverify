import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../channels/native_channel_manager.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import 'controller/nfc_controller.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';

import 'intro_screen.dart';

class NfcScanner extends StatefulWidget {
  const NfcScanner({super.key});

  @override
  State<NfcScanner> createState() => _NfcScannerState();
}

class _NfcScannerState extends State<NfcScanner> with SingleTickerProviderStateMixin {
  late final dynamic args;
  late final NfcController nfcController;
  late final AnimationController _animationController;

  String displayText = "Đặt thẻ CCCD gắn chip đằng sau thiết bị và không di chuyển";

  @override
  void initState() {
    super.initState();

    args = Get.arguments;
    nfcController = Get.find<NfcController>();

    _animationController = AnimationController(vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    platform.invokeMethod(CANCEL_SESSION_NFC);
    _animationController.dispose();
    Get.delete<NfcController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      backgroundColor: BrandColors.primary,
      body: Obx(() {
        final state = nfcController.appState.value;

        switch (state) {
          case NfcState.start:
            displayText = "ĐANG XỬ LÝ DỮ LIỆU, GIỮ NGUYÊN THẺ VÀ KHÔNG DI CHUYỂN";
            _startAnimation();
            return _buildMainView();

          case NfcState.verifyingWithRar:
            return _buildVerifyingView();

          case NfcState.finish:
          case NfcState.error:
            _stopAnimation();
            return _buildMainView();
          default:
            _stopAnimation();
            return _buildMainView();
        }
      }),
    );
  }

  void _startAnimation() {
    if (!_animationController.isAnimating) {
      _animationController.forward();
    }
  }

  void _stopAnimation() {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
  }

  Widget _buildMainView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildLottieAnimation(Assets.raw.nfcAnimation),
            const SizedBox(height: 20),
            Text(
              displayText.toUpperCase(),
              style: mediumTextStyle(15, Colors.white),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Obx(() {
              return Visibility(
                visible: nfcController.isShowBtnScan.value,
                child: CustomButton(
                  onPressed: _sendInfoToNative,
                  content: "Bắt đầu",
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyingView() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Đang xác thực dữ liệu", style: mediumTextStyle(22, Colors.white)),
            const SizedBox(height: 20),
            _buildLottieAnimation(Assets.raw.animationLoading, height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildLottieAnimation(String assetPath, {double height = 250}) {
    return SizedBox(
      height: height,
      child: Lottie.asset(
        assetPath,
        controller: _animationController,
        onLoaded: (composition) {
          _animationController.duration = composition.duration;
        },
        fit: BoxFit.contain,
      ),
    );
  }

  Future<void> _sendInfoToNative() async {
    if (args == null) {
      debugPrint("❌ No arguments passed to this screen.");
      return;
    }

    final selectedOption = args['method'] as ScanMethod?;
    final result = args['data'];

    if (selectedOption != null && result != null) {
      nfcController.requestStartSessionNfc(selectedOption, result);
    } else {
      debugPrint("❌ Selected option or result is null");
    }
  }
}

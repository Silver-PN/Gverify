import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:xverifydemoapp/app_router.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';

import '../../channels/native_channel_manager.dart';
import '../../core/constants/colors.dart';
import '../../core/manager/onboard_mananger.dart';
import '../../core/models/onboarding_status.dart';
import '../../core/utils/local_notifications.dart';
import '../../core/utils/utils.dart';




class BioVerifyOtpScreen extends StatefulWidget {
  const BioVerifyOtpScreen({super.key});

  @override
  State<BioVerifyOtpScreen> createState() => _BioVerifyOtpScreenState();
}

class _BioVerifyOtpScreenState extends State<BioVerifyOtpScreen> {
  String otp = "";
  @override
  void initState() {
    initNotification();
    super.initState();
  }

  Future<void> initNotification() async {
    otp = Utils().generateOtp();
    print("Mã xác thực $otp");
    LocalNotifications.showSimpleNotification(
        title: "Mã xác thực",
        body: otp,
        payload: "Mã OTP xác thực giao dịch");
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 40,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.primary,
        toolbarHeight: 80,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: SvgPicture.asset(
          'assets/icons/ic_header_logo_new.svg',
          height: 26,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      backgroundColor: BrandColors.primary,
      body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20,),
               Text(
                "XÁC THỰC OTP GIAO DỊCH",
                style: boldTextStyle(16, Colors.white),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    height: 200,
                    width: 200,
                    child: SvgPicture.asset(
                      'assets/icons/img_otp.svg',
                      height: 200,
                      width: 200,
                    )),
              ),
              const SizedBox(height: 12),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.green),
                  ),
                ),
                onCompleted: (pin) => verifyOtp(pin),
              ),
            ],
          )),
    );
  }

  void verifyOtp(String pin){
    if(otp == pin){
      if(OnboardManager.instance.bioCurrentStatus == OnboardStatus.ONBOARD_COMPLETED){
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRouters.transactionSuccess);
        return;
      }
      platform.invokeMethod(REQUEST_BIO_VERIFY_OTP, {"code": otp});
      platform.setMethodCallHandler((caller) async {
        try{
          Map<dynamic, dynamic>? result = caller.arguments as Map<dynamic, dynamic>?;
          if(caller.method == ON_BIO_VERIFY_OTP_SUCCESS){
            if(result!=null){
              bool isSuccess = result["isSuccess"] as bool;
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouters.bioOnboardSuccess);
            }
          }else if(caller.method == ON_ERROR_MESSAGE){
            String? mess = result?['message'] as String?;
            Fluttertoast.showToast(
                msg: mess ?? "Có lỗi xảy ra", backgroundColor: BrandColors.failed);
          }
        }catch (e) {
          print("Error in check onboarding state method call handler: $e");
        }
      });
    }else{
      Fluttertoast.showToast(msg: "Mã OTP không chính xác", backgroundColor: BrandColors.failed);
    }
  }
}

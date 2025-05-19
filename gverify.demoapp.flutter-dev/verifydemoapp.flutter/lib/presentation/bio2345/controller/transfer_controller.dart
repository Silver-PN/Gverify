

import 'package:get/get.dart';
import 'package:xverifydemoapp/app_router.dart';
import '../../../channels/native_channel_manager.dart';
import '../../../core/manager/onboard_mananger.dart';
import '../../../core/models/onboarding_status.dart';
import '../../../core/models/steps_face.dart';
import '../bio_verify_otp_screen.dart';
import '../transfer_create_screen.dart';



enum BioState { pending, rarVerified, biometricVerified, onboardCompleted, loading, loaded }

class TransferController extends GetxController{
  var appState = BioState.loading.obs;
  final List<String> actions = [
    StepsFace.SMILE.name,
    StepsFace.FACE_CENTER.name
  ];


  @override
  void onInit() {
    super.onInit();
    print("onInit called");
    checkOnboardingState();
  }

  ///The first, you need to call api to check onboarding state [pending,rar_verify, biometric_verify,on_completed]
  /// We must get DeviceId
  Future<void> checkOnboardingState() async {
    platform.invokeMethod(REQUEST_CHECK_ONBOARDING_STATE);

    platform.setMethodCallHandler((caller) async {
      try{
        Map<dynamic, dynamic>? result = caller.arguments as Map<dynamic, dynamic>?;
        if(caller.method == ON_RESULT_CHECK_ONBOARDING_STATUS){
          if(result!=null){
            String? deviceUuid = result["deviceId"] as String?;
            int? onboardingState = result["onboardingState"] as int?;
            OnboardStatus status = OnboardStatus.fromCode(onboardingState);
            print("DeviceId = $deviceUuid - Status = ${status.name}");
            OnboardManager.instance.bioCurrentStatus = status;

            if(status == OnboardStatus.RAR_VERIFIED){
              Get.toNamed(AppRouters.livenessView, arguments: {"actions":actions,"isRandom":false});
            }else if(status == OnboardStatus.BIOMETRIC_VERIFIED){
              Get.to(const BioVerifyOtpScreen());
            }else if(status == OnboardStatus.ONBOARD_COMPLETED){
              Get.to(const TransferCreateScreen());
            }else{
              appState.value = BioState.pending;
            }
          }
        }else if(caller.method == ON_ERROR_MESSAGE){
          String? mess = result?['message'] as String?;

        }
      }catch (e) {
        print("Error in check onboarding state method call handler: $e");

      }
    });

  }


  void requestVerifyBiometric(){
    Get.toNamed(AppRouters.livenessView, arguments: {"actions":actions,"isRandom":false});
  }

}
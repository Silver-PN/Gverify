import 'package:get/get.dart';
import 'package:xverifydemoapp/presentation/ekyc/controller/liveness_controller.dart';


class LivenessBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LivenessController());
  }
}

import 'package:get/get.dart';
import 'package:xverifydemoapp/presentation/comman/controller/nfc_controller.dart';

class NfcBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NfcController());
  }
}
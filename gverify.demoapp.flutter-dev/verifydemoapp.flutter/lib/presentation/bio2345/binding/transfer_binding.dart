import 'package:get/get.dart';
import 'package:xverifydemoapp/presentation/bio2345/controller/transfer_controller.dart';


class TransferBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => TransferController());
  }
}
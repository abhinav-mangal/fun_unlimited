import 'package:fun_unlimited/app/controllers/about_controller/mychatprice_controller.dart';
import 'package:get/get.dart';

class MyChatPriceBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MyChatPriceController>(MyChatPriceController());
  }
}

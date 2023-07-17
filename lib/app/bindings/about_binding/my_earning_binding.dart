import 'package:fun_unlimited/app/controllers/about_controller/myearning_controller.dart';
import 'package:get/get.dart';

class MyEarningBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MyEarningController>(MyEarningController());
  }
}

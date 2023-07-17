import 'package:fun_unlimited/app/controllers/about_controller/mytask_controller.dart';
import 'package:get/get.dart';

class MyTaskBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MyTaskControoler>(MyTaskControoler());
  }
}

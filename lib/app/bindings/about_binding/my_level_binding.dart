import 'package:fun_unlimited/app/controllers/about_controller/mylavel_controller.dart';
import 'package:get/get.dart';

class MyLevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MylevelController>(MylevelController());
  }
}

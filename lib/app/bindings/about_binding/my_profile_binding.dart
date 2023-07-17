import 'package:fun_unlimited/app/controllers/about_controller/myprofile_controller.dart';
import 'package:get/get.dart';

class MyProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MyProfileController>(MyProfileController());
  }
}

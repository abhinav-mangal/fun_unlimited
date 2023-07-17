import 'package:fun_unlimited/app/controllers/login_controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  final controller = Get.put(LoginController());
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}

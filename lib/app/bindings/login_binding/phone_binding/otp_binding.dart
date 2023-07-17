import 'package:fun_unlimited/app/controllers/login_controllers/phon_controller/otp_controller.dart';
import 'package:get/get.dart';

class OTPBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<OTPControllr>(OTPControllr());
  }
}

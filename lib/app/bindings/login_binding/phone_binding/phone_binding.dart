import 'package:fun_unlimited/app/controllers/login_controllers/phon_controller/phone_controller.dart';
import 'package:get/get.dart';

class PhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PhoneController>(PhoneController());
  }
}

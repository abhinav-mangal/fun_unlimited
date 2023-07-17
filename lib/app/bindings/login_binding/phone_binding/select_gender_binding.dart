import 'package:fun_unlimited/app/controllers/login_controllers/phon_controller/select_gender_controller.dart';
import 'package:get/get.dart';

class SelectGenderBinding extends Bindings {
  final controller = Get.put(SelectGenderController());
  @override
  void dependencies() {
    Get.put<SelectGenderController>(SelectGenderController());
  }
}

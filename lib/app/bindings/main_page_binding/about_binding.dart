import 'package:fun_unlimited/app/controllers/mainpage_controller/about_controoler.dart';
import 'package:get/get.dart';

class AboutBinding extends Bindings {
  final controller = Get.put(AboutController());

  @override
  void dependencies() {
    Get.put<AboutController>(AboutController());
  }
}

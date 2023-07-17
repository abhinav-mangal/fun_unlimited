import 'package:fun_unlimited/app/controllers/mainpage_controller/globe_controller.dart';
import 'package:get/get.dart';

class GlobeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GlobeController>(GlobeController());
  }
}

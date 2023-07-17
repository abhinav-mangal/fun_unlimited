import 'package:fun_unlimited/app/controllers/mainpage_controller/mainpage_controller.dart';
import 'package:get/get.dart';

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainController>(MainController());
  }
}

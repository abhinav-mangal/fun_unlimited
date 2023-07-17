import 'package:fun_unlimited/app/controllers/mainpage_controller/tv_controller.dart';
import 'package:get/get.dart';

class TVBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TvController>(TvController());
  }
}

import 'package:fun_unlimited/app/controllers/mainpage_controller/video_controller.dart';
import 'package:get/get.dart';

class VideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<VideoController>(VideoController());
  }
}

import 'package:fun_unlimited/app/controllers/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  final controller = Get.put(SplashController());
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}

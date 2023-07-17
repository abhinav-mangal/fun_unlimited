import 'package:firebase_auth/firebase_auth.dart';
import 'package:fun_unlimited/app/controllers/UserController/user_controller.dart';
import 'package:fun_unlimited/app/views/login_views/login_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/mainpage_view.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    final userController = UserController();
    userController.getUser();
    Future.delayed(const Duration(seconds: 4), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.offAll(() => const LoginView());
      } else {
        Get.offAll(() => MainView());
      }
    });
  }
}

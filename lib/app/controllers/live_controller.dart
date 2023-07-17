import 'package:get/get.dart';

class LiveController extends GetxController {
  RxBool isLoading = true.obs;

  startStream() async {
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      isLoading.value = false;
    });
  }

  @override
  void onInit() {
    startStream();
    super.onInit();
  }

  @override
  void onClose() {}
}

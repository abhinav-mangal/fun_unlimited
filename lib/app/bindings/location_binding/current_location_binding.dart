import 'package:fun_unlimited/app/controllers/location_controller/Current_location_controller.dart';
import 'package:get/get.dart';

class CurrentLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CurrentLocationController>(CurrentLocationController());
  }
}

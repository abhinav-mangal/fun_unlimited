import 'package:fun_unlimited/app/controllers/language_controller/countrycode_controller.dart';
import 'package:get/get.dart';

class CountryCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CountryCodeController>(CountryCodeController());
  }
}

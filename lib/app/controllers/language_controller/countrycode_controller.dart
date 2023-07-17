import 'package:country_codes/country_codes.dart';
import 'package:get/get.dart';

class CountryCodeController extends GetxController {
  RxBool isLoading = false.obs;

  List<CountryDetails?> countrycodes = [];
  CountryDetails? selectedCountry;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async {
    isLoading(true);
    await CountryCodes.init();
    final data = CountryCodes.countryCodes();
    countrycodes = data;
    isLoading(false);
    update();
  }

  onselect(CountryDetails countryDetails) {
    selectedCountry = countryDetails;
    update();
  }
}

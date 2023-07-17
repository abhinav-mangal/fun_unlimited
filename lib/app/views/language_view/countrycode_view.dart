import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/language_controller/countrycode_controller.dart';
import 'package:get/get.dart';

class CountryCodeView extends GetView<CountryCodeController> {
  const CountryCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: CountryCodeController(),
      builder: (CountryCodeController controller) => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                title: const Center(
                  child: Text(
                    "Select",
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                ),
              ),
              body: ListView.builder(
                itemCount: controller.countrycodes.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.back(
                        result: controller.countrycodes[index],
                      );
                    },
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: grey,
                      trailing: Text(controller.countrycodes[index]!.name!),
                      leading: Text(controller.countrycodes[index]!.dialCode!),
                      textColor: Colors.white,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

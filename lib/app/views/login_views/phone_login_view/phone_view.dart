import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/login_controllers/phon_controller/phone_controller.dart';
import 'package:fun_unlimited/app/views/language_view/countrycode_view.dart';
import 'package:get/get.dart';

class PhoneView extends StatefulWidget {
  // static String verify = "";

  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  CountryDetails? countryDetails;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PhoneController(),
      builder: (controller) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ppurple1,
              ppurple2,
              ppurple3,
              ppurple4,
              ppurple5,
              ppurple6,
              ppurple7,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: trans,
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: Get.height * 0.2,
            ),
            child: Form(
              key: controller.globlekey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Hello",
                    style: TextStyle(
                      color: white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 50,
                    width: Get.width * 0.8,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Spurple6,
                    ),
                    child: Row(
                      children: [
                        countryDetails == null
                            ? const Center(
                                child: Text(
                                  "+91",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )
                            : Center(
                                child: Text(
                                  countryDetails!.dialCode!.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                        IconButton(
                          onPressed: () async {
                            final CountryDetails? data =
                                await Get.to(() => const CountryCodeView());
                            if (data != null) {
                              countryDetails = data;
                              setState(() {});
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 13,
                            color: white,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 2,
                          color: white,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            // child: TextFormField(
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return "Phone Number Field is Empty";
                            //     }
                            //     return null;
                            //   },)
                            child: TextField(
                              controller: controller.phonecontroller,
                              cursorColor: white,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // if (controller.globlekey.currentState!.validate()) {
                      //   controller.login();
                      // }
                      controller.register(controller.verification);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Spurple6,
                      ),
                      fixedSize: MaterialStateProperty.all(
                        Size(
                          Get.width * 0.8,
                          50,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            25,
                          ),
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

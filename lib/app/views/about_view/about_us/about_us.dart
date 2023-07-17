import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/views/delete_account/delete_account.dart';
import 'package:get/get.dart';

class AboutUsView extends GetView {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "About Us",
                  style: TextStyle(
                    color: black,
                    fontSize: 22,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: white,
                          border: Border.all(color: grey)),
                      child: const Center(
                        child: Image(
                          image: AssetImage("assets/pok.png"),
                          height: 60,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Fun Unlimited",
                      style: TextStyle(
                          color: black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Make Chat borderless",
                      style: TextStyle(color: black, fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const DeleteAccountView());
                      },
                      child: Container(
                        height: 45,
                        width: Get.width * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: white,
                          border: Border.all(color: purple),
                        ),
                        child: const Center(
                          child: Text(
                            "Delete Account",
                            style: TextStyle(color: purple),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Copyright @ 2023 - 2030 Fun Unlimited. All Rights Reserved",
                      style: TextStyle(
                        color: grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

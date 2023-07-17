import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/about_controller/setting_controller.dart';
import 'package:fun_unlimited/app/views/about_view/about_us/about_us.dart';
import 'package:fun_unlimited/app/views/about_view/block_list/block_list.dart';
import 'package:fun_unlimited/app/views/about_view/privacy/privecy_policy.dart';
import 'package:fun_unlimited/app/views/about_view/privacy/user_agreement.dart';
import 'package:fun_unlimited/app/views/login_views/login_view.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingView extends GetView<SettingsController> {
  @override
  final controller = Get.put(SettingsController());
  SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: const IconThemeData(
          color: black,
        ),
        title: const Center(
          child: Text(
            "Setting",
            style: TextStyle(
              color: black,
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              onTap: () {},
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: grey,
                size: 15,
              ),
              title: const Text(
                "App Language",
                style: TextStyle(
                  color: black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    onTap: () {
                      Get.to(() => const BlockListView());
                    },
                    title: const Text(
                      "Black List",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const PrivecyPolicyView());
                    },
                    title: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const UserAgreementView());
                    },
                    title: const Text(
                      "User Agreement",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const AboutUsView());
                    },
                    title: const Text(
                      "About Us",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: const Text(
                      "Rate Lafa",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const BlockListView());
                    },
                    title: const Text(
                      "Clear Cache",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: const Text(
                      "Version",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    trailing: const Text(
                      '3.2.2',
                      style: TextStyle(
                        color: grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: ListTile(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn.standard().signOut();
                        Get.offAll(() => const LoginView());
                      },
                      subtitle: const Center(
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            color: black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

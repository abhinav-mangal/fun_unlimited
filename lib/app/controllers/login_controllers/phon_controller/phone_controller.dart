import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/views/login_views/phone_login_view/otp_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhoneController extends GetxController {
  GlobalKey<FormState> globlekey = GlobalKey<FormState>();
  TextEditingController phonecontroller = TextEditingController();
  var userID = 0.obs;
  String verification = "";

  Future<bool> register(String phone) async {
    const url = "http://lafa.dousoftit.com/api/register";
    final response = await http.post(Uri.parse(url), body: {
      "phone": phone,
    });
    log(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 401) {
      final data = jsonDecode(response.body);

      if (data["status"] == false) {
        Get.snackbar(
          "Error",
          data["message"]["phone"][0],
          backgroundColor: white,
        );
        userID.value = data["data"]["user"]["id"];

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setInt("userID", userID.value);
        log(userID.toString());

        Get.to(() => OTPView());
        return true; // false;
      }
      return true;
    }
    return false;
  }

  void login() async {
    final response = await register(phonecontroller.text);

    if (response == false) {
      return;
    }
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${phonecontroller.text}',
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (firebaseAuthException) {},
        codeSent: (verificationId, int? resendingToken) {
          verification = verificationId;
          Get.to(() => OTPView());
        },
        codeAutoRetrievalTimeout: ((verificationId) {}),
      );
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }
}

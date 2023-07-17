import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/controllers/login_controllers/phon_controller/phone_controller.dart';
import 'package:fun_unlimited/app/views/login_views/phone_login_view/select_gender_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OTPControllr extends GetxController {
  String logins = "login";

  Future<bool> login(String loginscreen) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.get('userId');
    const url = "https://lafa.dousoftit.com/api/login";
    final response = await http.post(Uri.parse(url), body: {
      "user_id": userId,
      "loginscreen": loginscreen,
    });
    log(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 401) {
      final data = jsonDecode(response.body);
      log(data.toString());
      if (data["status"] == false) {
        Get.snackbar("Error", data.toString());
        return true;
      }
      return true;
    }
    return false;
  }

  RxBool isLoading = false.obs;

  TextEditingController otpcontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void next() async {
    final response = await login(logins);
    if (response == false) {
      return;
    }

    final phoncontroller = Get.find<PhoneController>();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: phoncontroller.verification,
        smsCode: otpcontroller.text);
    final data = await auth.signInWithCredential(credential);
    await saveUser(
      email: data.user!.phoneNumber!,
      name: "User3435",
      photo: null,
    );
    Get.to(() => const SelectGenderView());
  }

  Future<void> saveUser({
    required String email,
    required String name,
    required String? photo,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final firestore = await FirebaseFirestore.instance
        .collection("User")
        .where('uid', isEqualTo: uid)
        .get();
    if (firestore.docs.isEmpty) {
      await FirebaseFirestore.instance.collection("User").doc(uid).set({
        "name": name,
        "email": email,
        "photo": photo,
      }).then((value) {
        Get.to(() => const SelectGenderView());
      });
    }
  }
}

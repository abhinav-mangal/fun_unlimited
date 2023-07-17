import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/views/mainpage_views/mainpage_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DOBView extends StatefulWidget {
  const DOBView({super.key});

  @override
  State<DOBView> createState() => _DOBViewState();
}

class _DOBViewState extends State<DOBView> {
  String dateOfBirth = "";

  Future<bool> dob(dateOfBirth) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    const url = "http://lafa.dousoftit.com/api/register/dob";
    final response = await http.post(Uri.parse(url), body: {
      "user_id": userId,
      "dob": dateOfBirth,
    });
    log(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 401) {
      final data = jsonDecode(response.body);

      if (data["status"] == false) {
        Get.snackbar("Error", data.toString());
        return false;
      }
      return true;
    }
    return false;
  }

  saveDate() async {
    // final response = await dob(dateOfBirth);

    // if (response == false) {
    //   return;
    // }
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "dob": dateOfBirth,
    });
    Get.back();
    Get.offAll(() => MainView());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        body: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "My Birthday",
                style: TextStyle(
                  color: white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (DateTime newtime) {
                    setState(() {
                      dateOfBirth = newtime.toString();
                    });
                  },
                  mode: CupertinoDatePickerMode.date,
                  // initialDateTime: dateTime,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  saveDate();
                },
                child: Container(
                  height: 45,
                  width: Get.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: const Color.fromARGB(255, 67, 5, 78),
                  ),
                  child: const Center(
                    child: Text(
                      "Confirm",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Can't be changed after confirmation",
                style: TextStyle(
                  color: white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

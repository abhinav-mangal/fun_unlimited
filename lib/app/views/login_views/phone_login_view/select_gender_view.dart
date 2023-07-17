import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/views/login_views/phone_login_view/dateofbirth_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SelectGenderView extends StatefulWidget {
  const SelectGenderView({super.key});

  @override
  State<SelectGenderView> createState() => _SelectGenderViewState();
}

class _SelectGenderViewState extends State<SelectGenderView> {
  int? user;

  String gender = "Male";

  Future<bool> genders(String gender) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    const url = "http://lafa.dousoftit.com/api/register/gender";
    final response = await http.post(Uri.parse(url), body: {
      "user_id": userId,
      "gender": gender,
    });
    // log("clck");
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

  savegender() async {
    // final response = await genders(gender);

    // if (response == false) {
    //   return;
    // }
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "gender": gender,
    });
    Get.offAll(() => const DOBView());
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
                "My Gender",
                style: TextStyle(
                  color: white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender = "Male";
                      });
                    },
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/male.png',
                            height: gender == "Male" ? 120 : 100,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Male",
                          style: TextStyle(
                            color: white,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender = "Female";
                      });
                    },
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/female.png',
                            height: gender == "Female" ? 120 : 100,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Female",
                          style: TextStyle(
                            color: white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  await savegender();
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
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

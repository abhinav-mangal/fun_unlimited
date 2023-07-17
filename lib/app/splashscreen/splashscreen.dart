import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/splash_controller.dart';

import 'package:get/get.dart';

class SplashScreenView extends GetView<SplashController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Spurple1,
            Spurple2,
            Spurple3,
            Spurple4,
            Spurple5,
            Spurple6,
            Spurple7,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: white),
                child: const Center(
                  child: Image(
                    image: AssetImage("assets/pok.png"),
                    height: 60,
                  ),
                ),
              ),
              const Text(
                "Lafa",
                style: TextStyle(
                    color: white, fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Make Chat borderless",
                style: TextStyle(color: white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

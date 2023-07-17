import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:linear_step_indicator/linear_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MylevelView extends GetView {
  final int steps = 5;
  const MylevelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: const IconThemeData(color: black),
        title: const Center(
          child: Text(
            'Level',
            style: TextStyle(
              color: black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 170,
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: blue,
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Icon(
                      Icons.diamond,
                      size: 50,
                      color: grey,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FullLinearStepIndicator(
                        steps: 5,
                        lineHeight: 3.5,
                        backgroundColor: blue,
                        controller: PageController(),
                        labels: List<String>.generate(
                            steps, (index) => "Level ${index + 1}"),
                        complete: () {
                          return Future.value(true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

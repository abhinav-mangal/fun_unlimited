import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:get/get.dart';

class MyText extends StatelessWidget {
  final String text;
  const MyText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: brown, fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}

class MyContainer extends StatelessWidget {
  final Widget container;
  const MyContainer({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: white,
        border: Border.all(color: blue),
      ),
      child: container,
    );
  }
}

//This is Go Live button for (tv page) Nearby, Live, Multi, New and Follow page.

class GoLiveButton extends StatelessWidget {
  final Widget golivebutton;

  const GoLiveButton({super.key, required this.golivebutton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Get.to(() => const WebRTCView());
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  purple,
                ),
                fixedSize: MaterialStateProperty.all(
                  Size(Get.width * 0.6, 40),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: const Text(
                "Go Live",
                style: TextStyle(
                  color: white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextn extends StatelessWidget {
  final String text;
  const MyTextn({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: white, fontSize: 17),
    );
  }
}

//This is randomMatch button for (videopage) Nearby, Discover, Popular and New pages.

class RandomMatch extends StatelessWidget {
  final Widget button;
  const RandomMatch({super.key, required this.button});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Get.to(() => const WebRTCView());
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  purple,
                ),
                fixedSize: MaterialStateProperty.all(
                  Size(Get.width * 0.6, 40),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: const Text(
                "Random Match",
                style: TextStyle(
                  color: white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

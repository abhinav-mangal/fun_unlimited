import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import 'upload_post_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  flipCamera() {
    if (controller.description.lensDirection == CameraLensDirection.front) {
      controller = CameraController(cameras[0], ResolutionPreset.max);
      setState(() {
        selectedCameraIndex = 0;
      });
    } else {
      controller = CameraController(cameras[1], ResolutionPreset.max);
      setState(() {
        selectedCameraIndex = 1;
      });
    }
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  int selectedCameraIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double mirror = selectedCameraIndex == 1 ? pi : 0;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(0),
                    child: CameraPreview(controller),
                  ),
                )
              : const SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.takePicture().then((value) {
                        Get.to(
                          () => UploadPostPage(
                            images: [File(value.path)],
                          ),
                        );
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: purple,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      padding: const EdgeInsets.all(40),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      flipCamera();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: const Icon(
                        Ionicons.camera_reverse_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

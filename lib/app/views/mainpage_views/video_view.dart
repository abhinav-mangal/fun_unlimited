import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/mainpage_controller/video_controller.dart';
import 'package:fun_unlimited/app/views/Home/home_nearby_page.dart';
import 'package:fun_unlimited/app/views/Home/home_new_page.dart';
import 'package:get/get.dart';

import '../Home/home_popular_page.dart';
import 'home_discover_page.dart';

class VideoView extends GetView {
  @override
  final controller = Get.put(VideoController());
  VideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                tabs: controller.toptab,
                isScrollable: true,
                labelColor: purple,
                unselectedLabelColor: black,
                indicatorColor: Colors.transparent,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 17,
                ),
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Obx(
                      () => controller.locationEnabled.value
                          ? const HomeNeearByPage()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Image(
                                  image: AssetImage("assets/gps.png"),
                                  height: 200,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Center(
                                  child: Text(
                                    "Turn on GPS to meet friends nearby",
                                    style:
                                        TextStyle(color: black, fontSize: 15),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    controller.getLocation();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: Get.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: purple),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Turn On",
                                        style: TextStyle(
                                            color: purple, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const HomeDiscoverPage(),
                    const HomePopularPage(),
                    const HomeNewPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

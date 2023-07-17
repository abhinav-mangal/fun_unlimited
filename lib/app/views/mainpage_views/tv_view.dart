import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/common_widgets/common_text.dart';
import 'package:fun_unlimited/app/controllers/mainpage_controller/tv_controller.dart';
import 'package:fun_unlimited/app/views/GoLive/go_live_test_page.dart';
import 'package:fun_unlimited/app/views/Home/home_new_page.dart';
import 'package:fun_unlimited/app/views/Home/home_popular_page.dart';
import 'package:fun_unlimited/app/views/lets_party_view/PartyView/party_follow_tab_view.dart';
import 'package:get/get.dart';

import '../Home/home_nearby_page.dart';

class TvView extends GetView {
  @override
  final controller = Get.put(TvController());
  TvView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      animationDuration: const Duration(seconds: 1),
      length: 5,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [
                  purple,
                  green,
                ],
              ),
              border: Border.all(
                color: white,
                width: 2,
              ),
            ),
            width: Get.width * 0.4,
            child: FloatingActionButton.extended(
              heroTag: UniqueKey(),
              onPressed: () {
                Get.to(() => const GoLiveTestPage());
              },
              backgroundColor: trans,
              elevation: 0,
              label: const Text("Go Live"),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: controller.toptab,
                indicatorColor: trans,
                labelColor: purple,
                unselectedLabelColor: black,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 17,
                ),
                labelStyle: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // This is Nearby Tab view
              Expanded(
                child: TabBarView(
                  children: [
                    Obx(() {
                      if (controller.locationEnabled.value) {
                        return const HomeNeearByPage();
                      }
                      return Column(
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
                              style: TextStyle(color: black, fontSize: 15),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
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
                                  style: TextStyle(color: purple, fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),

                    // This is Live Tab view
                    const HomePopularPage(
                      isLive: true,
                    ),
                    Stack(
                      children: [
                        GridView.count(
                          addAutomaticKeepAlives: true,
                          crossAxisCount: 2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          scrollDirection: Axis.vertical,
                          children: List.generate(30, (index) {
                            return InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: indigo,
                                ),
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(15),
                                  child: const Image(
                                    image: NetworkImage(
                                        "https://haryanvicelebrities.com/wp-content/uploads/2020/10/anjali_raghav_b.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        GoLiveButton(golivebutton: Container())
                      ],
                    ),

                    // This is New Tab view
                    const HomeNewPage(
                      isLive: true,
                    ),

                    const PartyFollowTabView(
                      isLive: true,
                    )
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

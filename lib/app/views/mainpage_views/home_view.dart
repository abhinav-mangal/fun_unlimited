import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/mainpage_controller/home_controller.dart';
import 'package:fun_unlimited/app/views/lets_party_view/go_lets_party.dart';
import 'package:get/get.dart';

import '../Home/home_nearby_page.dart';
import '../lets_party_view/PartyView/party_follow_tab_view.dart';
import '../lets_party_view/PartyView/party_tab_view.dart';

class HomeView extends GetView {
  @override
  final controller = Get.put(HomeController());
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      animationDuration: const Duration(
        milliseconds: 370,
      ),
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
                  ppurple5,
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
                Get.to(
                  () => const GoLetsParty(),
                );
              },
              backgroundColor: trans,
              elevation: 0,
              label: const Text("Lets Party"),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                indicatorColor: trans,
                labelColor: purple,
                unselectedLabelColor: black,
                tabs: controller.toptab,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 35,
                ),
                labelStyle: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 17,
                ),
              ),

              // This is Nearby Tab view
              Expanded(
                child: TabBarView(
                  children: [
                    Obx(() {
                      if (controller.locationEnabled.value) {
                        return const HomeNeearByPage(
                          isParty: true,
                        );
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

                    // This is Party Tab view
                    const PartyTabView(),

                    // This is Follow Tab view
                    const PartyFollowTabView(),
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

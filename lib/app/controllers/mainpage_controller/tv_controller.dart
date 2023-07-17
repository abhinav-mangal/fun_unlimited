import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class TvController extends GetxController {
  late TabController tabController;

  RxBool locationEnabled = false.obs;
  Position? position;

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  getLocation() async {
    if (await Geolocator.requestPermission() == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    if (await Geolocator.isLocationServiceEnabled()) {
      locationEnabled.value = true;
    } else {
      locationEnabled.value = false;
    }
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    locationEnabled.value = true;
    update();
  }

  List<Tab> toptab = <Tab>[
    const Tab(
      text: "Nearby",
    ),
    const Tab(
      text: "Live",
    ),
    const Tab(
      text: "Multi",
    ),
    const Tab(
      text: "New",
    ),
    const Tab(
      text: "Follow",
    )
  ];
}

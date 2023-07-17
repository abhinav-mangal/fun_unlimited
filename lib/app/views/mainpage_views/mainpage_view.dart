import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/mainpage_controller/mainpage_controller.dart';
import 'package:get/get.dart';

class MainView extends GetView<MainController> {
  final listcontroller = Get.put(MainController());
  MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MainController(),
      builder: (controller) => Scaffold(
        backgroundColor: grey,
        body: Center(
          child: listcontroller.widgetList[listcontroller.selectedIndex.value],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            type: BottomNavigationBarType.fixed,
            onTap: (i) {
              controller.changeIndex(i);
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Feather.video,
                  color: grey,
                  size: 30,
                ),
                activeIcon: Icon(
                  FontAwesome.video_camera,
                  color: purple,
                  size: 30,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.live_tv_outlined,
                  color: grey,
                  size: 30,
                ),
                activeIcon: Icon(
                  Icons.live_tv,
                  color: purple,
                  size: 30,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: grey,
                  size: 30,
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: purple,
                  size: 30,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesome.globe,
                  color: grey,
                  size: 30,
                ),
                activeIcon: Icon(
                  FontAwesome.globe,
                  color: purple,
                  size: 30,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_outlined,
                  color: grey,
                  size: 30,
                ),
                activeIcon: Icon(
                  Icons.settings,
                  color: purple,
                  size: 30,
                ),
                label: "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

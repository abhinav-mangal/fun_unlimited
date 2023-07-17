import 'package:flutter/cupertino.dart';
import 'package:fun_unlimited/app/views/mainpage_views/AboutView/about_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/SocialMedia/posts_page.dart';
import 'package:fun_unlimited/app/views/mainpage_views/home_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/tv_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/video_view.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 0.obs;

  List<Widget> widgetList = [
    VideoView(),
    TvView(),
    HomeView(),
    SocialView(),
    const AboutView()
  ];

  changeIndex(int index) {
    selectedIndex(index);
    update();
  }
}

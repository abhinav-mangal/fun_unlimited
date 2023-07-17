import 'package:fun_unlimited/app/bindings/about_binding/my_chatprice_binding.dart';
import 'package:fun_unlimited/app/bindings/about_binding/my_earning_binding.dart';
import 'package:fun_unlimited/app/bindings/about_binding/my_level_binding.dart';
import 'package:fun_unlimited/app/bindings/about_binding/my_profile_binding.dart';
import 'package:fun_unlimited/app/bindings/about_binding/setting_binding.dart';
import 'package:fun_unlimited/app/bindings/language_binding/countrycode_binding.dart';
import 'package:fun_unlimited/app/bindings/language_binding/language_binding.dart';
import 'package:fun_unlimited/app/bindings/location_binding/current_location_binding.dart';
import 'package:fun_unlimited/app/bindings/login_binding/login_binding.dart';
import 'package:fun_unlimited/app/bindings/login_binding/phone_binding/otp_binding.dart';
import 'package:fun_unlimited/app/bindings/login_binding/phone_binding/phone_binding.dart';
import 'package:fun_unlimited/app/bindings/main_page_binding/about_binding.dart';
import 'package:fun_unlimited/app/bindings/main_page_binding/globe_binding.dart';
import 'package:fun_unlimited/app/bindings/main_page_binding/home_binding.dart';
import 'package:fun_unlimited/app/bindings/main_page_binding/tv_binding.dart';
import 'package:fun_unlimited/app/bindings/main_page_binding/video_binding.dart';
import 'package:fun_unlimited/app/bindings/splash_binding.dart';
import 'package:fun_unlimited/app/splashscreen/splashscreen.dart';
import 'package:fun_unlimited/app/views/about_view/mybalance_view.dart';
import 'package:fun_unlimited/app/views/about_view/mychatprice_view.dart';
import 'package:fun_unlimited/app/views/about_view/myearning_view.dart';
import 'package:fun_unlimited/app/views/about_view/mylavel_view.dart';
import 'package:fun_unlimited/app/views/about_view/myprofile_view.dart';
import 'package:fun_unlimited/app/views/about_view/mytask_view.dart';
import 'package:fun_unlimited/app/views/about_view/setting_view.dart';
import 'package:fun_unlimited/app/views/language_view/countrycode_view.dart';
import 'package:fun_unlimited/app/views/language_view/language_view.dart';
import 'package:fun_unlimited/app/views/location_view/current_location_view.dart';
import 'package:fun_unlimited/app/views/login_views/login_view.dart';
import 'package:fun_unlimited/app/views/login_views/phone_login_view/otp_view.dart';
import 'package:fun_unlimited/app/views/login_views/phone_login_view/phone_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/AboutView/about_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/SocialMedia/posts_page.dart';
import 'package:fun_unlimited/app/views/mainpage_views/home_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/tv_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/video_view.dart';
import 'package:get/get.dart';

import '../bindings/login_binding/phone_binding/select_gender_binding.dart';
import '../views/login_views/phone_login_view/select_gender_view.dart';

part 'app_routes.dart';

class AppPages {
  // AppPages._();
  static const initial = Routes.splashscreen;

  static final routes = [
    GetPage(
      name: _Paths.splashscreen,
      page: () => const SplashScreenView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.phone,
      page: () => const PhoneView(),
      binding: PhoneBinding(),
    ),
    GetPage(
      name: _Paths.otp,
      page: () => OTPView(),
      binding: OTPBindings(),
    ),
    GetPage(
      name: _Paths.video,
      page: () => VideoView(),
      binding: VideoBinding(),
    ),
    GetPage(
      name: _Paths.tv,
      page: () => TvView(),
      binding: TVBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.globe,
      page: () => SocialView(),
      binding: GlobeBinding(),
    ),
    GetPage(
      name: _Paths.about,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.language,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: _Paths.countrycode,
      page: () => const CountryCodeView(),
      binding: CountryCodeBinding(),
    ),
    GetPage(
      name: _Paths.mybalance,
      page: () => const MyBalanceView(),
    ),
    GetPage(
      name: _Paths.mychat,
      page: () => const MyChatPriceView(),
      binding: MyChatPriceBindings(),
    ),
    GetPage(
      name: _Paths.myearning,
      page: () => const MyEarningView(),
      binding: MyEarningBindings(),
    ),
    GetPage(
      name: _Paths.mylevel,
      page: () => const MylevelView(),
      binding: MyLevelBinding(),
    ),
    GetPage(
      name: _Paths.myprofile,
      page: () => const MyProfileView(),
      binding: MyProfileBindings(),
    ),
    GetPage(
      name: _Paths.mytask,
      page: () => const MyTaskView(),
      binding: MyProfileBindings(),
    ),
    GetPage(
      name: _Paths.setting,
      page: () => SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.currentlocation,
      page: () => const CurrentLocationView(),
      binding: CurrentLocationBinding(),
    ),
    GetPage(
      name: _Paths.selectgender,
      page: () => const SelectGenderView(),
      binding: SelectGenderBinding(),
    ),
  ];
}

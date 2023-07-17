import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fun_unlimited/app/controllers/ChatController/chat_controller.dart';
import 'package:fun_unlimited/app/controllers/UserController/user_controller.dart';
import 'package:fun_unlimited/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'app/controllers/CallController/call_controller.dart';
import 'app/controllers/about_controller/my_balance_controller.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CallController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => MyBalanceController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Get.put(UserController());
    final callController = Provider.of<CallController>(context, listen: false);
    callController.startListner();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
          ),
        ),
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      builder: (context, child) {
        return Consumer<CallController>(
          builder: (BuildContext context, value, Widget? bchild) => Stack(
            children: [
              Scaffold(
                body: child,
              ),
              if (FirebaseAuth.instance.currentUser != null)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: kToolbarHeight + 20,
                  left: value.isCalling ? 0 : -200,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.purple,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection("User")
                                .doc(
                                  value.uid == ""
                                      ? FirebaseAuth.instance.currentUser!.uid
                                      : value.uid,
                                )
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text("");
                              }
                              return CircleAvatar(
                                radius: 20,
                                backgroundImage: snapshot.data!["image"] == null
                                    ? null
                                    : NetworkImage(snapshot.data!["image"]),
                                child: snapshot.data!["image"] == null
                                    ? Text(snapshot.data!["name"][0])
                                    : null,
                              );
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Lottie.asset(
                            "assets/calling.json",
                            height: 40,
                            width: 50,
                          ),
                          InkWell(
                            onTap: () {
                              value.disconnectCalling();
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.call_end,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

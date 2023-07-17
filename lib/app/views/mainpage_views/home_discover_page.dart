import 'dart:developer';
import 'dart:math' show Random;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/Utils/constant.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/CallController/call_controller.dart';
import 'package:fun_unlimited/app/user_models/user_model.dart';
import 'package:fun_unlimited/app/views/about_view/other_profile_view.dart';
import 'package:fun_unlimited/app/views/live_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../../controllers/UserController/user_controller.dart';

class HomeDiscoverPage extends StatefulWidget {
  const HomeDiscoverPage({Key? key}) : super(key: key);

  @override
  State<HomeDiscoverPage> createState() => _HomeDiscoverPageState();
}

class _HomeDiscoverPageState extends State<HomeDiscoverPage> {
  List<UserModel> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    final data = await FirebaseFirestore.instance.collection("User").get();
    for (var element in data.docs) {
      if (element.id == FirebaseAuth.instance.currentUser!.uid) {
        continue;
      } else {
        users.add(UserModel.fromJson(element.data()));
      }
    }
    users.shuffle();
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: FloatingActionButton.extended(
            heroTag: UniqueKey(),
            onPressed: () {
              final data = Provider.of<CallController>(context, listen: false);
              data.call(users[Random().nextInt(users.length)].id);
            },
            backgroundColor: trans,
            elevation: 0,
            label: const Text("Random Match"),
          ),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          users.clear();
          await getData();
        },
        header: const WaterDropHeader(
          complete: Text(
            "✅Refreshed",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          waterDropColor: purple,
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PageView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return HomeDiscoverCardPage(user: user);
                },
              ),
      ),
    );
  }
}

class HomeDiscoverCardPage extends StatefulWidget {
  const HomeDiscoverCardPage({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  State<HomeDiscoverCardPage> createState() => _HomeDiscoverCardPageState();
}

class _HomeDiscoverCardPageState extends State<HomeDiscoverCardPage> {
  @override
  void initState() {
    super.initState();
    startLiveStream();
  }

  startLiveStream() async {
    final data = await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.user.id)
        .get();
    if (!data.data()!["isLive"]) {
      return;
    }

    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        1181603960,
        ZegoScenario.Default,
        appSign:
            '5de12f92b097e4d0b3fee8ea25315832053226c5b89182a5bbdd23b271f5ff51',
      ),
    );
    final streamId = widget.user.id;
    final engine = ZegoExpressEngine.instance;
    await Get.find<UserController>().getUser();

    await engine.loginRoom(
      streamId,
      ZegoUser(
        FirebaseAuth.instance.currentUser!.uid,
        Get.find<UserController>().user!.name,
      ),
    );
    await engine.muteSpeaker(true);
    await engine.setVideoConfig(
      ZegoVideoConfig(
        Get.width.toInt(),
        Get.height.toInt(),
        Get.width.toInt(),
        Get.height.toInt(),
        15,
        600,
        ZegoVideoCodecID.Default,
      ),
    );
    final publisTexture = await engine.createCanvasView(
      (value) {
        setState(() {
          canvasId = value;
        });
      },
    );
    // Make widget to play stream
    await engine.startPlayingStream(
      streamId,
      canvas: ZegoCanvas(
        canvasId,
        viewMode: ZegoViewMode.AspectFill,
      ),
    );
    setState(() {
      playerWidget = publisTexture ?? Container();
    });
  }

  int canvasId = 0;
  Widget playerWidget = LottieBuilder.asset('assets/load2.json');

  @override
  void dispose() {
    super.dispose();
    if (canvasId != 0) {
      ZegoExpressEngine.destroyEngine();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 100,
          right: 10,
        ),
        child: FloatingActionButton(
          onPressed: () {
            final data = Provider.of<CallController>(context, listen: false);
            data.call(widget.user.id);
          },
          child: CircleAvatar(
            radius: 30,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.purple,
                    Colors.pink,
                  ],
                ),
              ),
              child: Center(
                child: Lottie.asset(
                  "assets/call.json",
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .doc(widget.user.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: 30,
            ),
            child: InkWell(
              onTap: () {
                Get.to(
                  () => OthersProfileView(
                    userId: widget.user.id,
                  ),
                  transition: Transition.rightToLeft,
                );
              },
              child: Stack(
                children: [
                  if (widget.user.cover == "")
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          imageUrl: widget.user.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      image: widget.user.cover == ""
                          ? null
                          : DecorationImage(
                              image: NetworkImage(widget.user.cover),
                              fit: BoxFit.cover,
                            ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Stack(
                      children: [
                        if (snapshot.data!.data()!["isLive"])
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 25,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: purple.withOpacity(0.7),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Row(
                                children: [
                                  Lottie.asset(
                                    "assets/live.json",
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Live",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (snapshot.data!.data()!["isLive"])
                          Align(
                            alignment: Alignment.topRight,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  height: 160,
                                  child: Column(
                                    children: [
                                      tapper(
                                        onTap: () async {
                                          if (canvasId == 0) {
                                            return;
                                          }
                                          if (canvasId != 0) {
                                            await ZegoExpressEngine.instance
                                                .stopPlayingStream(
                                                    widget.user.id);
                                            await ZegoExpressEngine.instance
                                                .destroyCanvasView(canvasId);
                                            await ZegoExpressEngine.instance
                                                .logoutRoom();
                                            await ZegoExpressEngine
                                                .destroyEngine();
                                          }
                                          final data = await Get.to(
                                            () => LiveView(
                                              uid: widget.user.id,
                                            ),
                                            transition: Transition.rightToLeft,
                                          );
                                          log('canvasId: $canvasId');
                                          setState(() {
                                            canvasId = 0;
                                            playerWidget = LottieBuilder.asset(
                                              'assets/load2.json',
                                            );
                                          });
                                          startLiveStream();
                                        },
                                        child: Container(
                                          height: 150,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Colors.purple,
                                                Colors.pink,
                                              ],
                                            ),
                                          ),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: playerWidget,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const CircleAvatar(
                                  radius: 13,
                                  backgroundColor: purple,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 60,
                            left: 5,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: SizedBox(
                              width: Get.width * 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.user.language,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.user.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 10,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          "https://cdn.pixabay.com/photo/2018/01/21/14/36/indian-flag-3096740_960_720.png",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.purple.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Lvl: ${widget.user.level}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

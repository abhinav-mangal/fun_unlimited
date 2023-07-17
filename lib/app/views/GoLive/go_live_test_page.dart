import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/controllers/UserController/user_controller.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../../../main.dart';
import '../../Utils/constant.dart';
import '../../common_widgets/common_colors.dart';
import '../../user_models/user_model.dart';

class GoLiveTestPage extends StatefulWidget {
  const GoLiveTestPage({Key? key}) : super(key: key);

  @override
  State<GoLiveTestPage> createState() => _GoLiveTestPageState();
}

class _GoLiveTestPageState extends State<GoLiveTestPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  late CameraController _controller;

  _init() async {
    _controller = CameraController(cameras[1], ResolutionPreset.max);
    await _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    ZegoExpressEngine.instance.logoutRoom();
    ZegoExpressEngine.instance.destroyCanvasView(canvasId);
    ZegoExpressEngine.destroyEngine();
  }

  startListeners() {
    ZegoExpressEngine.onRoomOnlineUserCountUpdate = (id, count) {
      FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Live")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"count": count});
    };
    ZegoExpressEngine.onRoomUserUpdate = (id, type, user) {
      if (type == ZegoUpdateType.Add) {
        FirebaseFirestore.instance
            .collection("User")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Live")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "users": FieldValue.arrayUnion(
            user.map((e) => e.userID).toList(),
          )
        });
        FirebaseFirestore.instance
            .collection("User")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Live")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Messages")
            .add({
          "message": "${user[0].userName} joined the room",
          "time": DateTime.now().millisecondsSinceEpoch.toString(),
          "type": "system",
          "name": user[0].userName,
        });
      } else {
        FirebaseFirestore.instance
            .collection("User")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Live")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "users": FieldValue.arrayRemove(
            user.map((e) => e.userID).toList(),
          ),
        });
        FirebaseFirestore.instance
            .collection("User")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Live")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Messages")
            .add({
          "message": "${user[0].userName} left the room",
          "time": DateTime.now().millisecondsSinceEpoch.toString(),
          "name": user[0].userName,
          "type": "system",
        });
      }
    };
  }

  startStreaming() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    //init zego
    ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        1181603960,
        ZegoScenario.Broadcast,
        appSign:
            '5de12f92b097e4d0b3fee8ea25315832053226c5b89182a5bbdd23b271f5ff51',
      ),
    );

    final streamId = FirebaseAuth.instance.currentUser!.uid;
    //Set is Live
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"isLive": true});
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Live")
        .doc(streamId)
        .set({
      "streamId": streamId,
      "users": [],
      "count": 0,
    });
    final engine = ZegoExpressEngine.instance;
    try {
      if (Get.find<UserController>().user == null) {
        await Get.find<UserController>().getUser();
      }
      await engine.loginRoom(
        streamId,
        ZegoUser(
          FirebaseAuth.instance.currentUser!.uid,
          Get.find<UserController>().user!.name,
        ),
      );
      await engine.enableCamera(true);

      await engine.enableAEC(true);
      await engine.setVideoMirrorMode(ZegoVideoMirrorMode.BothMirror);
      await engine.enableHeadphoneAEC(true);
      await engine.enableCameraAdaptiveFPS(
          true, 15, 60, ZegoPublishChannel.Main);
      await engine.enableEffectsBeauty(true);
      await engine.enableHardwareEncoder(true);
      await engine.enableHardwareDecoder(true);

      await engine.setVideoConfig(
        ZegoVideoConfig(
          Get.width.toInt(),
          Get.height.toInt(),
          Get.width.toInt(),
          Get.height.toInt(),
          60,
          10000,
          ZegoVideoCodecID.Default,
        ),
        channel: ZegoPublishChannel.Main,
      );
      await engine.setLowlightEnhancement(ZegoLowlightEnhancementMode.On);
      await engine.muteSpeaker(true);
      await engine.startPublishingStream(
        streamId,
      );

      startListeners();
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
        config: ZegoPlayerConfig(
          ZegoStreamResourceMode.Default,
        ),
      );
      setState(() {
        playerWidget = publisTexture;
      });
      if (Get.isDialogOpen!) {
        Get.back();
      }
    } on Exception catch (e) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      log("Error: $e");
    }
  }

  Widget? playerWidget;

  int canvasId = 0;

  disconnect() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    await ZegoExpressEngine.instance.stopPublishingStream();
    await ZegoExpressEngine.instance
        .stopPlayingStream(FirebaseAuth.instance.currentUser!.uid);
    await ZegoExpressEngine.instance.logoutRoom();
    await ZegoExpressEngine.instance.destroyCanvasView(canvasId);
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"isLive": false});
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Live")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Messages")
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              element.reference.delete();
            },
          ),
        );
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Live")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (canvasId != 0) {
          QuickAlert.show(
            animType: QuickAlertAnimType.slideInUp,
            context: context,
            type: QuickAlertType.confirm,
            title: "Close Stream",
            cancelBtnText: "Cancel",
            confirmBtnText: "Confirm",
            text: "Are you sure you want to end your stream?",
            onCancelBtnTap: () {
              Navigator.pop(context);
            },
            onConfirmBtnTap: () {
              Get.back();
              disconnect();
            },
          );
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Stack(
          // fit: StackFit.expand,
          children: [
            if (_controller.value.isInitialized)
              SizedBox(
                height: Get.height.roundToDouble(),
                width: Get.width.roundToDouble(),
                child: CameraPreview(
                  _controller,
                ),
              )
            else
              const SizedBox(),
            if (canvasId != 0) (playerWidget ?? const SizedBox()),
            Container(
              color: black.withOpacity(0.2),
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("User")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return const SizedBox();
                  }
                  final user = UserModel.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>);
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: Get.width * 0.5,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 60,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: white,
                                                ),
                                              ),
                                              StreamBuilder<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("User")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .collection("Live")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  return Text(
                                                    (snapshot.hasData
                                                            ? snapshot.data!
                                                                    .exists
                                                                ? snapshot.data!
                                                                    .get(
                                                                        "count")
                                                                : 0
                                                            : 0)
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      color: white,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        color: purple,
                                        shape: BoxShape.circle,
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Center(
                                        child: Stack(
                                          clipBehavior: Clip.hardEdge,
                                          children: [
                                            CircleAvatar(
                                              radius: 22,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                user.image!,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: -25,
                                              right: -0,
                                              left: 0,
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: purple,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      "Lvl ${user.level}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              tapper(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 0.5,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.4),
                                    child: Image.asset(
                                      'assets/group.png',
                                      height: 20,
                                      width: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.4),
                                  child: IconButton(
                                    onPressed: () {
                                      showmessageBox();
                                    },
                                    icon: const Icon(
                                      Ionicons.md_chatbubble_ellipses_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red,
                                      Colors.purple,
                                    ],
                                  ),
                                ),
                                child: tapper(
                                  onTap: () {},
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Ionicons.ios_gift_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                ),
                                child: tapper(
                                  onTap: () {},
                                  child: const CircleAvatar(
                                    // radius: 15,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Octicons.apps,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                ),
                                child: tapper(
                                  onTap: () {
                                    QuickAlert.show(
                                      animType: QuickAlertAnimType.slideInUp,
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      title: "Close Stream",
                                      cancelBtnText: "Cancel",
                                      confirmBtnText: "Confirm",
                                      text:
                                          "Are you sure you want to end your stream?",
                                      onCancelBtnTap: () {
                                        Navigator.pop(context);
                                      },
                                      onConfirmBtnTap: () {
                                        Get.back();
                                        disconnect();
                                      },
                                    );
                                  },
                                  child: const CircleAvatar(
                                    // radius: 20,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      MaterialCommunityIcons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (canvasId != 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  messagingWidget(),
                  const SizedBox(
                    height: 90,
                  ),
                ],
              ),
            if (canvasId == 0)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: const BoxDecoration(),
                    child: Center(
                      child: Column(
                        children: [
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('User')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "My Call Price: ${snapshot.hasData ? snapshot.data!.data()!['mychatprice'] : 0}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.diamond,
                                    color: Colors.amber,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          tapper(
                            onTap: () {
                              startStreaming();
                            },
                            child: Container(
                              height: 45,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.5,
                                ),
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.purple,
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "Go Live",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  final scrollController = ScrollController();

  Widget messagingWidget() {
    return Container(
      height: 300,
      constraints: BoxConstraints(
        maxWidth: Get.width * 0.8,
      ),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Live")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Messages")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return const SizedBox();
          }
          if (snapshot.data!.docs.isEmpty) {
            return const SizedBox();
          }
          return ListView.separated(
            reverse: true,
            controller: scrollController,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            padding: const EdgeInsets.only(
              left: 10,
            ),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: Get.width * 0.6,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        children: [
                          if (snapshot.data!.docs[index].data()['type'] ==
                              "user")
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
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
                                    snapshot.data!.docs[index].data()['level'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Text(
                            snapshot.data!.docs[index].data()['name'],
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            snapshot.data!.docs[index].data()['message'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  final messageController = TextEditingController();

  sendMessagetoDB() async {
    UserModel? user = Get.find<UserController>().user;
    if (user == null) {
      await Get.find<UserController>().getUser();
      user = Get.find<UserController>().user;
    }

    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Live")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Messages")
        .add({
      "name": "Host",
      "message": messageController.text,
      "time": DateTime.now().millisecondsSinceEpoch,
      "type": "host",
      "level": user!.level.toString(),
    });
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    messageController.clear();
  }

  showmessageBox() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          width: Get.width,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: "Type Message",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              tapper(
                onTap: () {
                  Get.back();
                  sendMessagetoDB();
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Icon(
                    FontAwesome.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/Utils/constant.dart';
import 'package:fun_unlimited/app/controllers/UserController/user_controller.dart';
import 'package:fun_unlimited/app/user_models/user_model.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../../../main.dart';
import '../../common_widgets/common_colors.dart';
import 'party_controller.dart';
import 'preview_widget.dart';

class GoLetsParty extends StatefulWidget {
  const GoLetsParty({Key? key}) : super(key: key);

  @override
  State<GoLetsParty> createState() => _GoLetsPartyState();
}

class _GoLetsPartyState extends State<GoLetsParty> {
  bool maxview = true;
  bool isParty = false;
  final engine = ZegoExpressEngine.instance;
  final controller = Get.put(PartyController());

  startParty() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    final roomId = FirebaseAuth.instance.currentUser!.uid;

    ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        1181603960,
        ZegoScenario.HighQualityChatroom,
        appSign:
            '5de12f92b097e4d0b3fee8ea25315832053226c5b89182a5bbdd23b271f5ff51',
      ),
    );
    await engine.enableCamera(true);
    await engine.enableAEC(true);
    await engine.setVideoMirrorMode(ZegoVideoMirrorMode.BothMirror);
    await engine.enableHeadphoneAEC(true);
    await engine.enableCameraAdaptiveFPS(true, 15, 60, ZegoPublishChannel.Main);
    await engine.enableEffectsBeauty(true);
    await engine.enableHardwareEncoder(true);
    await engine.enableHardwareDecoder(true);
    await engine.muteSpeaker(true);
    final controller = Provider.of<UserController>(context, listen: false);
    if (controller.user == null) {
      await controller.getUser();
    }
    final canvas = await engine.createCanvasView((viewID) {
      setState(() {
        previewViewID = viewID;
      });
    });
    setState(() {
      canvasView = canvas!;
      isParty = true;
    });
    await engine.setLowlightEnhancement(ZegoLowlightEnhancementMode.On);
    await engine.loginRoom(
      roomId,
      ZegoUser(
        FirebaseAuth.instance.currentUser!.uid,
        controller.user!.name,
      ),
    );
    await engine.startPublishingStream(
      roomId,
      config: ZegoPublisherConfig(
        roomID: roomId,
        streamCensorshipMode: ZegoStreamCensorshipMode.AudioAndVideo,
      ),
    );
    await engine.startPreview(
      canvas: ZegoCanvas(
        previewViewID,
        viewMode: ZegoViewMode.AspectFill,
      ),
    );
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Party")
        .doc(roomId)
        .set({
      'roomId': roomId,
      "room_length": 6,
      'name': 'Party',
      'time': DateTime.now().millisecondsSinceEpoch,
      'type': 'party',
      "inactiveUsers": [],
      'users': [FirebaseAuth.instance.currentUser!.uid],
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        "isParty": true,
      },
      SetOptions(merge: true),
    );
    Get.back();
    startRequestListner();
  }

  int previewViewID = 0;
  Widget canvasView = const SizedBox();

  disconnect() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    await ZegoExpressEngine.destroyEngine();
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "isParty": false,
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Party")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Messages")
        .get()
        .then(
          // ignore: avoid_function_literals_in_foreach_calls
          (value) => value.docs.forEach(
            (element) {
              element.reference.delete();
            },
          ),
        );
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Party")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Requests")
        .get()
        .then(
          // ignore: avoid_function_literals_in_foreach_calls
          (value) => value.docs.forEach(
            (element) {
              element.reference.delete();
            },
          ),
        );
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Party")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    if (Get.isDialogOpen!) {
      Get.back();
    }
    // _streamSubscription.cancel();
    Get.back();
  }

  int playerCanvasID = 0;
  Widget playerCanvas = const SizedBox();

  startRequestListner() {
    FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Party")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Requests")
        .orderBy("time", descending: true)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        showRequestDialog(event.docs.first.data()['uid']);
      }
    });
  }

  showRequestDialog(String uid) async {
    final response =
        await FirebaseFirestore.instance.collection("User").doc(uid).get();
    final user = UserModel.fromJson(response.data()!);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        content: Container(
          width: Get.width * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "SomeOne wants to join your party",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
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
                            backgroundImage: CachedNetworkImageProvider(
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.country,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: purple,
                    child: IconButton(
                      onPressed: () async {
                        Get.back();
                        await FirebaseFirestore.instance
                            .collection("User")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("Party")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("Requests")
                            .where("uid", isEqualTo: uid)
                            .get()
                            .then(
                              (value) => value.docs.forEach(
                                (element) {
                                  element.reference.delete();
                                },
                              ),
                            );
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: purple,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                        addUser(user);
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  startPartyWithMicOnly() async {
    final zegoEngine = ZegoExpressEngine.instance;
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        1181603960,
        ZegoScenario.HighQualityChatroom,
        appSign:
            '5de12f92b097e4d0b3fee8ea25315832053226c5b89182a5bbdd23b271f5ff51',
      ),
    );
    final roomId = FirebaseAuth.instance.currentUser!.uid;
    await zegoEngine.enableCamera(false);
    // await zegoEngine.muteSpeaker(true);
    final user = Provider.of<UserController>(context, listen: false);
    if (user.user == null) {
      await user.getUser();
    }
    await zegoEngine.loginRoom(
      roomId,
      ZegoUser(roomId, user.user!.name),
    );
    await zegoEngine.startPublishingStream(roomId);
    await zegoEngine.startPreview();
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Party")
        .doc(roomId)
        .set({
      'roomId': roomId,
      "room_length": 10,
      'name': 'Party',
      'time': DateTime.now().millisecondsSinceEpoch,
      'type': 'party',
      "inactiveUsers": [],
      'users': [FirebaseAuth.instance.currentUser!.uid],
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        "isParty": true,
      },
      SetOptions(merge: true),
    );

    setState(() {
      isParty = true;
    });
    startRequestListner();
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  addUser(UserModel user) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Party")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Requests")
        .where("uid", isEqualTo: user.id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Party")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        final data = value.data() as Map<String, dynamic>;
        if (data["users"].length >= data["room_length"]) {
          Get.rawSnackbar(
            message: "Party is full",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        } else {
          await FirebaseFirestore.instance
              .collection("User")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Party")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "inactiveUsers": FieldValue.arrayRemove(
              [
                user.id,
              ],
            ),
          });
          await FirebaseFirestore.instance
              .collection("User")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Party")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "users": FieldValue.arrayUnion(
              [
                user.id,
              ],
            ),
          });
          await FirebaseFirestore.instance
              .collection("User")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Party")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Messages")
              .add({
            "name": user.name,
            "message": "${user.name} joined the party",
            "time": DateTime.now().millisecondsSinceEpoch,
            "type": "user",
            "level": user.level.toString(),
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isParty) {
          QuickAlert.show(
            animType: QuickAlertAnimType.slideInUp,
            context: context,
            type: QuickAlertType.confirm,
            title: "End Party",
            cancelBtnText: "Cancel",
            confirmBtnText: "Confirm",
            text: "Are you sure you want to end your Party?",
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
        backgroundColor: purple,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20, // 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      width: 80,
                      decoration: BoxDecoration(
                        color: white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('User')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CachedNetworkImage(
                                  imageUrl: snapshot.data!.data()!['image'],
                                  fit: BoxFit.cover,
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.withOpacity(0.8),
                                    Colors.purple.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.done,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isParty)
                      tapper(
                        onTap: () {
                          Get.back();
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: white.withOpacity(0.1),
                          child: const Icon(
                            Icons.clear,
                            color: white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 370),
                    crossFadeState: maxview
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: maxViewWidget(),
                    secondChild: minViewWidget(),
                  ),
                ],
              ),
              if (!isParty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          tapper(
                            onTap: () {
                              if (maxview) {
                                return;
                              }
                              setState(() {
                                maxview = true;
                              });
                              disposeCamera();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.sofa_single,
                                  color:
                                      maxview ? white : white.withOpacity(0.2),
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "10",
                                  style: TextStyle(
                                    color: maxview
                                        ? white
                                        : white.withOpacity(0.2),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 30,
                            width: 1,
                            color: white,
                          ),
                          tapper(
                            onTap: () {
                              if (!maxview) {
                                return;
                              }
                              setState(() {
                                maxview = false;
                              });
                              createCamera();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.sofa_single,
                                  color:
                                      !maxview ? white : white.withOpacity(0.2),
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "6",
                                  style: TextStyle(
                                    color: !maxview
                                        ? white
                                        : white.withOpacity(0.2),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AnimatedButton(
                      shadowDegree: ShadowDegree.dark,
                      height: 55,
                      radius: 30,
                      width: Get.width * 0.4,
                      onPressed: () {
                        if (maxview) {
                          startPartyWithMicOnly();
                        } else {
                          startParty();
                        }
                      },
                      child: const Text(
                        "Lets Party",
                        style: TextStyle(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    messagingWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      child: Row(
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
                              backgroundColor: Colors.black.withOpacity(0.4),
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
                                  title: "End Party",
                                  cancelBtnText: "Cancel",
                                  confirmBtnText: "Confirm",
                                  text:
                                      "Are you sure you want to end your Party?",
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
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  maxViewWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('User')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: white.withOpacity(0.1),
                      backgroundImage: snapshot.hasData
                          ? CachedNetworkImageProvider(
                              snapshot.data!.data()!['image'],
                            )
                          : null,
                      child: snapshot.hasData
                          ? null
                          : const Icon(
                              MaterialCommunityIcons.sofa_single,
                              color: white,
                            ),
                    );
                  }
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: white.withOpacity(0.1),
                    // backgroundImage: snapshot.hasData
                    //     ? CachedNetworkImageProvider(
                    //         snapshot.data!.data()!['image'],
                    //       )
                    //     : null,
                    child: const Icon(
                      MaterialCommunityIcons.sofa_single,
                      color: white,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  createCamera() {
    _controller = CameraController(
      cameras[1],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  disposeCamera() {
    _controller.dispose();
    setState(() {});
  }

  minViewWidget() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Party")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: 0.7,
          ),
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: white.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft:
                        index == 0 ? const Radius.circular(10) : Radius.zero,
                    topRight:
                        index == 2 ? const Radius.circular(10) : Radius.zero,
                    bottomLeft:
                        index == 3 ? const Radius.circular(10) : Radius.zero,
                    bottomRight:
                        index == 5 ? const Radius.circular(10) : Radius.zero,
                  ),
                ),
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (maxview) {
                        return const SizedBox();
                      }
                      if (previewViewID != 0) {
                        return canvasView;
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Camera error',
                            style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return CameraPreview(_controller);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            }
            if (isParty == false ||
                snapshot.data!.data()!['users'].length <= index) {
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: white.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft:
                        index == 0 ? const Radius.circular(10) : Radius.zero,
                    topRight:
                        index == 2 ? const Radius.circular(10) : Radius.zero,
                    bottomLeft:
                        index == 3 ? const Radius.circular(10) : Radius.zero,
                    bottomRight:
                        index == 5 ? const Radius.circular(10) : Radius.zero,
                  ),
                ),
                child: const Icon(
                  MaterialCommunityIcons.sofa_single,
                  color: white,
                ),
              );
            }

            return PreviewWidget(
              uid: snapshot.data!.data()!['users'][index],
              roomId: FirebaseAuth.instance.currentUser!.uid,
            );
          },
        );
      },
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
            .collection("Party")
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
    final controller = Provider.of<UserController>(context, listen: false);
    if (controller.user == null) {
      await controller.getUser();
    }

    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Party")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Messages")
        .add({
      "name": "Host",
      "message": messageController.text,
      "time": DateTime.now().millisecondsSinceEpoch,
      "type": "host",
      "level": controller.user!.level.toString(),
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

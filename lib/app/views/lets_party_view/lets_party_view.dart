import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../../Utils/constant.dart';
import '../../controllers/UserController/user_controller.dart';
import '../../user_models/user_model.dart';
import '../ChatView/chat_page.dart';
import '../Game/game_sheet.dart';
import '../Game/lucky_number_game.dart';
import '../about_view/mybalance_view.dart';
import 'party_controller.dart';
import 'preview_widget.dart';

class LetsPartyView extends StatefulWidget {
  final String uid;
  const LetsPartyView({super.key, required this.uid});

  @override
  State<LetsPartyView> createState() => _LetsPartyViewState();
}

class _LetsPartyViewState extends State<LetsPartyView> {
  bool isfollowing = false;
  bool showUser = false;
  String uid = "";

  final controller = Get.put(PartyController());

  @override
  void initState() {
    super.initState();
    setState(() {
      uid = widget.uid;
    });
    startListner();
    FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Following")
        .where("userId", isEqualTo: widget.uid)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        if (mounted) {
          setState(() {
            isfollowing = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isfollowing = true;
          });
        }
      }
    });
    checkIsLive();
    FirebaseFirestore.instance
        .collection("User")
        .doc(widget.uid)
        .collection("Party")
        .doc(widget.uid)
        .update({
      "inactiveUsers":
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  late StreamSubscription _subscription;
  startListner() {
    _subscription = FirebaseFirestore.instance
        .collection("User")
        .doc(widget.uid)
        .collection("Party")
        .doc(widget.uid)
        .snapshots()
        .listen((event) async {
      if (event.exists && !isOnParty) {
        if (List<String>.from(event.data()!['users'].map((e) => e.toString()))
            .contains(FirebaseAuth.instance.currentUser!.uid)) {
          startParty();
        }
      }
    });
  }

  bool isOnParty = false;

  startParty() async {
    setState(() {
      isOnParty = true;
    });
    await ZegoExpressEngine.destroyEngine();
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    final roomId = widget.uid;

    ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        1181603960,
        ZegoScenario.HighQualityChatroom,
        appSign:
            '5de12f92b097e4d0b3fee8ea25315832053226c5b89182a5bbdd23b271f5ff51',
      ),
    );
    final engine = ZegoExpressEngine.instance;
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
    await engine.setLowlightEnhancement(ZegoLowlightEnhancementMode.On);
    await engine.loginRoom(
      roomId,
      ZegoUser(
        FirebaseAuth.instance.currentUser!.uid,
        controller.user!.name,
      ),
    );
    await engine.startPublishingStream(
      FirebaseAuth.instance.currentUser!.uid,
      config: ZegoPublisherConfig(
        roomID: roomId,
        streamCensorshipMode: ZegoStreamCensorshipMode.AudioAndVideo,
      ),
    );
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  bool isLive = true;
  checkIsLive() {
    FirebaseFirestore.instance
        .collection("User")
        .doc(widget.uid)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        if (mounted) {
          setState(() {
            isLive = event.data()!["isLive"];
          });
        }
      }
    });
  }

  disconnect() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.uid)
        .collection("Party")
        .doc(widget.uid)
        .update({
      "users": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
    });
    await ZegoExpressEngine.destroyEngine();
    Get.back();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!isOnParty) {
          await FirebaseFirestore.instance
              .collection("User")
              .doc(widget.uid)
              .collection("Party")
              .doc(widget.uid)
              .update({
            "inactiveUsers":
                FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
          });
          return true;
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.confirm,
            title: "Are you sure you want to leave the party?",
            confirmBtnText: "Leave",
            cancelBtnText: "Cancel",
            onConfirmBtnTap: () async {
              Get.back();

              disconnect();
            },
          );
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: purple,
        body: Stack(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .doc(uid)
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
                                              stream: FirebaseFirestore.instance
                                                  .collection("User")
                                                  .doc(uid)
                                                  .collection("Party")
                                                  .doc(uid)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                return Text(
                                                  (snapshot.hasData
                                                          ? snapshot
                                                                  .data!.exists
                                                              ? (snapshot.data!
                                                                              .data()![
                                                                          'inactiveUsers'] ??
                                                                      [])
                                                                  .length
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
                                      if (!isfollowing)
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                final me =
                                                    Provider.of<UserController>(
                                                        Get.context!,
                                                        listen: false);
                                                if (me.user == null) {
                                                  await me.getUser();
                                                }
                                                if (me.user!.id == uid) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "You can't follow yourself",
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                  );
                                                  return;
                                                }
                                                await FirebaseFirestore.instance
                                                    .collection('User')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .collection('Following')
                                                    .doc(uid)
                                                    .set({
                                                  "userId": uid,
                                                  "userName": user.name,
                                                  "userImage": user.image,
                                                  "dateTime": DateTime.now()
                                                      .millisecondsSinceEpoch,
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection('User')
                                                    .doc(uid)
                                                    .collection('Followers')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .set({
                                                  "userId": FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                  "userName": me.user!.name,
                                                  "userImage":
                                                      me.user!.image ?? "",
                                                  "dateTime": DateTime.now()
                                                      .millisecondsSinceEpoch,
                                                });
                                                setState(() {
                                                  isfollowing = true;
                                                });
                                                Fluttertoast.showToast(
                                                  msg: "Following ${user.name}",
                                                );
                                              },
                                              child: const CircleAvatar(
                                                radius: 20,
                                                backgroundColor: purple,
                                                child: Center(
                                                  child: Icon(Icons.add),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
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
                              onTap: () {
                                setState(() {
                                  showUser = !showUser;
                                });
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black.withOpacity(0.3),
                                child: const Icon(
                                  Icons.group,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        seatPosition(),
                        const Spacer(),
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
                                onTap: () {
                                  showMoreSheet();
                                },
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
                                  Get.back();
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
            AnimatedPositioned(
              duration: const Duration(milliseconds: 370),
              right: showUser ? 0 : -Get.width,
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: tapper(
                        onTap: () {
                          setState(() {
                            showUser = false;
                          });
                        },
                        child: Container(),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showUser = false;
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: const Icon(
                              MaterialCommunityIcons.chevron_double_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        width: Get.width * 0.5,
                        child: Column(
                          children: const [],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // if (canvasId != 0)
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
            // if (!isLive)
            //   Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         LottieBuilder.asset(
            //           'assets/break.json',
            //           height: 200,
            //         ),
            //       ],
            //     ),
            //   )
          ],
        ),
      ),
    );
  }

  Widget seatPosition() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('User')
          .doc(widget.uid)
          .collection("Party")
          .doc(widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Container();
        }
        final roomLength = snapshot.data!.get('room_length');
        if (roomLength == 10) {
          return GridView.builder(
            padding: const EdgeInsets.only(top: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              if (snapshot.data!.get('users').length <= index) {
                return tapper(
                  onTap: () {
                    if (!isOnParty) {
                      showJoinDialog(index);
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: white.withOpacity(0.1),
                    radius: 40,
                    child: const Icon(
                      MaterialCommunityIcons.sofa_single,
                      color: white,
                    ),
                  ),
                );
              }
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("User")
                    .doc(snapshot.data!.get('users')[index])
                    .snapshots(),
                builder: (context, usersnap) {
                  return CircleAvatar(
                    backgroundColor: white.withOpacity(0.1),
                    radius: 20,
                    backgroundImage: usersnap.hasData == false
                        ? null
                        : usersnap.data!.get('image') == null
                            ? null
                            : NetworkImage(
                                usersnap.data!.get('image'),
                              ) as ImageProvider,
                  );
                },
              );
            },
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
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
            if (snapshot.hasData == false ||
                snapshot.data!.exists == false ||
                snapshot.data!.data()!['users'].length <= index) {
              return GestureDetector(
                onTap: () {
                  showJoinDialog(index);
                },
                child: Container(
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
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? const Radius.circular(10) : Radius.zero,
                  topRight:
                      index == 2 ? const Radius.circular(10) : Radius.zero,
                  bottomLeft:
                      index == 3 ? const Radius.circular(10) : Radius.zero,
                  bottomRight:
                      index == 5 ? const Radius.circular(10) : Radius.zero,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: PreviewWidget(
                uid: snapshot.data!.data()!['users'][index],
                roomId: snapshot.data!.data()!['roomId'],
              ),
            );
          },
        );
      },
    );
  }

  bool showCamera = true;
  showJoinDialog(int index) {
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, state) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Apply to be a Guest",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.all(Colors.green),
                        value: showCamera,
                        onChanged: (value) {
                          state(() {
                            showCamera = value!;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        "Camera ${showCamera ? "On" : "Off"}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: Get.width,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        applyToBeGuest(index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Apply",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  applyToBeGuest(int index) async {
    final me = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.uid)
        .collection('Party')
        .doc(widget.uid)
        .collection('Requests')
        .doc(me.uid)
        .set({
      'uid': me.uid,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
  }

  showMoreSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 42, 40, 40),
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  tapper(
                    onTap: () {
                      Get.back();
                      showGameSheet();
                    },
                    child: optionWidget(
                      title: "Lafa Race",
                      image: const AssetImage('assets/games/racing.png'),
                    ),
                  ),
                  tapper(
                    onTap: () {
                      Get.back();
                      showModalBottomSheet(
                        context: context,
                        barrierColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        isDismissible: true,
                        enableDrag: false,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return const LuckyNumberWidget();
                          });
                        },
                      );
                    },
                    child: optionWidget(
                      title: "Lucky Number",
                      image: const AssetImage('assets/games/number.png'),
                    ),
                  ),
                  tapper(
                    onTap: () {
                      Get.back();
                      Get.to(
                        () => ChatPage(
                          uid: widget.uid,
                        ),
                      );
                    },
                    child: optionWidget(
                      title: "Message",
                      image: const AssetImage('assets/games/chat.png'),
                    ),
                  ),
                  tapper(
                    onTap: () {
                      Get.back();
                    },
                    child: optionWidget(
                      title: "Task",
                      image: const AssetImage('assets/games/task.png'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  tapper(
                    onTap: () {
                      Get.back();
                      Get.to(() => const MyBalanceView());
                    },
                    child: optionWidget(
                      title: "Top Up",
                      image: const AssetImage('assets/games/diamond.png'),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ],
          ),
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
            .doc(widget.uid)
            .collection("Party")
            .doc(widget.uid)
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
        .doc(widget.uid)
        .collection("Party")
        .doc(widget.uid)
        .collection("Messages")
        .add({
      "name": Get.find<UserController>().user!.name,
      "message": messageController.text,
      "time": DateTime.now().millisecondsSinceEpoch,
      "type": "user",
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

  showGameSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 42, 40, 40),
      builder: (_) {
        return const GameSheet();
      },
    );
  }

  Widget optionWidget({
    required String title,
    required ImageProvider image,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.transparent,
          backgroundImage: image,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

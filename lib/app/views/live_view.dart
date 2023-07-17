import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/live_controller.dart';
import 'package:fun_unlimited/app/user_models/user_model.dart';
import 'package:fun_unlimited/app/views/ChatView/chat_page.dart';
import 'package:fun_unlimited/app/views/Game/lucky_number_game.dart';
import 'package:fun_unlimited/app/views/about_view/mybalance_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../Utils/constant.dart';
import '../controllers/UserController/user_controller.dart';
import 'Game/game_sheet.dart';

class LiveView extends StatefulWidget {
  final String uid;
  const LiveView({super.key, required this.uid});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  final controller = Get.put(LiveController());
  bool isfollowing = false;
  bool showUser = false;

  @override
  void initState() {
    super.initState();
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
    startStreaming();
  }

  @override
  void dispose() {
    super.dispose();
    ZegoExpressEngine.instance.logoutRoom();
    ZegoExpressEngine.instance.destroyCanvasView(canvasId);
    ZegoExpressEngine.destroyEngine();
  }

  int canvasId = 0;
  Widget playerWidget = Container();

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

  startStreaming() async {
    ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        1181603960,
        ZegoScenario.Broadcast,
        appSign:
            '5de12f92b097e4d0b3fee8ea25315832053226c5b89182a5bbdd23b271f5ff51',
      ),
    );
    final streamId = widget.uid;
    final engine = ZegoExpressEngine.instance;
    await Get.find<UserController>().getUser();

    final result = await engine.loginRoom(
      streamId,
      ZegoUser(
        FirebaseAuth.instance.currentUser!.uid,
        Get.find<UserController>().user!.name,
      ),
    );
    log(result.errorCode.toString());

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
      ),
    );
    setState(() {
      playerWidget = publisTexture ?? Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          body: Stack(
            children: [
              controller.isLoading.value
                  ? loading()
                  : livewidget(
                      widget.uid,
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
              if (!isLive)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(
                        'assets/break.json',
                        height: 200,
                      ),
                    ],
                  ),
                )
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
            .collection("Live")
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
        .collection("Live")
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

  Widget loading() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
              "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/backgrounds%2Fgradienta-m_7p45JfXQo-unsplash.jpg?alt=media&token=adc01da9-3e54-48af-91c3-d1b303498618"),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            pink,
            purple,
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Center(
          child: LottieBuilder.asset(
            'assets/load2.json',
            repeat: true,
            animate: true,
          ),
        ),
      ),
    );
  }

  Widget livewidget(String uid) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
              "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/backgrounds%2Fgradienta-m_7p45JfXQo-unsplash.jpg?alt=media&token=adc01da9-3e54-48af-91c3-d1b303498618"),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            pink,
            purple,
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Stack(
          children: [
            playerWidget,
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
                                              stream: FirebaseFirestore.instance
                                                  .collection("User")
                                                  .doc(uid)
                                                  .collection("Live")
                                                  .doc(uid)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                return Text(
                                                  (snapshot.hasData
                                                          ? snapshot
                                                                  .data!.exists
                                                              ? snapshot.data!
                                                                  .get("count")
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
                                                await me.getUser();
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
                            tapper(
                              onTap: () {},
                              child: Container(
                                height: 45,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.red,
                                      Colors.purple,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.call,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Call",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
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
            )
          ],
        ),
      ),
    );
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

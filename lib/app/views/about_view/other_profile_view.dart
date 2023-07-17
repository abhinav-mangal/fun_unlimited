import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/CallController/call_controller.dart';
import 'package:fun_unlimited/app/views/ChatView/chat_page.dart';
import 'package:fun_unlimited/app/views/about_view/mybalance_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../controllers/UserController/user_controller.dart';
import '../../user_models/user_model.dart';
import '../mainpage_views/SocialMedia/posts_page.dart';

class OthersProfileView extends StatefulWidget {
  final String userId;
  const OthersProfileView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<OthersProfileView> createState() => _OthersProfileViewState();
}

ValueNotifier<bool> scrolled = ValueNotifier<bool>(false);

class _OthersProfileViewState extends State<OthersProfileView> {
  UserModel? user;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<double> opacityController = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset < 250) {
        opacityController.value =
            double.parse((_scrollController.offset / 250).toStringAsFixed(2));
      }
    });
    getUser();
  }

  getUser() async {
    final data = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.userId)
        .get();
    user = UserModel.fromJson(data.data()!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );
    _scrollController.dispose();
  }

  showInsufficientCoinsDialog(String requiredCoins) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -150,
                right: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: LottieBuilder.asset(
                    'assets/error.json',
                    height: 300,
                    width: 300,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 100,
                    width: 100,
                  ),
                  const Text(
                    "Insufficient Diamonds.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${user!.gender == "Male" ? "His" : "Her"} video call Price: $requiredCoins 💎/min",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.to(() => const MyBalanceView());
                    },
                    child: Container(
                      width: Get.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            pink,
                            purple.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.diamond,
                              color: white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Top Up",
                              style: TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: purple,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Get Free Diamonds",
                        style: TextStyle(
                          color: purple,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
          left: 10,
          right: 10,
          top: 5,
        ),
        child: Row(
          children: [
            Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Get.to(
                    () => ChatPage(
                      uid: widget.userId,
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: purple,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.mail,
                        color: purple,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Message',
                        style: TextStyle(
                          color: purple,
                          fontWeight: FontWeight.bold,
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
            Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("User")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () {
                      if (snapshot.hasData == false) return;
                      final requiredCoins = user!.mychatprice;
                      final myCoins = snapshot.data!.data()!['balance'];
                      if (myCoins < requiredCoins) {
                        showInsufficientCoinsDialog(
                          requiredCoins.toString(),
                        );
                        return;
                      }
                      final callController =
                          Provider.of<CallController>(context, listen: false);
                      callController.call(user!.id);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: purple,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            purple,
                            purple.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.video_call,
                            color: white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Video Call',
                                style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: user!.mychatprice == 0
                                          ? "Free"
                                          : "(${user!.mychatprice.toString()} ",
                                      style: const TextStyle(
                                        color: white,
                                        fontSize: 10,
                                      ),
                                    ),
                                    if (user!.mychatprice != 0)
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.diamond,
                                          color: yellow,
                                          size: 12,
                                        ),
                                      ),
                                    if (user!.mychatprice != 0)
                                      const TextSpan(
                                        text: '/min)',
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 10,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: ExtendedNestedScrollView(
          onlyOneScrollInBody: true,
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            scrolled.value = innerBoxIsScrolled;
            return [
              SliverAppBar(
                title: ValueListenableBuilder<double>(
                  valueListenable: opacityController,
                  builder: (context, value, child) {
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: value > 0.8 ? 1 : value,
                      child: Text(
                        user!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: Get.height * 0.42,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(user!.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                pinned: true,
                expandedHeight: Get.height * 0.42,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 18,
                            color: black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Center(
                            child: Icon(
                              Icons.more_horiz,
                              color: black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    height: 50,
                    child: Row(
                      children: const [
                        TabBar(
                          isScrollable: true,
                          labelColor: purple,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: purple,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelStyle: TextStyle(
                            fontSize: 16,
                          ),
                          tabs: [
                            Tab(
                              text: 'Info',
                            ),
                            Tab(
                              text: 'Moments',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: CachedNetworkImageProvider(
                              user!.image!,
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
                                  user!.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (user!.isLive!)
                                      Container(
                                        height: 20,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: purple.withOpacity(0.7),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Row(
                                          children: [
                                            Lottie.asset(
                                              "assets/live.json",
                                              height: 15,
                                              width: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
                                              "Live",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (user!.isLive!)
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: pink.withOpacity(0.7),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            user!.gender == "Male"
                                                ? Icons.male
                                                : Icons.female,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            user!.dob == ""
                                                ? ""
                                                : calculateAge(
                                                    DateTime.parse(user!.dob),
                                                  ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
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
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('User')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("Following")
                                .where("userId", isEqualTo: user!.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.hasData == false) {
                                    return;
                                  }
                                  if (snapshot.data!.docs.isNotEmpty) {
                                    await FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection('Following')
                                        .doc(user!.id)
                                        .delete();
                                    await FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(user!.id)
                                        .collection('Followers')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .delete();
                                  } else {
                                    final me = Provider.of<UserController>(
                                        Get.context!,
                                        listen: false);
                                    await me.getUser();
                                    await FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection('Following')
                                        .doc(user!.id)
                                        .set({
                                      "userId": user!.id,
                                      "userName": user!.name,
                                      "userImage": user!.image,
                                      "dateTime":
                                          DateTime.now().millisecondsSinceEpoch,
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(user!.id)
                                        .collection('Followers')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .set({
                                      "userId": FirebaseAuth
                                          .instance.currentUser!.uid,
                                      "userName": me.user!.name,
                                      "userImage": me.user!.image,
                                      "dateTime":
                                          DateTime.now().millisecondsSinceEpoch,
                                    });
                                  }
                                },
                                child: (snapshot.hasData &&
                                        snapshot.data!.docs.isNotEmpty)
                                    ? const SizedBox()
                                    : Container(
                                        height: 30,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: purple,
                                            width: 0.3,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: purple,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('User')
                            .doc(user!.id)
                            .collection("SelfIntroduction")
                            .doc("SelfIntroduction")
                            .snapshots(),
                        builder: (context, snapshot) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                snapshot.hasData
                                    ? snapshot.data!.exists
                                        ? snapshot.data!.data()!["title"]
                                        : ""
                                    : "",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              if (snapshot.hasData && snapshot.data!.exists)
                                const SizedBox(
                                  height: 10,
                                ),
                            ],
                          );
                        },
                      ),
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: grey.withOpacity(0.3),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 8,
                                  backgroundImage: NetworkImage(
                                    'https://cdn.britannica.com/97/1597-050-008F30FA/Flag-India.jpg?w=400&h=235&c=crop',
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  user!.country,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: grey.withOpacity(0.3),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 8,
                                  backgroundImage: NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/299/299688.png',
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  user!.language,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Honor",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.lightBlue.withOpacity(0.5),
                                    Colors.lightBlueAccent.withOpacity(0.5),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "https://cdn-icons-png.flaticon.com/512/8853/8853757.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Level",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: purple.withOpacity(0.5),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: CupertinoColors
                                                    .systemYellow,
                                                size: 15,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Lv ${user!.level}",
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow.withOpacity(0.5),
                                    CupertinoColors.systemYellow
                                        .withOpacity(0.5),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "https://cdn-icons-png.flaticon.com/512/6409/6409347.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Top Fans",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "TopFanName",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Gifts - Received",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 10,
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: grey.withOpacity(0.3),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "https://cdn-icons-png.flaticon.com/512/6409/6409347.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Gift Name",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Gifts - Sent",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 10,
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: grey.withOpacity(0.3),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "https://cdn-icons-png.flaticon.com/512/6409/6409347.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Gift Name",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: buildMoments(user!.id, isProfile: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    int month1 = now.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = now.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }
}

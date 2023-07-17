import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/user_models/user_model.dart';
import 'package:fun_unlimited/app/views/about_view/followers_page.dart';
import 'package:fun_unlimited/app/views/about_view/followings_page.dart';
import 'package:fun_unlimited/app/views/about_view/mybalance_view.dart';
import 'package:fun_unlimited/app/views/about_view/mychatprice_view.dart';
import 'package:fun_unlimited/app/views/about_view/myearning_view.dart';
import 'package:fun_unlimited/app/views/about_view/mylavel_view.dart';
import 'package:fun_unlimited/app/views/about_view/myprofile_view.dart';
import 'package:fun_unlimited/app/views/about_view/mytask_view.dart';
import 'package:fun_unlimited/app/views/about_view/setting_view.dart';
import 'package:get/get.dart';

import '../../../Utils/constant.dart';
import '../../../common_widgets/common_colors.dart';
import '../../ChatView/my_chats.dart';

class AboutView extends GetView {
  @override
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        automaticallyImplyLeading: false,
        backgroundColor: appbarcolor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final user = UserModel.fromJson(snapshot.data!.data()!);
                return Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const MyProfileView());
                      },
                      child: Hero(
                        tag: "profile",
                        child: CircleAvatar(
                          backgroundColor: white,
                          radius: 25,
                          backgroundImage: NetworkImage(
                            user.image ?? defaultImage,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("User")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Friends")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return TextButton(
                      onPressed: () {},
                      child: Text(
                        "${snapshot.hasData ? snapshot.data!.docs.length : 0}\nFriends",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          color: black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("User")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Following")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return TextButton(
                      onPressed: () {
                        Get.to(() => const FollowingsPage());
                      },
                      child: Text(
                        "${snapshot.hasData ? snapshot.data!.docs.length : 0}\nFollowing",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          color: black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("User")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Followers")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return TextButton(
                      onPressed: () {
                        Get.to(() => const FollowersPage());
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(trans),
                      ),
                      child: Text(
                        "${snapshot.hasData ? snapshot.data!.docs.length : 0}\nFollowers",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          color: black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("User")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = UserModel.fromJson(snapshot.data!.data()!);
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const MyChatsPage());
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: pink.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Ionicons.chatbubble_ellipses,
                        color: pink,
                      ),
                    ),
                    title: const Text(
                      "Messages",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const MylevelView());
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: yellow.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Fontisto.vimeo,
                        color: yellow.withGreen(200),
                        size: 20,
                      ),
                    ),
                    title: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "My Level",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "Lvl ${user.level}",
                          style: const TextStyle(
                            color: black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const MyBalanceView());
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 157, 146, 50)
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.diamond,
                        color: CupertinoColors.activeOrange,
                      ),
                    ),
                    title: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "My Balance",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "${user.balance}",
                          style: const TextStyle(
                            color: orange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.diamond,
                          color: CupertinoColors.activeOrange,
                          size: 15,
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const MyTaskView());
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: yellow.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Ionicons.md_calendar,
                        color: CupertinoColors.activeGreen,
                      ),
                    ),
                    title: const Text(
                      "My Tasks",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: yellow.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Ionicons.gift,
                        color: CupertinoColors.systemYellow,
                      ),
                    ),
                    title: const Text(
                      "My Invitation",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const MyProfileView());
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: purple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.face,
                        color: purple,
                      ),
                    ),
                    title: const Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const MyEarningView());
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: purple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.currency_rupee,
                        color: purple,
                      ),
                    ),
                    title: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            "My Earning",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'CashOut',
                          style: TextStyle(
                            color: grey,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const MyChatPriceView());
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: purple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        FontAwesome5Solid.comment_dollar,
                        color: purple,
                      ),
                    ),
                    title: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "My Chat Price",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "${user.mychatprice}",
                          style: const TextStyle(
                            color: grey,
                            fontSize: 11,
                          ),
                        ),
                        const Icon(
                          Icons.diamond,
                          color: CupertinoColors.activeOrange,
                          size: 15,
                        ),
                        const Text(
                          "/min",
                          style: TextStyle(
                            color: grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => SettingView());
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: purple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: purple,
                      ),
                    ),
                    title: const Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: grey,
                      size: 15,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

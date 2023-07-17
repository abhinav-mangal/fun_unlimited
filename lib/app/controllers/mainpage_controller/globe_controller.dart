import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/Model/post_model.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/UserController/user_controller.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GlobeController extends GetxController {
  late TabController tabController;

  List<Tab> toptab = <Tab>[
    const Tab(
      text: "Moment",
    ),
    const Tab(
      text: "Group",
    ),
  ];

  showSheetForReport(PostModel post) {
    final isMe = post.userId == FirebaseAuth.instance.currentUser!.uid;
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: 200,
        child: Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isMe ? Icons.edit : MaterialCommunityIcons.share,
                    color: purple,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(isMe ? "Edit Post" : "Share to Group"),
                ],
              ),
              onTap: () {
                // reportPost(post);
              },
            ),
            Divider(
              thickness: 1,
              color: ppurple1.withOpacity(0.2),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isMe ? Icons.delete : Icons.report,
                    color: ppurple1,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(isMe ? "Delete Post" : "Report Post"),
                ],
              ),
              onTap: () {},
            ),
            Divider(
              thickness: 8,
              color: ppurple1.withOpacity(0.2),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Cancel"),
                ],
              ),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  likePost(PostModel post) async {
    final postId = post.id;
    final user = Provider.of<UserController>(Get.context!, listen: false);
    final data = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (data.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .collection('Likes')
          .add(
            Likes(
              userId: FirebaseAuth.instance.currentUser!.uid,
              userName: user.user!.name,
              userImage: user.user!.image!,
              dateTime: DateTime.now().millisecondsSinceEpoch,
            ).toJson(),
          );
    } else {
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .collection('Likes')
          .doc(data.docs.first.id)
          .delete();
    }
  }

  commentOnPost(
    PostModel post, {
    required String comment,
  }) async {
    final postId = post.id;
    final user = Provider.of<UserController>(Get.context!, listen: false);
    await user.getUser();
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .add(
          Comments(
            id: "",
            userId: FirebaseAuth.instance.currentUser!.uid,
            userName: user.user!.name,
            userImage: user.user!.image!,
            dateTime: DateTime.now().millisecondsSinceEpoch,
            comment: comment,
          ).toJson(),
        )
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .collection("Comments")
          .doc(value.id)
          .update({
        "id": value.id,
      });
    });
  }

  likeComment(
    String postId,
    String commentId,
  ) async {
    final user = Provider.of<UserController>(Get.context!, listen: false);
    await user.getUser();
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .doc(commentId)
        .collection('Likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
          Likes(
            userId: FirebaseAuth.instance.currentUser!.uid,
            userName: user.user!.name,
            userImage: user.user!.image!,
            dateTime: DateTime.now().millisecondsSinceEpoch,
          ).toJson(),
        );
  }

  unlikeComment(
    String postId,
    String commentId,
  ) async {
    final user = Provider.of<UserController>(Get.context!, listen: false);
    await user.getUser();
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .doc(commentId)
        .collection('Likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }

  followUser({
    required PostModel post,
  }) async {
    final user = Provider.of<UserController>(Get.context!, listen: false);
    await user.getUser();
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Following')
        .doc(post.userId)
        .set({
      "userId": post.userId,
      "userName": post.userName,
      "userImage": post.userImage,
      "dateTime": DateTime.now().millisecondsSinceEpoch,
    });
    await FirebaseFirestore.instance
        .collection('User')
        .doc(post.userId)
        .collection('Followers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "userName": user.user!.name,
      "userImage": user.user!.image ?? "",
      "dateTime": DateTime.now().millisecondsSinceEpoch,
    });
  }

  unfollowUser({
    required PostModel post,
  }) async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Following')
        .doc(post.userId)
        .delete();
    await FirebaseFirestore.instance
        .collection('User')
        .doc(post.userId)
        .collection('Followers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }
}

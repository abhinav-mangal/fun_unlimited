import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/Model/post_model.dart';
import 'package:fun_unlimited/app/views/about_view/myprofile_view.dart';
import 'package:fun_unlimited/app/views/about_view/other_profile_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/SocialMedia/reply_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/common_colors.dart';
import '../../../controllers/mainpage_controller/globe_controller.dart';

class CommentsPage extends StatefulWidget {
  final PostModel postModel;
  const CommentsPage({
    Key? key,
    required this.postModel,
  }) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final controller = Get.put(GlobeController());
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Moment',
          style: TextStyle(
            color: black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: white,
          statusBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: black,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.postModel.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final post = PostModel.fromJson(snapshot.data!.data()!);
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        decoration: const BoxDecoration(
                          color: white,
                        ),
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: grey.withOpacity(0.2),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(post.userId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return CachedNetworkImage(
                                        imageUrl: snapshot.hasData
                                            ? snapshot.data!.data()!['image']
                                            : post.userImage,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          color: grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.userName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 9,
                                            backgroundColor: purple,
                                            backgroundImage: NetworkImage(
                                              "https://cdn.britannica.com/97/1597-050-008F30FA/Flag-India.jpg?w=400&h=235&c=crop",
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const CircleAvatar(
                                            radius: 9,
                                            backgroundColor: purple,
                                            backgroundImage: NetworkImage(
                                              "https://as2.ftcdn.net/v2/jpg/02/73/47/17/1000_F_273471769_djMJxYbSPmIBuxVlqJs5tkyljjyKvxxP.jpg",
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: purple.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 2,
                                              horizontal: 5,
                                            ),
                                            height: 18,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const ImageIcon(
                                                  NetworkImage(
                                                    "https://cdn.pixabay.com/photo/2016/04/22/14/32/star-1345884_1280.png",
                                                  ),
                                                  size: 10,
                                                ),
                                                StreamBuilder<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('User')
                                                      .doc(post.userId)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    return Text(
                                                      " Lvl ${snapshot.hasData ? snapshot.data!.data()!['level'] : 0}",
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    ],
                                  ),
                                ),
                                if (post.userId !=
                                    FirebaseAuth.instance.currentUser!.uid)
                                  StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('User')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("Following")
                                          .where("userId",
                                              isEqualTo: post.userId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (snapshot.hasData == false) {
                                              return;
                                            }
                                            if (snapshot
                                                .data!.docs.isNotEmpty) {
                                              controller.unfollowUser(
                                                  post: post);
                                            } else {
                                              controller.followUser(post: post);
                                            }
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              // color: grey.withOpacity(0.2),
                                              border: Border.all(
                                                color: purple,
                                                width: 0.3,
                                              ),
                                            ),
                                            child: Icon(
                                              snapshot.hasData &&
                                                      snapshot
                                                          .data!.docs.isNotEmpty
                                                  ? Icons.check
                                                  : Icons.add,
                                              color: purple,
                                            ),
                                          ),
                                        );
                                      }),
                                CupertinoButton(
                                  onPressed: () {
                                    controller.showSheetForReport(post);
                                  },
                                  padding: EdgeInsets.zero,
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              DateFormat('dd MMM, HH:MM a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  post.dateTime,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: grey,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Html(
                              data: post.title,
                            ),
                            if (post.images.isNotEmpty)
                              const SizedBox(
                                height: 10,
                              ),
                            if (post.images.isNotEmpty &&
                                post.images.length == 1)
                              Container(
                                width: Get.width,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: grey.withOpacity(0.2),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: CachedNetworkImage(
                                  imageUrl: post.images.first,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: grey,
                                    ),
                                  ),
                                ),
                              ),
                            if (post.images.isNotEmpty &&
                                post.images.length == 2)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: grey.withOpacity(0.2),
                                        ),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: CachedNetworkImage(
                                          imageUrl: post.images.first,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Icon(
                                              Icons.image,
                                              size: 50,
                                              color: grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: grey.withOpacity(0.2),
                                        ),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: CachedNetworkImage(
                                          imageUrl: post.images.last,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Icon(
                                              Icons.image,
                                              size: 50,
                                              color: grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (post.images.isNotEmpty &&
                                post.images.length == 3)
                              SizedBox(
                                height: 400,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 150,
                                          width: Get.width,
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: grey.withOpacity(0.2),
                                          ),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: CachedNetworkImage(
                                            imageUrl: post.images.first,
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Padding(
                                              padding: EdgeInsets.all(20.0),
                                              child: Icon(
                                                Icons.image,
                                                size: 50,
                                                color: grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: 150,
                                            width: Get.width / 2 - 20,
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: grey.withOpacity(0.2),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: CachedNetworkImage(
                                              imageUrl: post.images[1],
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Padding(
                                                padding: EdgeInsets.all(20.0),
                                                child: Icon(
                                                  Icons.image,
                                                  size: 50,
                                                  color: grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 150,
                                            width: Get.width / 2 - 20,
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: grey.withOpacity(0.2),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: CachedNetworkImage(
                                              imageUrl: post.images.last,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Padding(
                                                padding: EdgeInsets.all(20.0),
                                                child: Icon(
                                                  Icons.image,
                                                  size: 50,
                                                  color: grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (post.images.isNotEmpty &&
                                post.images.length == 4)
                              GridView.count(
                                padding: const EdgeInsets.only(right: 10),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                children: List.generate(
                                  post.images.length,
                                  (index) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: grey.withOpacity(0.2),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: CachedNetworkImage(
                                      imageUrl: post.images[index],
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Icon(
                                          Icons.image,
                                          size: 50,
                                          color: grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (post.images.isNotEmpty &&
                                post.images.length > 4)
                              GridView.builder(
                                padding: const EdgeInsets.only(right: 10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                itemBuilder: (context, index) => Stack(
                                  fit: StackFit.expand,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: grey.withOpacity(0.2),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: CachedNetworkImage(
                                        imageUrl: post.images[index],
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Icon(
                                            Icons.image,
                                            size: 50,
                                            color: grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (index == 3)
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: black.withOpacity(0.5),
                                        ),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Center(
                                          child: Text(
                                            '+${post.images.length - 4}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {},
                                  child: StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("Posts")
                                          .doc(post.id)
                                          .collection("Gifts")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Icon(
                                              Ionicons.gift_outline,
                                              color: grey,
                                            ),
                                            Text(
                                              snapshot.hasData
                                                  ? snapshot.data!.docs.length
                                                      .toString()
                                                  : "0",
                                              style: const TextStyle(
                                                color: grey,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection("Posts")
                                        .doc(post.id)
                                        .collection("Likes")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const CupertinoButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: null,
                                          child: Icon(
                                            AntDesign.like2,
                                            color: grey,
                                          ),
                                        );
                                      }
                                      final likes = snapshot.data!.docs
                                          .map((e) => Likes.fromJson(e.data()))
                                          .toList();
                                      bool liked = likes.any(
                                        (element) =>
                                            element.userId ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                      );
                                      return CupertinoButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          controller.likePost(post);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Icon(
                                              liked
                                                  ? AntDesign.like1
                                                  : AntDesign.like2,
                                              color: liked ? purple : grey,
                                            ),
                                            Text(
                                              likes.length.toString(),
                                              style: const TextStyle(
                                                color: grey,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {},
                                  child: StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("Posts")
                                          .doc(post.id)
                                          .collection("Comments")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Icon(
                                              Ionicons.chatbox_outline,
                                              color: grey,
                                            ),
                                            Text(
                                              snapshot.hasData
                                                  ? snapshot.data!.docs.length
                                                      .toString()
                                                  : "0",
                                              style: const TextStyle(
                                                color: grey,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 8,
                        color: purple.withOpacity(0.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: const [
                            Text(
                              "Comments",
                              style: TextStyle(
                                color: black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Posts")
                            .doc(post.id)
                            .collection("Comments")
                            .where('id', isNotEqualTo: "")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<Comments> comments = snapshot.data!.docs
                              .map((e) => Comments.fromJson(e.data()))
                              .toList();
                          comments
                              .sort((a, b) => b.dateTime.compareTo(a.dateTime));
                          return ListView.builder(
                            itemCount: comments.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return commentWidget(
                                comment: comments[index],
                                postId: post.id,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: grey.withOpacity(0.2),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write a comment...",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () async {
                        if (commentController.text.isEmpty) {
                          return;
                        }
                        FocusScope.of(context).unfocus();
                        await controller.commentOnPost(
                          post,
                          comment: commentController.text,
                        );
                        commentController.clear();
                      },
                      child: const Icon(
                        Ionicons.send_outline,
                        color: grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget commentWidget({
    required Comments comment,
    required String postId,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("User")
              .doc(comment.userId)
              .snapshots(),
          builder: (context, snapshot) {
            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (comment.userId ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      Get.to(() => const MyProfileView());
                      return;
                    }
                    Get.to(() => OthersProfileView(
                          userId: comment.userId,
                        ));
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(snapshot.hasData
                        ? snapshot.data!.data() != null
                            ? snapshot.data!.data()!["image"]
                            : comment.userImage
                        : comment.userImage),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.userName,
                            style: const TextStyle(
                              color: black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            getTimeName(DateTime.fromMillisecondsSinceEpoch(
                                comment.dateTime)),
                            style: const TextStyle(
                              color: grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        comment.comment,
                        style: const TextStyle(
                          color: grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("Posts")
                              .doc(postId)
                              .collection("Comments")
                              .doc(comment.id)
                              .collection("Likes")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return GestureDetector(
                              onTap: () {
                                if (snapshot.hasData && snapshot.data!.exists) {
                                  controller.unlikeComment(
                                    postId,
                                    comment.id,
                                  );
                                } else if (snapshot.hasData &&
                                    !snapshot.data!.exists) {
                                  controller.likeComment(
                                    postId,
                                    comment.id,
                                  );
                                }
                              },
                              child: Icon(
                                snapshot.hasData == false
                                    ? AntDesign.like2
                                    : snapshot.data!.exists == false
                                        ? AntDesign.like2
                                        : AntDesign.like1,
                                color: snapshot.hasData == false
                                    ? grey
                                    : snapshot.data!.exists == false
                                        ? grey
                                        : purple,
                                size: 20,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Get.bottomSheet(
                              ReplyPage(
                                postId: postId,
                                comment: comment,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              isDismissible: false,
                            );
                          },
                          child: const Icon(
                            Ionicons.chatbox_outline,
                            color: grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  String getTimeName(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return "${difference.inDays}d";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m";
    } else {
      return "${difference.inSeconds}s";
    }
  }
}

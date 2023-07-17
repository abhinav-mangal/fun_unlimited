import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/Model/post_model.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/UserController/user_controller.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ReplyPage extends StatefulWidget {
  final String? postId;
  final Comments? comment;
  const ReplyPage({Key? key, this.postId, this.comment}) : super(key: key);

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      width: Get.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.clear),
              ),
              const Spacer(),
              const Text(
                "Comments",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 30,
                height: 30,
              ),
            ],
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: purple,
                  backgroundImage: widget.comment!.userImage != ''
                      ? NetworkImage(widget.comment!.userImage)
                      : null,
                  child: widget.comment!.userImage == ''
                      ? Text(
                          widget.comment!.userName.substring(0, 1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment!.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.comment!.comment,
                        style: const TextStyle(
                          fontSize: 13,
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
          Divider(
            thickness: 5,
            color: ppurple1.withOpacity(0.5),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Posts')
                  .doc(widget.postId)
                  .collection('Comments')
                  .doc(widget.comment!.id)
                  .collection('Replies')
                  .orderBy('dateTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Comments"),
                  );
                }
                final comments = snapshot.data!.docs
                    .map((e) => Comments.fromJson(e.data()))
                    .toList();
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return commentWidget(
                      comment: comments[index],
                      postId: widget.postId!,
                    );
                  },
                );
              },
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
                    color: ppurple1.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a comment",
                      hintStyle: TextStyle(
                        color: grey,
                        fontSize: 12,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              CupertinoButton(
                onPressed: () {
                  sendComment();
                },
                child: const Icon(
                  FontAwesome.send_o,
                  color: purple,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sendComment() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (commentController.text.isNotEmpty) {
      final userController =
          Provider.of<UserController>(context, listen: false);
      await userController.getUser();
      final comment = Comments(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        comment: commentController.text,
        dateTime: DateTime.now().millisecondsSinceEpoch,
        userId: FirebaseAuth.instance.currentUser!.uid,
        userName: userController.user!.name,
        userImage: userController.user!.image!,
      );
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.postId)
          .collection('Comments')
          .doc(widget.comment!.id)
          .collection('Replies')
          .doc(comment.id)
          .set(comment.toJson());
      commentController.clear();
    }
  }

  Widget commentWidget({
    required Comments comment,
    required String postId,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(comment.userImage),
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
        ],
      ),
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

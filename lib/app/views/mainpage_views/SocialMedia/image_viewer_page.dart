import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/Model/post_model.dart';
import 'package:fun_unlimited/app/controllers/mainpage_controller/globe_controller.dart';
import 'package:get/get.dart';

import '../../../common_widgets/common_colors.dart';
import 'comments_page.dart';

class ImageViewer extends StatefulWidget {
  final List<String> images;
  final PostModel post;
  final int index;
  const ImageViewer({
    Key? key,
    required this.images,
    required this.index,
    required this.post,
  }) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool showtopBottom = true;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = PageController(initialPage: widget.index);
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dy > 2000) {
                    Get.back();
                  }
                },
                child: EasyImageView(
                  doubleTapZoomable: true,
                  imageProvider: CachedNetworkImageProvider(
                    widget.images[index],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              height: 50,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        widget.post.title,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("Posts")
                            .doc(widget.post.id)
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
                                FirebaseAuth.instance.currentUser!.uid,
                          );
                          return CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              final postController =
                                  Get.find<GlobeController>();
                              postController.likePost(widget.post);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  liked ? AntDesign.like1 : AntDesign.like2,
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
                      onPressed: () {
                        Get.to(
                          () => CommentsPage(
                            postModel: widget.post,
                          ),
                        );
                      },
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("Posts")
                              .doc(widget.post.id)
                              .collection("Comments")
                              .snapshots(),
                          builder: (context, snapshot) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Icon(
                                  Ionicons.chatbox_outline,
                                  color: grey,
                                ),
                                Text(
                                  snapshot.hasData
                                      ? snapshot.data!.docs.length.toString()
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

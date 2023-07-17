import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/views/about_view/myprofile_view.dart';
import 'package:fun_unlimited/app/views/about_view/other_profile_view.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../Model/post_model.dart';
import '../../../../common_widgets/common_colors.dart';
import '../../../../controllers/mainpage_controller/globe_controller.dart';
import '../comments_page.dart';
import '../image_viewer_page.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.post,
    required this.controller,
  });

  final PostModel post;
  final GlobeController controller;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.post.videos.isNotEmpty) {
      _controller = VideoPlayerController.network(widget.post.videos[0])
        ..initialize().then((_) {
          _controller.setLooping(true);
          setState(() {
            isInitialized = true;
          });
        });
    }
  }

  bool isInitialized = false;

  @override
  void dispose() {
    super.dispose();
    if (widget.post.videos.isNotEmpty) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 0 && mounted && isInitialized) {
          _controller.pause();
        } else if (mounted && isInitialized) {
          _controller.play();
        }
      },
      child: Container(
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
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('User')
                      .doc(widget.post.userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () {
                        if (FirebaseAuth.instance.currentUser!.uid ==
                            widget.post.userId) {
                          Get.to(() => const MyProfileView());
                        } else {
                          Get.to(
                            () => OthersProfileView(
                              userId: widget.post.userId,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: grey.withOpacity(0.2),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          imageUrl: snapshot.hasData
                              ? snapshot.data!.get('image')
                              : widget.post.userImage,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            color: grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (FirebaseAuth.instance.currentUser!.uid ==
                          widget.post.userId) {
                        Get.to(() => const MyProfileView());
                      } else {
                        Get.to(
                          () => OthersProfileView(
                            userId: widget.post.userId,
                          ),
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('User')
                              .doc(widget.post.userId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.hasData
                                  ? snapshot.data!.get('name')
                                  : widget.post.userName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
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
                                borderRadius: BorderRadius.circular(30),
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
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection("User")
                                        .doc(widget.post.userId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        " Lvl ${snapshot.hasData ? snapshot.data!.get('level') : 0}",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
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
                ),
                if (widget.post.userId !=
                    FirebaseAuth.instance.currentUser!.uid)
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('User')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("Following")
                        .where("userId", isEqualTo: widget.post.userId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: () {
                          if (snapshot.hasData == false) {
                            return;
                          }
                          if (snapshot.data!.docs.isNotEmpty) {
                            widget.controller.unfollowUser(post: widget.post);
                          } else {
                            widget.controller.followUser(post: widget.post);
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // color: grey.withOpacity(0.2),
                            border: Border.all(
                              color: purple,
                              width: 0.3,
                            ),
                          ),
                          child: Icon(
                            snapshot.hasData && snapshot.data!.docs.isNotEmpty
                                ? Icons.check
                                : Icons.add,
                            color: purple,
                          ),
                        ),
                      );
                    },
                  ),
                CupertinoButton(
                  onPressed: () {
                    widget.controller.showSheetForReport(widget.post);
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
              height: 10,
            ),
            Html(
              data: widget.post.title,
            ),
            if (widget.post.videos.isNotEmpty && widget.post.videos.length == 1)
              const SizedBox(
                height: 10,
              ),
            if (widget.post.videos.isNotEmpty && widget.post.videos.length == 1)
              if (isInitialized)
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: grey.withOpacity(0.2),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () {
                      // Get.to(
                      //   () => VideoPlayerScreen(
                      //     videoUrl: post.videos.first,
                      //   ),
                      // );
                    },
                    child: _controller.value.isInitialized
                        ? Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _controller.value.volume == 0
                                          ? _controller.setVolume(1)
                                          : _controller.setVolume(0);
                                    });
                                  },
                                  child: Icon(
                                    _controller.value.volume == 0
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                    color: white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                )
              else
                Container(
                  height: 200,
                  width: Get.width,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: grey.withOpacity(0.2),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            if (widget.post.images.isNotEmpty)
              const SizedBox(
                height: 10,
              ),
            if (widget.post.images.isNotEmpty && widget.post.images.length == 1)
              Container(
                width: Get.width,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: grey.withOpacity(0.2),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => ImageViewer(
                        images: widget.post.images,
                        index: 0,
                        post: widget.post,
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.post.images.first,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Padding(
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
            if (widget.post.images.isNotEmpty && widget.post.images.length == 2)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey.withOpacity(0.2),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => ImageViewer(
                                images: widget.post.images,
                                index: 0,
                                post: widget.post,
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: widget.post.images.first,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Padding(
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
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey.withOpacity(0.2),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => ImageViewer(
                                images: widget.post.images,
                                index: 1,
                                post: widget.post,
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: widget.post.images.last,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Padding(
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
                  ],
                ),
              ),
            if (widget.post.images.isNotEmpty && widget.post.images.length == 3)
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
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: grey.withOpacity(0.2),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                () => ImageViewer(
                                  images: widget.post.images,
                                  index: 0,
                                  post: widget.post,
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: widget.post.images.first,
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
                      Row(
                        children: [
                          Container(
                            height: 150,
                            width: Get.width / 2 - 20,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: grey.withOpacity(0.2),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => ImageViewer(
                                    images: widget.post.images,
                                    index: 1,
                                    post: widget.post,
                                  ),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: widget.post.images[1],
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
                          Container(
                            height: 150,
                            width: Get.width / 2 - 20,
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: grey.withOpacity(0.2),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => ImageViewer(
                                    images: widget.post.images,
                                    index: 2,
                                    post: widget.post,
                                  ),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: widget.post.images.last,
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
                    ],
                  ),
                ),
              ),
            if (widget.post.images.isNotEmpty && widget.post.images.length == 4)
              GridView.count(
                padding: const EdgeInsets.only(right: 10),
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: List.generate(
                  widget.post.images.length,
                  (index) => InkWell(
                    onTap: () {
                      Get.to(
                        () => ImageViewer(
                          images: widget.post.images,
                          index: index,
                          post: widget.post,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: grey.withOpacity(0.2),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                        imageUrl: widget.post.images[index],
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Padding(
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
              ),
            if (widget.post.images.isNotEmpty && widget.post.images.length > 4)
              GridView.builder(
                padding: const EdgeInsets.only(right: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => ImageViewer(
                            images: widget.post.images,
                            index: index,
                            post: widget.post,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey.withOpacity(0.2),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          imageUrl: widget.post.images[index],
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Padding(
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
                    if (index == 3)
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => ImageViewer(
                              images: widget.post.images,
                              index: index,
                              post: widget.post,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: black.withOpacity(0.5),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Center(
                            child: Text(
                              '+${widget.post.images.length - 4}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(widget.post.id)
                          .collection("Gifts")
                          .snapshots(),
                      builder: (context, snapshot) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Ionicons.gift_outline,
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
                const SizedBox(
                  width: 10,
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
                          widget.controller.likePost(widget.post);
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
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

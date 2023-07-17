import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/mainpage_controller/globe_controller.dart';
import 'package:fun_unlimited/app/views/mainpage_views/SocialMedia/GroupSection/group_page.dart';
import 'package:fun_unlimited/app/views/mainpage_views/SocialMedia/UploadPost/upload_post_page.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';

import '../../../Model/post_model.dart';
import 'UploadPost/camer_page.dart';
import 'Widgets/post_widget.dart';

class SocialView extends GetView<GlobeController> {
  @override
  final controller = Get.put(GlobeController());
  SocialView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                tabs: controller.toptab,
                indicatorColor: trans,
                isScrollable: true,
                labelColor: purple,
                unselectedLabelColor: black,
                labelStyle: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Scaffold(
                      backgroundColor: ppurple1.withOpacity(0.2),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () async {
                          showUploadPostDialog(context);
                        },
                        backgroundColor: purple,
                        child: const Icon(
                          FontAwesome.send_o,
                          color: white,
                        ),
                      ),
                      body: buildMoments(null),
                    ),

                    // Tis is Group Tab view
                    const GroupPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImages() async {
    final pickedImages = await ImagesPicker.pick(
      count: 100,
    );
    if (pickedImages != null) {
      Get.to(
        () => UploadPostPage(
          images: pickedImages.map((e) => File(e.path)).toList(),
        ),
      );
    }
  }

  pickVideos() async {
    final pickedImages = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.video,
    );
    if (pickedImages != null) {
      Get.to(
        () => UploadPostPage(
          videos: pickedImages.map((e) => e.path).toList(),
          thumbnails: pickedImages.map((e) => e.thumbPath!).toList(),
        ),
      );
    }
  }

  showUploadPostDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Container(
          height: 150,
          width: Get.width,
          decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton(
                onPressed: () async {
                  Get.back();
                  Get.to(() => const CameraPage());
                },
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: purple,
                      child: Icon(
                        FontAwesome.camera,
                        color: white,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Camera",
                      style: TextStyle(
                        color: black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                onPressed: () async {
                  Get.back();
                  pickImages();
                },
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: purple,
                      child: Icon(
                        FontAwesome.picture_o,
                        color: white,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Photo",
                      style: TextStyle(
                        color: black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  Get.back();
                  pickVideos();
                },
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: purple,
                      child: Icon(
                        FontAwesome.video_camera,
                        color: white,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Video",
                      style: TextStyle(
                        color: black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildMoments(String? uid, {bool isProfile = false}) {
  final controller = Get.find<GlobeController>();
  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: uid == null
        ? FirebaseFirestore.instance.collection('Posts').snapshots()
        : FirebaseFirestore.instance
            .collection('Posts')
            .where('userId', isEqualTo: uid)
            .snapshots(),
    builder: (context, snapshot) {
      return FirestorePagination(
        shrinkWrap: true,
        onEmpty: Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: isProfile ? Get.height * 0.2 : 0,
            ),
            child: const Text(
              'No Posts',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        physics: isProfile
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        padding: uid != null ? EdgeInsets.zero : null,
        query: uid == null
            ? FirebaseFirestore.instance
                .collection('Posts')
                .orderBy('dateTime', descending: true)
            : FirebaseFirestore.instance
                .collection('Posts')
                .where('userId', isEqualTo: uid),
        isLive: true,
        separatorBuilder: (context, index) => const SizedBox(
          height: 7,
        ),
        itemBuilder: (context, documentSnapshot, index) {
          final post = PostModel.fromJson(
            documentSnapshot.data() as Map<String, dynamic>,
          );

          return PostWidget(
            post: post,
            controller: controller,
          );
        },
      );
    },
  );
}

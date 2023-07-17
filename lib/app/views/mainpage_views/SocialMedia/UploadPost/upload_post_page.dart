import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_unlimited/app/Model/post_model.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/UserController/user_controller.dart';
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../video_player_screen.dart';

class UploadPostPage extends StatefulWidget {
  final List<File> images;
  final List<String> videos;
  final List<String> thumbnails;
  const UploadPostPage({
    Key? key,
    this.images = const [],
    this.videos = const [],
    this.thumbnails = const [],
  }) : super(key: key);

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final titleController = TextEditingController();

  uploadPost() async {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Uploading...",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
    List<String> imagesUrl = [];
    if (widget.images.isNotEmpty) {
      for (File image in widget.images) {
        final url = await uploadImage(image);
        imagesUrl.add(url);
      }
    }
    List<String> videosUrl = [];
    if (widget.videos.isNotEmpty) {
      for (var video in widget.videos) {
        final url = await uploadVideo(video);
        videosUrl.add(url);
      }
    }
    // upload post
    final user = Get.find<UserController>().user;
    await FirebaseFirestore.instance
        .collection("Posts")
        .add(
          PostModel(
            id: "",
            title: titleController.text,
            description: '',
            images: imagesUrl,
            userName: user!.name,
            userImage: user.image!,
            userId: user.id,
            dateTime: DateTime.now().millisecondsSinceEpoch,
            videos: videosUrl,
          ).toJson(),
        )
        .then(
      (value) async {
        await FirebaseFirestore.instance
            .collection("Posts")
            .doc(value.id)
            .update(
          {
            "id": value.id,
          },
        );
        await FirebaseFirestore.instance
            .collection("User")
            .doc(user.id)
            .collection("Posts")
            .doc(value.id)
            .set(
              PostModel(
                id: value.id,
                title: titleController.text,
                description: '',
                images: imagesUrl,
                userName: user.name,
                userImage: user.image!,
                userId: user.id,
                dateTime: DateTime.now().millisecondsSinceEpoch,
                videos: videosUrl,
              ).toJson(),
            );
        Get.back();
        Get.back();
        Fluttertoast.showToast(
          msg: "Post Uploaded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
    );
  }

  uploadImage(File image) async {
    final String fileName = image.path.split('/').last;
    final ref = FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = ref.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  uploadVideo(String video) async {
    final String fileName = video.split('/').last;
    final ref = FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = ref.putFile(File(video));
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text(
          'Moment',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        actions: const [],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: TextField(
                      maxLines: 5,
                      controller: titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Write something about your moment",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Posts",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (widget.images.isNotEmpty)
                    SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(widget.images[index]),
                                    fit: BoxFit.contain,
                                  ),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                width: 100,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.images.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  if (widget.videos.isNotEmpty)
                    SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.videos.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                width: 100,
                                child: Image.file(
                                  File(widget.thumbnails[index]),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.videos.removeAt(index);
                                      widget.thumbnails.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => VideoPlayerScreen(
                                        videoUrl: widget.videos[index],
                                        isFile: true,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: Get.width * 0.95,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  uploadPost();
                } else {
                  Get.snackbar(
                    "Error",
                    "Please enter title",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text(
                "Post",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
  }

  Future<Uint8List?> getThumbnail(String path) async {
    final data = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
    return data;
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/Model/chat_model.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/controllers/ChatController/chat_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ChatPage extends StatefulWidget {
  final ChatModel? chatModel;
  final String uid;

  const ChatPage({
    Key? key,
    this.chatModel,
    required this.uid,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController controller;
  FocusNode? messageController;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    messageController = FocusNode();
    controller = Provider.of<ChatController>(context, listen: false);
    controller.setData(
      senderid: FirebaseAuth.instance.currentUser!.uid,
      receiverid: widget.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(
      builder: (BuildContext context, chatter, Widget? child) {
        if (chatter.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              chatter.receiver!.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("User")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Chats")
                      .doc(widget.uid)
                      .collection("Messages")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData == false) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Messages Yet!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat("hh:mm a").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(
                                      snapshot.data!.docs[index]['time'],
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final message = MessageModel.fromJson(
                          snapshot.data!.docs[index].data(),
                        );
                        bool isMe = message.senderId ==
                            FirebaseAuth.instance.currentUser!.uid;
                        final type = message.type;
                        if (type == MessageType.image) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: Get.width * 0.8,
                                    maxHeight: Get.height * 0.3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe ? grey.shade300 : purple,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(isMe ? 10 : 0),
                                      topRight: Radius.circular(isMe ? 0 : 10),
                                      bottomLeft: const Radius.circular(10),
                                      bottomRight: const Radius.circular(10),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: message.imageUrl == null
                                      ? const SizedBox(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: message.imageUrl!,
                                        ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (type == MessageType.audio) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: Get.width * 0.8,
                                    maxHeight: Get.height * 0.3,
                                  ),
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: isMe ? grey.shade300 : purple,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(isMe ? 10 : 0),
                                      topRight: Radius.circular(isMe ? 0 : 10),
                                      bottomLeft: const Radius.circular(10),
                                      bottomRight: const Radius.circular(10),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white,
                                        child: message.audioUrl == null
                                            ? const CircularProgressIndicator()
                                            : const Icon(
                                                Icons.headphones,
                                                color: Colors.red,
                                              ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message.message,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: SizedBox(
                                          width: 50,
                                          child: IconButton(
                                            splashRadius: 25,
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (type == MessageType.video) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: Get.width * 0.8,
                                    maxHeight: Get.height * 0.3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe ? grey.shade300 : purple,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(isMe ? 10 : 0),
                                      topRight: Radius.circular(isMe ? 0 : 10),
                                      bottomLeft: const Radius.circular(10),
                                      bottomRight: const Radius.circular(10),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: message.videoUrl == null
                                      ? const SizedBox(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : Stack(
                                          children: [
                                            VideoPlayer(
                                                VideoPlayerController.network(
                                              message.videoUrl!,
                                            )..initialize().then((_) {
                                                    setState(() {});
                                                  })),
                                            const Center(
                                              child: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: Get.width * 0.8,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe ? grey.shade300 : purple,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(isMe ? 10 : 0),
                                    topRight: Radius.circular(isMe ? 0 : 10),
                                    bottomLeft: const Radius.circular(10),
                                    bottomRight: const Radius.circular(10),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Text(
                                  message.message,
                                  style: TextStyle(
                                    color: isMe ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                                if (isExpanded) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                } else {
                                  messageController?.requestFocus();
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: purple,
                                radius: 15,
                                child: Icon(
                                  isExpanded
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                onTap: () {
                                  if (isExpanded) {
                                    setState(() {
                                      isExpanded = false;
                                    });
                                  }
                                },
                                controller: controller.messageController,
                                focusNode: messageController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type Messages Here....",
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (controller.messageController.text.isNotEmpty) {
                          controller.sendMessage();
                        }
                      },
                      backgroundColor: purple,
                      child: const Icon(
                        FontAwesome.send_o,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (isExpanded)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: Get.width,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          controller.selectImage();
                        },
                        padding: EdgeInsets.zero,
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: purple,
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          controller.selectAudio();
                        },
                        child: const CircleAvatar(
                          backgroundColor: purple,
                          radius: 25,
                          child: Icon(
                            Icons.audio_file,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          controller.selectVideo();
                        },
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: purple,
                          child: Icon(
                            Icons.video_file,
                            color: Colors.white,
                          ),
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

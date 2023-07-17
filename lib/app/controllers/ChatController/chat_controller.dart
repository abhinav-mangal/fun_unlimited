import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/Model/chat_model.dart';
import 'package:fun_unlimited/app/user_models/user_model.dart';
import 'package:images_picker/images_picker.dart';

class ChatController extends ChangeNotifier {
  UserModel? receiver;
  UserModel? sender;
  final messageController = TextEditingController();
  bool isNew = true;
  bool isLoading = false;
  String imageUrl = "";
  String audioUrl = "";
  String videoUrl = "";

  setData({
    required String senderid,
    required String receiverid,
  }) async {
    isLoading = true;
    await checkIsNew(senderid, receiverid);
    await setReceiver(receiverid);
    await setSender(senderid);
    isLoading = false;
    notifyListeners();
  }

  Future checkIsNew(String senderid, String receiverid) async {
    final data = await FirebaseFirestore.instance
        .collection('User')
        .doc(senderid)
        .collection('Chats')
        .doc(receiverid)
        .get();
    isNew = !data.exists;
  }

  selectImage() async {
    final images = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );
    if (images != null) {
      imageUrl = images[0].path;
      sendMessage(type: MessageType.image);
    }
  }

  selectVideo() async {
    final videos = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.video,
    );
    if (videos != null) {
      videoUrl = videos[0].path;
      sendMessage(type: MessageType.video);
    }
  }

  selectAudio() async {
    final audios = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (audios != null) {
      audioUrl = audios.files.first.path!;
      sendMessage(type: MessageType.audio);
    }
  }

  closeController() {
    receiver = null;
    sender = null;
    isNew = true;
    imageUrl = "";
    audioUrl = "";
    videoUrl = "";
    messageController.clear();
    notifyListeners();
  }

  Future setReceiver(String receiverid) async {
    final data = await FirebaseFirestore.instance
        .collection('User')
        .doc(receiverid)
        .get();
    receiver = UserModel.fromJson(data.data()!);
    notifyListeners();
  }

  Future setSender(String senderid) async {
    final data =
        await FirebaseFirestore.instance.collection('User').doc(senderid).get();
    sender = UserModel.fromJson(data.data()!);
    notifyListeners();
  }

  void sendMessage({
    MessageType type = MessageType.text,
  }) async {
    if (isNew) {
      final forMeChat = ChatModel(
        name: receiver!.name,
        avatarUrl: receiver!.image!,
        id: receiver!.id,
        isGroup: false,
        lastMessage: messageController.text,
        lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
      ).toJson();
      final forOtherChat = ChatModel(
        name: sender!.name,
        avatarUrl: sender!.image!,
        id: sender!.id,
        isGroup: false,
        lastMessage: messageController.text,
        lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
      ).toJson();
      await FirebaseFirestore.instance
          .collection('User')
          .doc(sender!.id)
          .collection('Chats')
          .doc(receiver!.id)
          .set(forMeChat);
      await FirebaseFirestore.instance
          .collection('User')
          .doc(receiver!.id)
          .collection('Chats')
          .doc(sender!.id)
          .set(forOtherChat);
      isNew = false;
    }

    final message = MessageModel(
      message: type == MessageType.text
          ? messageController.text
          : type == MessageType.image
              ? imageUrl.split('/').last
              : type == MessageType.audio
                  ? audioUrl.split('/').last
                  : videoUrl.split('/').last,
      type: type,
      time: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: sender!.id,
      receiverId: receiver!.id,
      senderName: sender!.name,
      receiverName: receiver!.name,
      senderAvatar: sender!.image!,
      receiverAvatar: receiver!.image!,
      id: sender!.id.toString().substring(0, 5) +
          receiver!.id.toString().substring(0, 5) +
          DateTime.now().millisecondsSinceEpoch.toString(),
      isRead: false,
    ).toJson();
    messageController.clear();
    await FirebaseFirestore.instance
        .collection('User')
        .doc(sender!.id)
        .collection('Chats')
        .doc(receiver!.id)
        .collection('Messages')
        .doc(message['id'])
        .set(message);
    await FirebaseFirestore.instance
        .collection('User')
        .doc(receiver!.id)
        .collection('Chats')
        .doc(sender!.id)
        .collection('Messages')
        .doc(message['id'])
        .set(message);
    String imageLink = "";
    String audioLink = "";
    String videoLink = "";
    if (imageUrl.isNotEmpty) {
      type = MessageType.image;
      imageLink = await uploadImage();
      imageUrl = "";
    }
    if (audioUrl.isNotEmpty) {
      type = MessageType.audio;
      audioLink = await uploadAudio();
      audioUrl = "";
    }
    if (videoUrl.isNotEmpty) {
      type = MessageType.video;
      videoLink = await uploadVideo();
      videoUrl = "";
    }
    await FirebaseFirestore.instance
        .collection('User')
        .doc(sender!.id)
        .collection('Chats')
        .doc(receiver!.id)
        .collection('Messages')
        .doc(message['id'])
        .update({
      'imageUrl': imageLink,
      'audioUrl': audioLink,
      'videoUrl': videoLink,
    });
    await FirebaseFirestore.instance
        .collection('User')
        .doc(receiver!.id)
        .collection('Chats')
        .doc(sender!.id)
        .collection('Messages')
        .doc(message['id'])
        .update({
      'imageUrl': imageLink,
      'audioUrl': audioLink,
      'videoUrl': videoLink,
    });
    notifyListeners();
    updateLastMessage(message, type: type);
  }

  Future updateLastMessage(Map<String, dynamic> message,
      {MessageType type = MessageType.text}) async {
    FirebaseFirestore.instance
        .collection('User')
        .doc(sender!.id)
        .collection('Chats')
        .doc(receiver!.id)
        .update({
      'lastMessage': type == MessageType.text
          ? message['message']
          : type == MessageType.image
              ? '📸Image'
              : type == MessageType.audio
                  ? '🎵Audio'
                  : '🎥Video',
      'lastMessageTime': message['time'],
    });
    FirebaseFirestore.instance
        .collection('User')
        .doc(receiver!.id)
        .collection('Chats')
        .doc(sender!.id)
        .update({
      'lastMessage': type == MessageType.text
          ? message['message']
          : type == MessageType.image
              ? '📸Image'
              : type == MessageType.audio
                  ? '🎵Audio'
                  : '🎥Video',
      'lastMessageTime': message['time'],
    });
  }

  uploadImage() async {
    final ref = FirebaseStorage.instance.ref().child('Images').child(
        '${FirebaseAuth.instance.currentUser!.uid + DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
    final uploadTask = ref.putFile(File(imageUrl));
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  uploadAudio() async {
    final ref = FirebaseStorage.instance.ref().child('Audios').child(
        '${FirebaseAuth.instance.currentUser!.uid + DateTime.now().millisecondsSinceEpoch.toString()}.mp3');
    final uploadTask = ref.putFile(File(audioUrl));
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  uploadVideo() async {
    final ref = FirebaseStorage.instance.ref().child('Videos').child(
        '${FirebaseAuth.instance.currentUser!.uid + DateTime.now().millisecondsSinceEpoch.toString()}.mp4');
    final uploadTask = ref.putFile(File(videoUrl));
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}

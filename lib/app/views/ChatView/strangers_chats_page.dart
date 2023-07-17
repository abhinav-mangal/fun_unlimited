import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/Model/chat_model.dart';
import 'package:fun_unlimited/app/views/ChatView/chat_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StrangerChatsPage extends StatefulWidget {
  const StrangerChatsPage({Key? key}) : super(key: key);

  @override
  State<StrangerChatsPage> createState() => _StrangerChatsPageState();
}

class _StrangerChatsPageState extends State<StrangerChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stranger Messages',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Chats')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Chats Found',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 0,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final chat = ChatModel.fromJson(
                snapshot.data!.docs[index].data(),
              );
              return ListTile(
                onTap: () {
                  Get.to(() => ChatPage(uid: chat.id));
                },
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(chat.avatarUrl),
                ),
                title: Text(
                  chat.name,
                ),
                subtitle: Text(
                  chat.lastMessage,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                trailing: Text(
                  formatDate(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(
                        chat.lastMessageTime,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inDays > 7) {
    return DateFormat('dd/MM/yyyy').format(date);
  } else if (difference.inDays > 1) {
    return '${difference.inDays} days ago';
  } else if (difference.inHours > 1) {
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes > 1) {
    return '${difference.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}

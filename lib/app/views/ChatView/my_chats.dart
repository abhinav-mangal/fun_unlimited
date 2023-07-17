import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/views/ChatView/strangers_chats_page.dart';
import 'package:get/get.dart';

class MyChatsPage extends StatefulWidget {
  const MyChatsPage({Key? key}) : super(key: key);

  @override
  State<MyChatsPage> createState() => _MyChatsPageState();
}

class _MyChatsPageState extends State<MyChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/chatbot.png'),
            ),
            title: Text(
              'Lafa Service',
            ),
            subtitle: Text(
              'Hello, how can we help you?',
            ),
            trailing: Text(
              '08:42 PM',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          const Divider(
            height: 0,
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('User')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('Chats')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading...');
              }
              return ListTile(
                onTap: () {
                  Get.to(() => const StrangerChatsPage());
                },
                leading: const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/chatbot.png'),
                ),
                title: const Text(
                  'Stranger\'s Message',
                ),
                subtitle: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "[${snapshot.data!.docs.length} New]",
                        style: const TextStyle(
                          color: purple,
                        ),
                      ),
                      const TextSpan(
                        text: ' Messages',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

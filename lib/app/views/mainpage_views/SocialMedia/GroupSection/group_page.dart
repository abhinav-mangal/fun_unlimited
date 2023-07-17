import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/views/mainpage_views/SocialMedia/GroupSection/search_group_page.dart';
import 'package:get/get.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  showCreateSearchDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (_) {
        return Container(
          height: 150,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton(
                onPressed: () async {
                  Get.back();
                },
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: purple,
                      child: Image.asset(
                        'assets/add.png',
                        height: 20,
                        width: 20,
                        color: white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Create Group",
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
                  Get.to(() => const SearchGroupPage());
                },
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: purple,
                      child: Icon(
                        FontAwesome.search,
                        color: white,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Search Group",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showCreateSearchDialog(context);
        },
        backgroundColor: purple,
        child: Image.asset(
          'assets/add.png',
          height: 25,
          width: 25,
          color: white,
        ),
      ),
      body: FirestorePagination(
        isLive: true,
        query: FirebaseFirestore.instance.collection('Groups'),
        onEmpty: const Center(
          child: Text(
            'No Groups Found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        itemBuilder: (context, documentSnapshot, index) {
          return ListTile(
            title: Text(documentSnapshot['title']),
          );
        },
      ),
    );
  }
}

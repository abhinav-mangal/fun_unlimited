import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common_widgets/common_colors.dart';
import 'other_profile_view.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({Key? key}) : super(key: key);

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Followers',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Followers')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Followers'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      onPressed: () {
                        Get.to(
                          () => OthersProfileView(
                            userId: snapshot.data!.docs[index]['userId'],
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            snapshot.data!.docs[index]['userImage'],
                          ),
                        ),
                        title: Text(snapshot.data!.docs[index]['userName']),
                        subtitle: Row(
                          children: [
                            StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection("User")
                                  .doc(snapshot.data!.docs[index]['userId'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: snapshot.hasData
                                      ? NetworkImage(
                                          snapshot.data!.get('country') ==
                                                  "India"
                                              ? "https://cdn.britannica.com/97/1597-050-008F30FA/Flag-India.jpg?w=400&h=235&c=crop"
                                              : "",
                                        )
                                      : null,
                                );
                              },
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
                                        .doc(snapshot.data!.docs[index]
                                            ['userId'])
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
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('User')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('Following')
                        .snapshots(),
                    builder: (context, vsnapshot) {
                      if (!vsnapshot.hasData) {
                        return const SizedBox();
                      }
                      if (vsnapshot.data!.docs.isEmpty) {
                        return const SizedBox();
                      }
                      List<String> followingList = [];
                      for (int i = 0; i < vsnapshot.data!.docs.length; i++) {
                        followingList.add(
                          snapshot.data!.docs[i]['userId'],
                        );
                      }
                      bool isFollowing = followingList.contains(
                        snapshot.data!.docs[index]['userId'],
                      );
                      if (isFollowing) {
                        return const SizedBox();
                      }
                      return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('User')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, userData) {
                            if (!userData.hasData) {
                              return const SizedBox();
                            }
                            return CupertinoButton(
                              onPressed: () {
                                followUser(snapshot, index, userData);
                              },
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: purple.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 8,
                                ),
                                child: const Text(
                                  "Follow",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void followUser(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      int index,
      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userData) {
    FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Following')
        .doc(snapshot.data!.docs[index]['userId'])
        .set({
      "userId": snapshot.data!.docs[index]['userId'],
      "userName": snapshot.data!.docs[index]['userName'],
      "userImage": snapshot.data!.docs[index]['userImage'],
      "dateTime": DateTime.now().millisecondsSinceEpoch,
    });
    FirebaseFirestore.instance
        .collection('User')
        .doc(snapshot.data!.docs[index]['userId'])
        .collection('Followers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'userName': userData.data!.get('name'),
      'userImage': userData.data!.get('image'),
      'dateTime': DateTime.now().millisecondsSinceEpoch,
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../../common_widgets/common_colors.dart';
import 'other_profile_view.dart';

class FollowingsPage extends StatefulWidget {
  const FollowingsPage({Key? key}) : super(key: key);

  @override
  State<FollowingsPage> createState() => _FollowingsPageState();
}

class _FollowingsPageState extends State<FollowingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Followings',
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
            .collection('Following')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Followings'),
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
                  CupertinoButton(
                    onPressed: () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: "Unfollow",
                        cancelBtnText: "Cancel",
                        confirmBtnText: "Unfollow",
                        text: "Are you sure you want to unfollow this user?",
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                        },
                        onConfirmBtnTap: () {
                          FirebaseFirestore.instance
                              .collection('User')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('Following')
                              .doc(snapshot.data!.docs[index]['userId'])
                              .delete();
                          FirebaseFirestore.instance
                              .collection('User')
                              .doc(snapshot.data!.docs[index]['userId'])
                              .collection('Followers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .delete();
                          Navigator.pop(context);
                        },
                      );
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
                        "Unfollow",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                    ),
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
}

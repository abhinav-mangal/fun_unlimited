import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/views/about_view/self_introduction_page.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:images_picker/images_picker.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  pickProfileImage() async {
    final pickedFile = await ImagesPicker.pick(
      count: 1,
      quality: 0.1,
    );
    if (pickedFile != null) {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      String url = '';
      await FirebaseStorage.instance
          .ref()
          .child('User')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('ProfileImage')
          .putFile(
            File(pickedFile[0].path),
          )
          .then((p0) async {
        await p0.ref.getDownloadURL().then((value) {
          url = value;
        });
      });
      await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'image': url,
      });
      Get.back();
      Fluttertoast.showToast(msg: 'Profile Image Updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: const IconThemeData(color: black),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('User')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          onTap: pickProfileImage,
                          leading: const Text(
                            'My Avatar',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              snapshot.data!.data()!['image'],
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text(
                            'ID',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: Text(
                            snapshot.data!
                                .data()!['id']
                                .toString()
                                .substring(0, 8),
                            style: const TextStyle(
                              color: grey,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Text(
                            'Nickname',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: Text(
                            snapshot.data!.data()!['name'],
                            style: const TextStyle(
                              color: grey,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text(
                            'Gender',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: Text(
                            snapshot.data!.data()!['gender'],
                            style: const TextStyle(
                              color: grey,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text(
                            'Age',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: Text(
                            calculateAge(
                              DateTime.parse(
                                snapshot.data!.data()!['dob'].toString(),
                              ),
                            ).toString(),
                            style: const TextStyle(
                              color: grey,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Text(
                            'Region',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: Text(
                            snapshot.data!.data()!['country'],
                            style: const TextStyle(
                              color: grey,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Text(
                            'Location',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: const Text(
                            "-----",
                            style: TextStyle(
                              color: grey,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                onTap: () {},
                                leading: const Text(
                                  'Language',
                                  style: TextStyle(
                                    color: black,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  snapshot.data!.data()!['language'],
                                  style: const TextStyle(
                                    color: grey,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: grey,
                                  size: 15,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Text(
                            'Second Language',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: grey,
                            size: 15,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Get.to(() => const SelfIntroduction());
                          },
                          leading: const Text(
                            'Self-Introduction',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: grey,
                            size: 15,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            if (snapshot.data!.get('email') == "") {
                              await GoogleSignIn.standard().signIn().then(
                                (value) async {
                                  await FirebaseFirestore.instance
                                      .collection('User')
                                      .doc(snapshot.data!.id)
                                      .update({
                                    'email': value!.email,
                                  });
                                  Fluttertoast.showToast(
                                    msg: "Google Binded Successfully",
                                  );
                                },
                              );
                            }
                          },
                          leading: const Text(
                            'Google',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: grey,
                            size: 15,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Text(
                            'Phone',
                            style: TextStyle(
                              color: black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: grey,
                            size: 15,
                          ),
                        ),
                      ],
                    ).toList(),
                  ),
                ),
              ],
            );
          }),
    );
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}

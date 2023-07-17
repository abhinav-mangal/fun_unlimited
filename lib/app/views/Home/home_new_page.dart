import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_unlimited/app/views/live_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common_widgets/common_colors.dart';
import '../../controllers/CallController/call_controller.dart';
import '../about_view/other_profile_view.dart';

class HomeNewPage extends StatefulWidget {
  final bool isLive;
  const HomeNewPage({Key? key, this.isLive = false}) : super(key: key);

  @override
  State<HomeNewPage> createState() => _HomeNewPageState();
}

class _HomeNewPageState extends State<HomeNewPage> {
  List<DocumentSnapshot> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers({
    bool getMore = false,
  }) async {
    if (getMore) {
      var user = widget.isLive
          ? await FirebaseFirestore.instance
              .collection('User')
              .startAfterDocument(users.last)
              .where('isLive', isEqualTo: true)
              .limit(10)
              .get()
          : await FirebaseFirestore.instance
              .collection('User')
              .startAfterDocument(users.last)
              .limit(10)
              .get();

      List<DocumentSnapshot> data = [];
      data.clear();
      for (var qelement in user.docs) {
        if (users.any((element) => element['id'] == qelement.id)) {
          continue;
        } else {
          data.add(qelement);
          users.add(qelement);
        }
      }
      if (data.isEmpty) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
      users.removeWhere(
          (element) => element['id'] == FirebaseAuth.instance.currentUser!.uid);

      // Sort by dateTime

      if (mounted) {
        setState(() {});
      }
    } else {
      setState(() {
        isLoading = true;
      });
      var user = widget.isLive
          ? await FirebaseFirestore.instance
              .collection('User')
              .where('isLive', isEqualTo: true)
              .limit(10)
              .get()
          : await FirebaseFirestore.instance.collection('User').limit(10).get();
      for (var element in user.docs) {
        log(element.id.toString());
      }
      users = user.docs;
      users.removeWhere(
          (element) => element['id'] == FirebaseAuth.instance.currentUser!.uid);
      isLoading = false;
      // Sort by dateTime
      users.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      if (mounted) {
        setState(() {});
      }
    }
  }

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (users.isEmpty) {
      return const Center(
        child: Text(
          "No Live Stream Available",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () async {
        await getUsers();
      },
      enablePullUp: true,
      onLoading: () {
        getUsers(getMore: true);
      },
      header: const WaterDropHeader(
        waterDropColor: purple,
      ),
      enablePullDown: true,
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final data = users[index].data() as Map<String, dynamic>;
          return GestureDetector(
            onTap: () {
              if (widget.isLive) {
                Get.to(() => LiveView(
                      uid: data['id'],
                    ));
              } else {
                Get.to(
                  () => OthersProfileView(
                    userId: data['id'],
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: data['image'],
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.isLive == false)
                          Row(
                            children: [
                              if (data['isLive'])
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    height: 25,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: purple.withOpacity(0.7),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Row(
                                      children: [
                                        Lottie.asset(
                                          "assets/live.json",
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          "Live",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: grey.withOpacity(0.7),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.tv_off,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Offline",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        const Spacer(),
                        Text(
                          data['language'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          data['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 9,
                              backgroundColor: purple,
                              backgroundImage: NetworkImage(
                                "https://cdn.britannica.com/97/1597-050-008F30FA/Flag-India.jpg?w=400&h=235&c=crop",
                              ),
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
                                  const Icon(
                                    Icons.star,
                                    color: white,
                                    size: 11,
                                  ),
                                  StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection("User")
                                        .doc(data['id'])
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
                      ],
                    ),
                  ),
                  if (widget.isLive == false)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () {
                          if (data['isLive'] == false) {
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(
                              msg: "User is offline",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }
                          final controller = Provider.of<CallController>(
                              context,
                              listen: false);
                          controller.call(
                            data['id'],
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple,
                                  Colors.pink,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Lottie.asset(
                                "assets/call.json",
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

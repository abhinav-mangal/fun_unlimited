import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/views/lets_party_view/lets_party_view.dart';
import 'package:get/get.dart';

import '../../../common_widgets/common_colors.dart';

class PartyTabView extends StatefulWidget {
  const PartyTabView({Key? key}) : super(key: key);

  @override
  State<PartyTabView> createState() => _PartyTabViewState();
}

class _PartyTabViewState extends State<PartyTabView> {
  @override
  Widget build(BuildContext context) {
    return FirestorePagination(
      query: FirebaseFirestore.instance
          .collection("User")
          .where('isParty', isEqualTo: true),
      isLive: true,
      viewType: ViewType.grid,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      onEmpty: const Center(
        child: Text(
          "No Party Found",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemBuilder: (_, ddata, index) {
        final data = ddata.data() as Map<String, dynamic>;
        return GestureDetector(
          onTap: () {
            Get.to(
              () => LetsPartyView(
                uid: data['id'],
              ),
            );
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
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.centerLeft,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 65,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: purple,
                                ),
                                height: 20,
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "Lvl ${data['level']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: -5,
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: white,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: purple,
                                    backgroundImage: CachedNetworkImageProvider(
                                      data['image'],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 5,
                            ),
                            height: 20,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.group,
                                  color: white,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseFirestore.instance
                                      .collection("User")
                                      .doc(data['id'])
                                      .collection("Party")
                                      .doc(data['id'])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    int userCount = 0;
                                    if (snapshot.hasData &&
                                        snapshot.data!.exists) {
                                      userCount =
                                          snapshot.data!.get('users').length;
                                    }
                                    return Text(
                                      userCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ],
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
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:get/get.dart';

class CardButtonView extends StatefulWidget {
  const CardButtonView({super.key});

  @override
  State<CardButtonView> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButtonView> {
  final List<Tab> tab = <Tab>[
    const Tab(
      text: "Info",
    ),
    const Tab(
      text: "Moments",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: trans,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            pinned: true,
            backgroundColor: white,
            expandedHeight: Get.height * 0.5,
            flexibleSpace: FlexibleSpaceBar(
              background: InkWell(
                onTap: () {},
                child: const Image(
                  image: NetworkImage(
                    "https://i.pinimg.com/originals/17/e5/d0/17e5d0456406a79f0c71fbaffe63e3a0.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    BottomSheet(
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onClosing: () {},
                      builder: (context) {
                        return Container(
                          height: Get.height * 0.4,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: white,
                            border: Border.all(color: purple),
                          ),
                          child: ListView(
                            children: ListTile.divideTiles(
                              context: context,
                              tiles: [
                                ListTile(
                                  onTap: () {},
                                  title: Column(
                                    children: const [
                                      Text(
                                        "Report",
                                        style: TextStyle(
                                          color: black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "User Name",
                                        style: TextStyle(
                                          color: grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  title: const Center(
                                    child: Text(
                                      "Live Stream",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  title: const Center(
                                    child: Text(
                                      "Poster",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  title: const Center(
                                    child: Text(
                                      "Nick Name",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  title: const Center(
                                    child: Text(
                                      "Self_Introduction",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Get.back();
                                  },
                                  title: const Center(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ).toList(),
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: const CircleAvatar(
                  backgroundColor: grey,
                  child: Icon(
                    Icons.warning,
                    size: 15,
                    color: white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    BottomSheet(
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onClosing: () {},
                      builder: (context) {
                        return Container(
                          height: Get.height * 0.3,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: white,
                            border: Border.all(color: purple),
                          ),
                          child: ListView(
                            children: ListTile.divideTiles(
                              context: context,
                              tiles: [
                                ListTile(
                                  onTap: () {},
                                  title: const Center(
                                    child: Text(
                                      "Follow",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  title: const Center(
                                    child: Text(
                                      "Move to blocklist",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  title: const Center(
                                    child: Text(
                                      "Report",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Get.back();
                                  },
                                  title: const Center(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ).toList(),
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: const CircleAvatar(
                  backgroundColor: grey,
                  child: Icon(
                    Icons.more_horiz,
                    color: white,
                  ),
                ),
              ),
            ],
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate(childCount: 1, (context, index) {
              return Container(
                height: Get.height,
                color: white,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          tabs: tab,
                          isScrollable: true,
                          labelColor: purple,
                          unselectedLabelColor: black,
                          indicatorColor: purple,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 17,
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(children: [
                            Container(
                              color: white,
                              padding: const EdgeInsets.all(12),
                              height: Get.height,
                              width: Get.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const CircleAvatar(
                                        radius: 20,
                                        backgroundColor: white,
                                        backgroundImage: NetworkImage(
                                            "https://i.pinimg.com/originals/fd/70/31/fd7031379854d7dd6490a137be03e3fc.jpg"),
                                      ),
                                      Column(
                                        children: [
                                          const Text("Name     "),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: pink),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.live_tv,
                                                      color: white,
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      "Live",
                                                      style: TextStyle(
                                                          color: white,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 30,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: pink),
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.female,
                                                      color: white,
                                                    ),
                                                    Text(
                                                      "20",
                                                      style: TextStyle(
                                                          color: white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: pink),
                                          child: const Icon(Icons.add),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        "Profile",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            height: 30,
                                            width: 90,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15,
                                              ),
                                              color: pink,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                CircleAvatar(
                                                  radius: 12,
                                                  child: Icon(
                                                    Icons.flag,
                                                    color: orange,
                                                  ),
                                                ),
                                                Text(
                                                  "India",
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            height: 30,
                                            width: 90,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15,
                                              ),
                                              color: pink,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                CircleAvatar(
                                                  radius: 12,
                                                  child: Icon(
                                                    Icons.flag,
                                                    color: orange,
                                                  ),
                                                ),
                                                Text(
                                                  "India",
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 30,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          color: pink,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: const [
                                            Icon(
                                              Icons.location_on,
                                              size: 20,
                                            ),
                                            Text(
                                              "India location",
                                              style: TextStyle(color: white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Column(
                                    children: const [
                                      Text(
                                        "Honor",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      // ListView.builder(
                                      //   scrollDirection: Axis.horizontal,
                                      //   itemCount: 2,
                                      //   itemBuilder: (context, index) {
                                      //     return Container(
                                      //       height: 100,
                                      //       width: 200,
                                      //       decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(15),
                                      //         color: green,
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Text(
                                    "Gifts - Received",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Text(
                                    "Gifts - Sent",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Text(
                                    "Groups",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Text(
                                    "Score  3.8",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Text(
                                    "Remark",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: white,
                              height: Get.height,
                              child: const Center(
                                child: Icon(
                                  Icons.stop,
                                  color: grey,
                                  size: 50,
                                ),
                              ),
                            )
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}


// SliverList(
//             delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               return Container(
//                 height: Get.height,
//                 width: Get.width,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15), color: red),
//                 child: DefaultTabController(
//                   length: 2,
//                   child: TabBar(
//                     tabs: tab,
//                     isScrollable: true,
//                     labelColor: purple,
//                     unselectedLabelColor: black,
//                     indicatorColor: Colors.transparent,
//                     labelPadding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                     ),
//                     unselectedLabelStyle: const TextStyle(
//                       fontSize: 17,
//                     ),
//                     labelStyle: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ))
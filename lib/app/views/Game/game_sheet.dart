import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/views/about_view/mybalance_view.dart';
import 'package:get/get.dart';

class GameSheet extends StatefulWidget {
  const GameSheet({Key? key}) : super(key: key);

  @override
  State<GameSheet> createState() => _GameSheetState();
}

class _GameSheetState extends State<GameSheet> {
  bool bettingTime = true;
  Timer? timer;
  int betAmount = 0;
  int seconds = 30;
  int balance = 0;
  bool startRace = false;

  // final bool _isPositionedRight = false;

  List<int> listOfSec = [];

  int winingCar = 0;

  bool showRace = false;

  bool betPlaced = false;

  List<String> cars = [
    "assets/lafa/car1.png",
    "assets/lafa/car2.png",
    "assets/lafa/car3.png",
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        setState(() {
          listOfSec = [4, 6, 8];
          listOfSec.shuffle();
          winingCar = listOfSec.indexOf(4);
          print(winingCar);
          showRace = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              startRace = true;
            });
          });
        });
        Future.delayed(const Duration(seconds: 8), () {
          if (betPlaced) {
            if (currentVehicle == winingCar) {
              customDialogue("You Win", cars[winingCar]);
              FirebaseFirestore.instance
                  .collection("User")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({'balance': balance + betAmount * 2});
            } else {
              customDialogue("You Lost", cars[currentVehicle!]);
            }
          }
          setState(() {
            betPlaced = false;
            startRace = false;
            showRace = false;
            seconds = 30;
          });
          startTimer();
        });
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            seconds--;
          });
        }
      }
    });
  }

  Future<dynamic> customDialogue(String text, String image) {
    Timer? timer = Timer(const Duration(seconds: 2), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(image),
                Text(text),
              ]),
            )).then((value) {
      timer?.cancel();
      timer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
      decoration: const BoxDecoration(
        color: Color(0xff18255d),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Fontisto.person,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    // live player Count
                                    Text(
                                      '5',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform(
                                transform: Matrix4.rotationZ(10 * 3.14 / 180),
                                child: const VerticalDivider(
                                  color: Colors.white,
                                  thickness: 1,
                                  width: 10,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.diamond,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    // live player Count
                                    Text(
                                      '5',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform(
                                transform: Matrix4.rotationZ(10 * 3.14 / 180),
                                child: const VerticalDivider(
                                  color: Colors.white,
                                  thickness: 1,
                                  width: 0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    // Timer
                                    Text(
                                      "$seconds s",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 120,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.diamond,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    // User Diamond Count
                                    StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("User")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null) {
                                          balance = snapshot.data!['balance'];
                                        }
                                        return Text(
                                          snapshot.hasData
                                              ? snapshot.data!['balance']
                                                  .toString()
                                              : '0',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const MyBalanceView());
                              },
                              child: Container(
                                width: 25,
                                color: Colors.amber,
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                roads(),
                showRace
                    ? Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "assets/lafa/map1.png",
                                  height: 150,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          ),
                          AnimatedPositioned(
                            duration:
                                Duration(seconds: startRace ? listOfSec[0] : 0),
                            left: startRace ? 300 : 0,
                            child: Image.asset(
                              cars[0],
                              height: 50,
                            ),
                          ),
                          AnimatedPositioned(
                            top: 50,
                            duration:
                                Duration(seconds: startRace ? listOfSec[1] : 0),
                            left: startRace ? 300 : 0,
                            child: Image.asset(
                              cars[1],
                              height: 50,
                            ),
                          ),
                          AnimatedPositioned(
                            top: 100,
                            duration:
                                Duration(seconds: startRace ? listOfSec[2] : 0),
                            left: startRace ? 300 : 0,
                            child: Image.asset(
                              cars[2],
                              height: 50,
                            ),
                          ),
                        ],
                      )
                    : vehiclesBar(),
                const SizedBox(height: 30),
                buttonBar(context),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xff18255d),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/racebanner.png',
                  height: 95,
                  fit: BoxFit.fitWidth,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: const [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 15,
                        child: Icon(
                          FontAwesome.trophy,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 15,
                        child: ImageIcon(
                          AssetImage(
                            'assets/games/level.png',
                          ),
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 15,
                        child: Icon(
                          FontAwesome.history,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 15,
                        child: Icon(
                          FontAwesome.question,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buttonBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              if (betAmount > 10) {
                setState(() {
                  betAmount--;
                });
                FirebaseFirestore.instance
                    .collection("User")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({'balance': balance + 1});
              }
            },
            child: const Text("-"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  if (balance <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Insufficient Balance"),
                    ));
                  } else {
                    if (currentVehicle == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Pls select a vehicle"),
                      ));
                    } else {
                      FirebaseFirestore.instance
                          .collection("User")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({'balance': balance - betAmount});
                    }
                    setState(() {
                      betPlaced = true;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Bet"),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.diamond,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      betAmount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (betAmount < balance) {
                if (currentVehicle == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Pls select a vehicle"),
                  ));
                } else {
                  setState(() {
                    betAmount++;
                  });
                }
              }
            },
            child: const Text("+"),
          ),
        ],
      ),
    );
  }

  int? randomPick() {
    return null;

    // if (currentVehicle == winingCar) {
    //   Future.delayed(const Duration(seconds: 3), () {
    //     FirebaseFirestore.instance
    //         .collection("User")
    //         .doc(FirebaseAuth.instance.currentUser!.uid)
    //         .update({'balance': balance + betAmount * 2});
    //     setState(() {
    //       startRace = false;
    //       betAmount = 0;
    //       seconds = 15;
    //     });
    //     // startTimer();
    //   });
    // } else {
    //   Future.delayed(const Duration(seconds: 3), () {
    //     setState(() {
    //       startRace = false;
    //       betAmount = 0;
    //       seconds = 15;
    //     });
    //     // startTimer();
    //   });
    // }
  }

  int currentMap = 1;

  List maps = [
    {
      'name': 'Road',
      'image': 'assets/games/road.jpg',
    },
    {
      'name': "Highway",
      'image': 'assets/games/bumby.png',
    },
    {
      'name': "Desert",
      'image': 'assets/games/map3.png',
    }
  ];

  int? currentVehicle;

  List vehicles = [
    {
      'index': 0,
      'name': 'Car',
      'image': 'assets/lafa/car1.png',
    },
    {
      'index': 1,
      'name': "Bike",
      'image': 'assets/lafa/car2.png',
    },
    {
      'index': 2,
      'name': "Truck",
      'image': 'assets/lafa/car3.png',
    }
  ];

  roads() {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: maps.map((e) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        height: 25,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            maps[currentMap]['name'] == e['name']
                                ? e['name']
                                : '????',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Entypo.triangle_down,
                        color: Colors.amber,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: maps.map((e) {
              return Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: (maps[currentMap]['name'] == e['name'])
                        ? Colors.amber
                        : Colors.white.withOpacity(0.3),
                  ),
                  child: (maps[currentMap]['name'] != e['name'])
                      ? Image.asset(
                          'assets/games/road.jpg',
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          e['image'],
                          fit: BoxFit.cover,
                        ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  vehiclesBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: vehicles.map((e) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentVehicle = e['index'];
                        betAmount = 10;
                      });
                    },
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: currentVehicle == null
                            ? null
                            : e['index'] == currentVehicle
                                ? Border.all(
                                    color: Colors.red,
                                    width: 4,
                                  )
                                : null,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Image.asset(
                          e['image'],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    left: 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.pink,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.diamond,
                              color: Colors.amber,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '10',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

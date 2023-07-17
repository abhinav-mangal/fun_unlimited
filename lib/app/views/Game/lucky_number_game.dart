import 'dart:async';
import 'dart:developer';
import 'dart:math' show Random, pi;

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_unlimited/app/Utils/constant.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:get/get.dart';

class LuckyNumberWidget extends StatefulWidget {
  const LuckyNumberWidget({super.key});

  @override
  State<LuckyNumberWidget> createState() => _LuckyNumberWidgetState();
}

class _LuckyNumberWidgetState extends State<LuckyNumberWidget> {
  bool isSpinning = false;
  Timer? timer;
  int seconds = 10;
  bool isBetPlaced = false;
  int totalBetAmount = 0;
  bool showinfo = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    showinfo = false;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        if (isBetPlaced) {
          totalBetAmount = totalBetAmount + (mybetnumbers.length * mybetamount);
        }
        setState(() {
          isSpinning = true;
          newNumbers = [];
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

  checkForWinner() {
    if (isBetPlaced && newNumbers.length == 3) {
      setState(() {
        showinfo = true;
      });
    }
    isBetPlaced = false;
    mybetamount = 1;
    mybetnumbers = [];
    setState(() {});
  }

  List<int> spinnerNumbers = [1, 2, 3];
  List<int> newNumbers = [];
  int mybetamount = 1;
  List<int> mybetnumbers = [];

  doesWin() {
    if (newNumbers.length != 3) {
      return false;
    }
    if (!isBetPlaced) {
      return false;
    }
    final sum = spinnerNumbers.reduce((value, element) => value + element);
    if (mybetnumbers.contains(sum)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: OvalClipper(),
          child: Container(
            height: 460,
            width: double.infinity,
            decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const SizedBox(height: 120),
                if (!showinfo)
                  //Make Timer Widget
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${seconds}s',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              ' ( 1 ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 12,
                            ),
                            Text(
                              ' / $totalBetAmount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.diamond,
                              color: Colors.white,
                              size: 12,
                            ),
                            const Text(
                              ' )',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(
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
                  ),
                if (!showinfo)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                Text(
                                  " 1B/2E",
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
                        Container(
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Center(
                            child: Icon(
                              Icons.history,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    height: 51,
                    margin: const EdgeInsets.only(top: 9, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(5),
                    width: 200,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            '${spinnerNumbers.join(' + ')} = ${spinnerNumbers.reduce((value, element) => value + element)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          doesWin()
                              ? const Text(
                                  'You Won',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const Text(
                                  'You Lost',
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
                // Wrap the list in a GridView.builder
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 28,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (isBetPlaced) {
                          return;
                        }
                        if (mybetnumbers.contains(index)) {
                          mybetnumbers.remove(index);
                        } else {
                          mybetnumbers.add(index);
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: mybetnumbers.contains(index)
                              ? Colors.white.withOpacity(0.2)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.8),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              index.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: mybetnumbers.contains(index)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          mybetamount.toString(),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.diamond,
                                          color: Colors.purple,
                                          size: 10,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              height: 2,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Negative button
                            tapper(
                              onTap: () {
                                if (isBetPlaced) {
                                  return;
                                }
                                setState(() {
                                  if (mybetamount > 1) {
                                    mybetamount--;
                                  }
                                });
                                if (mybetamount == 0) {
                                  mybetnumbers.clear();
                                }
                              },
                              child: Container(
                                height: 30,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            //Bet Button
                            tapper(
                              onTap: () {
                                if (mybetnumbers.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Please select a number",
                                  );
                                  return;
                                }
                                if (mybetamount == 0) {
                                  Fluttertoast.showToast(
                                    msg: "Please select a bet amount",
                                  );
                                  return;
                                }
                                if (isSpinning) {
                                  return;
                                }
                                if (isBetPlaced) {
                                  return;
                                }
                                setState(() {
                                  isBetPlaced = true;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.red.withBlue(100),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isBetPlaced ? "Bet Placed" : "Bet",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (!isBetPlaced) const SizedBox(width: 5),
                                    if (!isBetPlaced)
                                      Text(
                                        mybetamount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    if (!isBetPlaced)
                                      const Icon(
                                        Icons.diamond,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Positive button
                            tapper(
                              onTap: () {
                                if (isBetPlaced) {
                                  return;
                                }
                                setState(() {
                                  mybetamount++;
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 45,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    if (!isSpinning)
                      ...spinnerNumbers
                          .map(
                            (e) => Expanded(
                              child: Center(
                                child: Text(
                                  e.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList()
                    else
                      ...spinnerNumbers
                          .map(
                            (e) => Expanded(
                              child: Center(
                                child: RandomNumberText(
                                  maxValue: 9,
                                  duration: 3,
                                  onSpinComplete: (value) {
                                    log("Value: $value");
                                    setState(() {
                                      spinnerNumbers[
                                          spinnerNumbers.indexOf(e)] = value;
                                      newNumbers.add(value);
                                      isSpinning = false;
                                    });
                                    log("New Numbers: $newNumbers");
                                    if (newNumbers.length == 3) {
                                      checkForWinner();
                                      Future.delayed(const Duration(seconds: 5),
                                          () {
                                        setState(() {
                                          seconds = 10;
                                        });
                                        newNumbers.clear();
                                        startTimer();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                          .toList()
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.3);
    path.quadraticBezierTo(size.width / 2, 0, 0, size.height * 0.3);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RandomNumberText extends StatefulWidget {
  final int maxValue;
  final int duration;
  final Function(int) onSpinComplete;

  const RandomNumberText({
    super.key,
    required this.maxValue,
    required this.duration,
    required this.onSpinComplete,
  });

  @override
  _RandomNumberTextState createState() => _RandomNumberTextState();
}

class _RandomNumberTextState extends State<RandomNumberText>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<int> animation;
  late int targetValue;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );
    targetValue = Random().nextInt(widget.maxValue + 1);
    animation = IntTween(
      begin: 0,
      end: targetValue,
    ).animate(controller)
      ..addListener(() {
        setState(() {});
        if (controller.isCompleted) {
          widget.onSpinComplete(targetValue);
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      animation.value.toString(),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

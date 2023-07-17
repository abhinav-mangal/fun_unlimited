import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class MyEarningView extends GetView {
  const MyEarningView({super.key});

  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: const IconThemeData(color: black),
        title: const Center(
          child: Text(
            "My Earnings",
            style: TextStyle(
              color: black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text(
                          "Instruction",
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          "10,000 Diamond = 1 Doller\nif you earn >= 10 Doller in a week, it will be \npaid to your wallet every Thursday.",
                          style: TextStyle(
                            color: grey,
                          ),
                        ),
                      );
                    }),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  height: 90,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: purple,
                  ),
                  child: const Text(
                    "Earning\n 0\n= 0.00",
                    style: TextStyle(
                      color: white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  height: 90,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: orange,
                  ),
                  child: const Text(
                    "My Wallet >\n0",
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            height: Get.height * 0.2,
            width: Get.width * 0.95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: grey),
              color: white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Daily Report >",
                    style: TextStyle(
                      color: purple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('EEEE, d, MMM, yyyy').format(date),
                      style: const TextStyle(
                        color: purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    onTap: () {},
                    leading: const Text(
                      'Earning Detail',
                      style: TextStyle(color: black),
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
                      'Settlement Detail',
                      style: TextStyle(color: black),
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
          TextButton(
            onPressed: () {},
            child: const Text(
              "Any Problem? Contact Us",
              style: TextStyle(
                color: purple,
              ),
            ),
          ),
          Container(
            height: 30,
            width: Get.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Spurple1,
                  Spurple2,
                  Spurple3,
                  Spurple4,
                  Spurple5,
                  Spurple6,
                  Spurple7
                ],
              ),
            ),
            child: const Center(
              child: Text(
                "User ID : 3534654",
                style: TextStyle(color: white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

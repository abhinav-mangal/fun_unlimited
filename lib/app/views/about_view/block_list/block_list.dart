import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:get/get.dart';

class BlockListView extends GetView {
  const BlockListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: const IconThemeData(color: black),
        title: const Center(
          child: Text(
            "Block List",
            style: TextStyle(
              color: black,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: white,
                  border: Border.all(color: grey)),
              child: const Center(
                child: Image(
                  image: AssetImage("assets/pok.png"),
                  height: 60,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "No One",
              style: TextStyle(
                  color: black, fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

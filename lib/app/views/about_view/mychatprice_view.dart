import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:fun_unlimited/app/common_widgets/common_text.dart';
import 'package:get/get.dart';

class MyChatPriceView extends GetView {
  const MyChatPriceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        shadowColor: white,
        iconTheme: const IconThemeData(color: black),
        backgroundColor: white,
        title: const Center(
          child: Text(
            "My Chat Price",
            style: TextStyle(
              color: black,
            ),
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                FontAwesome.bitcoin,
                color: yellow,
                size: 70,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                height: 200,
                width: Get.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: sbrown,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(text: "Video Call Price"),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          MyText(text: "1,200"),
                          Icon(
                            FontAwesome.bitcoin,
                            color: yellow,
                          ),
                          MyText(text: "/min"),
                          SizedBox(
                            width: 4,
                          ),
                          CircleAvatar(
                            backgroundColor: brown,
                            radius: 8,
                            child: Icon(
                              Icons.edit,
                              color: white,
                              size: 7,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Earn beans per second",
                      style: TextStyle(
                        color: orange,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                width: Get.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: sbrown,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "The Highest Call Price",
                        style: TextStyle(
                          color: brown,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Table(
                        defaultColumnWidth: const FlexColumnWidth(200),
                        // columnWidths: const {
                        //   0: FlexColumnWidth(1),
                        //   1: FlexColumnWidth(2),
                        //   2: FlexColumnWidth(3),
                        //   3: FlexColumnWidth(4),
                        //   4: FlexColumnWidth(5),
                        //   5: FlexColumnWidth(6),
                        //   6: FlexColumnWidth(7),
                        // },
                        border: TableBorder.all(
                          color: brown,
                          borderRadius: BorderRadius.circular(10),
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        children: const [
                          TableRow(
                            children: [
                              Center(child: Text("Lv3")),
                              Center(child: Text("1200/min"))
                            ],
                          ),
                          TableRow(
                            children: [
                              Center(child: Text("Lv4")),
                              Center(child: Text("1800/min"))
                            ],
                          ),
                          TableRow(
                            children: [
                              Center(child: Text("Lv5")),
                              Center(child: Text("2400/min"))
                            ],
                          ),
                          TableRow(
                            children: [
                              Center(child: Text("Lv6")),
                              Center(child: Text("300/min"))
                            ],
                          ),
                          TableRow(
                            children: [
                              Center(child: Text("Lv7")),
                              Center(child: Text("4200/min"))
                            ],
                          ),
                          TableRow(
                            children: [
                              Center(child: Text("Lv8")),
                              Center(child: Text("6200/min"))
                            ],
                          ),
                          TableRow(
                            children: [
                              Center(child: Text("Lv9")),
                              Center(child: Text("10800/min"))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "My Level is",
                            style: TextStyle(
                              color: brown,
                              fontSize: 10,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: brown,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

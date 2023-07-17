import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:get/get.dart';

class DeleteAccountView extends GetView {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: const IconThemeData(color: black),
        title: const Center(
          child: Text(
            "Delete Account",
            style: TextStyle(
              color: black,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

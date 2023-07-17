import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fun_unlimited/app/common_widgets/common_colors.dart';
import 'package:get/get.dart';

class UserAgreementView extends GetView {
  const UserAgreementView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          iconTheme: const IconThemeData(color: black),
          title: const Center(
            child: Text(
              "Terms Of Service",
              style: TextStyle(
                color: black,
                fontSize: 20,
              ),
            ),
          ),
        ),
        backgroundColor: white,
        body: FutureBuilder(
          future:
              rootBundle.loadString("assets/privecy/terms_and_condition.md"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Markdown(data: snapshot.data.toString());
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BindPhoneNumber extends StatefulWidget {
  const BindPhoneNumber({Key? key}) : super(key: key);

  @override
  State<BindPhoneNumber> createState() => _BindPhoneNumberState();
}

class _BindPhoneNumberState extends State<BindPhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BindPhoneNumber'),
      ),
      body: const Center(
        child: Text('BindPhoneNumber'),
      ),
    );
  }
}

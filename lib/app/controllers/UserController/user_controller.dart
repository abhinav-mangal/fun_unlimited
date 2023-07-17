import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/user_models/user_model.dart';

class UserController extends ChangeNotifier {
  UserController({
    bool isInit = true,
  }) {
    if (FirebaseAuth.instance.currentUser != null && isInit) {
      getUser();
    }
  }

  UserModel? user;

  getUser() async {
    final data = await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    user = UserModel.fromJson(data.data()!);
    notifyListeners();
  }
}

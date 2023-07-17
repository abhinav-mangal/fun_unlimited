import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/user_models/user_model.dart';
import 'package:fun_unlimited/app/views/login_views/phone_login_view/select_gender_view.dart';
import 'package:fun_unlimited/app/views/mainpage_views/mainpage_view.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_player/video_player.dart';

class LoginController extends GetxController {
  RxBool tap = false.obs;
  RxBool accepted = false.obs;

  signInWithGoogle(
    VideoPlayerController videoController,
  ) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    final signIn = GoogleSignIn.standard();
    final account = await signIn.signIn();
    final auth = FirebaseAuth.instance;
    final authentican = await account!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: authentican.accessToken,
      idToken: authentican.idToken,
    );

    try {
      await auth.signInWithCredential(credential);
      if (auth.currentUser == null) {
        Get.snackbar("Error", "Unable To LogIn");
        Get.back();
      } else {
        saveUser(
          email: account.email,
          name: account.displayName!,
          photo: account.photoUrl!,
          videoController: videoController,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      Get.snackbar(
        "error",
        e.message.toString(),
      );
      return;
    }
  }

  void saveUser({
    required String email,
    required String name,
    required String photo,
    VideoPlayerController? videoController,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final firestore = await FirebaseFirestore.instance
        .collection("User")
        .where('email', isEqualTo: email)
        .get();
    if (firestore.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(uid)
          .set(
            UserModel(
              id: uid,
              name: name,
              email: email,
              image: photo,
            ).toJson(),
          )
          .then((value) {
        videoController!.dispose();
        Get.offAll(() => const SelectGenderView());
      });
    } else {
      videoController!.dispose();
      Get.offAll(() => MainView());
    }
  }
}

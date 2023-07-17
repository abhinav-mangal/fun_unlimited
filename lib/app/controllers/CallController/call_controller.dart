import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fun_unlimited/app/controllers/UserController/user_controller.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'View/call_page.dart';

class CallController extends ChangeNotifier {
  bool isCalling = false;
  String uid = "";
  bool isAccepted = false;

  disconnectCall({
    required String calluid,
  }) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Call")
        .doc(calluid)
        .update({
      "status": "declined",
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Call")
        .doc(calluid)
        .delete();
    await FirebaseFirestore.instance
        .collection("User")
        .doc(calluid)
        .collection("Calling")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "status": "declined",
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(calluid)
        .collection("Calling")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    uid = "";
    notifyListeners();
  }

  disconnectCalling() async {
    if (uid == "") return;
    Future.delayed(const Duration(seconds: 3));
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Calling")
        .doc(uid)
        .update({
      "status": "declined",
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Calling")
        .doc(uid)
        .delete();
    await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Call")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "status": "declined",
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Call")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    uid = "";
    notifyListeners();
  }

  acceptCall({
    required String calluid,
  }) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(calluid)
        .collection("Calling")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "status": "accepted",
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Call")
        .doc(calluid)
        .update({
      "status": "accepted",
    });
    isAccepted = true;
    final callData = await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Call")
        .doc(calluid)
        .get();
    Get.to(
      () => CallPage(
        callid: callData.get("callId"),
      ),
    );
    uid = "";
    notifyListeners();
  }

  startListner() async {
    FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Call")
        .snapshots()
        .listen((event) async {
      for (var element in event.docChanges) {
        if (element.type == DocumentChangeType.added) {
          Get.bottomSheet(
            callBottomSheet(
              data: element.doc.data(),
            ),
            isDismissible: false,
          );
        }
        if (element.type == DocumentChangeType.modified) {
          if (element.doc.data()!["status"] == "declined") {
            Get.back();
          }
        }
        if (element.type == DocumentChangeType.removed) {
          isAccepted = false;
          if (Get.isBottomSheetOpen!) {
            Get.back();
          }
        }
      }
    });

    FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Calling")
        .snapshots()
        .listen((event) async {
      for (var element in event.docChanges) {
        if (element.type == DocumentChangeType.added) {
          isCalling = true;
          notifyListeners();
        }
        if (element.type == DocumentChangeType.modified) {
          if (element.doc.data()!["status"] == "accepted") {
            Get.to(
              () => CallPage(
                callid: element.doc.data()!["callId"],
              ),
            );
            isCalling = false;
            notifyListeners();
          }
          if (element.doc.data()!["status"] == "declined") {
            Get.back();
          }
        }
        if (element.type == DocumentChangeType.removed) {
          isCalling = false;
          notifyListeners();
        }
      }
    });
  }

  call(String nuid) async {
    isCalling = true;
    notifyListeners();
    final alreadyCalling = await checkAlreadyCalling(nuid);
    if (alreadyCalling) {
      return;
    }
    final isBusy = await FirebaseFirestore.instance
        .collection("User")
        .doc(nuid)
        .collection("Call")
        .get();
    final isCallingUser = await FirebaseFirestore.instance
        .collection("User")
        .doc(nuid)
        .collection("Calling")
        .get();
    if (isBusy.docs.isNotEmpty || isCallingUser.docs.isNotEmpty) {
      Get.snackbar(
        "User Busy",
        "User is busy in another call",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isCalling = false;
      notifyListeners();
      return;
    }
    if (uid != "") {
      await disconnectCalling();
    }
    final data = Provider.of<UserController>(Get.context!, listen: false);
    await data.getUser();
    uid = nuid;
    notifyListeners();
    final callId = uid.substring(0, 5) +
        FirebaseAuth.instance.currentUser!.uid.substring(0, 5);
    await FirebaseFirestore.instance
        .collection("User")
        .doc(nuid)
        .collection("Call")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "name": data.user!.name,
      "photo": data.user!.image,
      "time": DateTime.now().millisecondsSinceEpoch,
      "status": "calling",
      "callId": callId,
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Calling")
        .doc(nuid)
        .set({
      "uid": nuid,
      "name": data.user!.name,
      "photo": data.user!.image,
      "time": DateTime.now().millisecondsSinceEpoch,
      "status": "calling",
      "callId": callId,
    });
  }

  checkAlreadyCalling(String nuid) async {
    final data = await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Calling")
        .doc(nuid)
        .get();
    if (data.exists) {
      return true;
    }
    return false;
  }

  Widget callBottomSheet({var data}) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const Text("Swipe down to ignore"),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 40,
            backgroundImage:
                data["photo"] == null ? null : NetworkImage(data["photo"]),
            child: data["photo"] == null ? Text(data["name"][0]) : null,
          ),
          const SizedBox(height: 20),
          Text(
            data["name"],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      onPressed: () {
                        disconnectCall(
                          calluid: data["uid"],
                        );
                        Get.back();
                      },
                      icon: const Icon(Icons.call_end, color: Colors.white),
                    ),
                  ),
                  const Text("Decline"),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: IconButton(
                      onPressed: () {
                        acceptCall(calluid: data["uid"]);
                        Get.back();
                      },
                      icon: const Icon(Ionicons.videocam, color: Colors.white),
                    ),
                  ),
                  const Text("Accept"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

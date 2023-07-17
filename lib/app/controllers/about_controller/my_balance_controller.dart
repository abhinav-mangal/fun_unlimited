import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class MyBalanceController extends ChangeNotifier {
  List<Map<String, dynamic>> diamonds = [];

  bool isLoading = false;

  getDiamondsData() async {
    isLoading = true;
    final doc = await get(
      Uri.parse("http://lafa.dousoftit.com/api/wallet"),
      headers: {
        "Authorization":
            "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYWU5MGVmODk1M2NhN2UxNTBjMzVjM2M0MGUzNTJlMWI3MzFhNzk1OGRkNTIyZmEwMjgzODU5OTUzYzk0MjczODk1NWQwYzE0ZDFjMTczZmUiLCJpYXQiOjE2ODAxMTUwNDYuMDU4NjgwMDU3NTI1NjM0NzY1NjI1LCJuYmYiOjE2ODAxMTUwNDYuMDU4NjgxOTY0ODc0MjY3NTc4MTI1LCJleHAiOjE3MTE3Mzc0NDYuMDUwODg4MDYxNTIzNDM3NSwic3ViIjoiMiIsInNjb3BlcyI6W119.WG4de8i0fPrHm-gBaI4WMxabbqY7yZfIApDpB8KlS9x0mu8-uWXsYzeTlOSLPy8L4RRxt0dk8yBHAqfE-26MRcxIdmZ9JQ-adJOqt7YJLNE5jhIuclCsgqmpoArEMBrI0YPwK4Aw6AR_Gir23Q4XDoiHRbsl4URusj0gcQ8EPf5vZitIMZ-zTVuzS1FdPVqu3xgtIK3vi7Q_6p5hJYOiROLRh0IEJJhRG-u2OZ5jNI_A3vu9zsw7Vitjsk9R9nBMDVdGlNbTOPEY5Ww8CqtnDujnQ44Nfq74tW1RdQTZUM_1TbEZgW-Zy33UDL_vAD3hJiSd8XiCtv3eGMnG3A97KNYquCHlaapFKK9Xj0ARgdlADMVzWs7SOvAMgFepj5MNWmZLmvfLmVkvOn8dbDkDVGRSLfWgtZIK3iZ6Bcyz8VMC0Zn2Y4HPxpwGdtJQPTXVz2LX8AuZuMyIFuLlvbA5-gHtfmjROchI7QMLd7kjwcjLCmkjBbkiGjp3DYViKabx7BjTesSKJHwvckdhx9SNbTu4jZl4mdHfcxe8dQ6T92RvNf90ZBmYdtK4cEcXrKL7zE4DiFJEE5cPa-s1zeOwz_uDeJArYV2O6UHqPgkdGTvVmQ2M4b87GeDrF4VqCy4SBfP-KBFUxAw7I_geROHDYBD_c7L4lul2JSVkINET9TM",
      },
    );
    final data = jsonDecode(doc.body)['data'];
    diamonds = data
        .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
        .toList();
    isLoading = false;
    notifyListeners();
  }

  addDiamonds(int index) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    final diamond = diamonds[index]['saleDiamond'];
    await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'balance': FieldValue.increment(int.parse(diamond)),
    });
    await FirebaseFirestore.instance.collection("Transactions").add({
      'diamond': diamond,
      "type": "add",
      "price": diamonds[index]['price'],
      'date': DateTime.now().millisecondsSinceEpoch,
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: "Diamonds Added Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Get.back();
  }
}

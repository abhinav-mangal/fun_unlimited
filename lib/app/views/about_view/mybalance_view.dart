import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_unlimited/app/controllers/about_controller/my_balance_controller.dart';
import 'package:fun_unlimited/app/user_models/user_model.dart';
import 'package:fun_unlimited/app/views/about_view/transactions_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../common_widgets/common_colors.dart';

class MyBalanceView extends StatefulWidget {
  const MyBalanceView({super.key});

  @override
  State<MyBalanceView> createState() => _MyBalanceViewState();
}

class _MyBalanceViewState extends State<MyBalanceView> {
  late Razorpay _razorpay;
  late MyBalanceController _myBalanceController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _myBalanceController =
        Provider.of<MyBalanceController>(context, listen: false);
    _myBalanceController.getDiamondsData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  //Razorpay payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("SUCCESS: ${response.paymentId}");
    _myBalanceController.addDiamonds(selectedIndex);
  }

  //Razorpay payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    log("ERROR: ${response.code} - ${response.message}");
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: response.message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  //Razorpay external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    log("EXTERNAL_WALLET: ${response.walletName}");
    // Get.back();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  //Start Razorpay payment
  startPayment() async {
    final userData = await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => UserModel.fromJson(value.data()!));
    final level = userData.level;
    final allowedLevel = _myBalanceController.diamonds[selectedIndex]['for'];
    if (allowedLevel != "all") {
      if (int.parse(allowedLevel) > level) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "You are not at the required level to purchase this package",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
    }
    final options = {
      'key': 'rzp_test_sWWURrx9MYgozx',
      'amount':
          int.parse(_myBalanceController.diamonds[selectedIndex]['price']) *
              100,
      'name': 'Lafa-Chat Borderless',
      'description': 'Purchase Diamonds',
      'prefill': {
        'contact': userData.phone.isEmpty ? '' : userData.phone,
        'email': userData.email.isEmpty ? '' : userData.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff9d45fc),
            Color(0xfffb76e9),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: white),
          actions: [
            IconButton(
              icon: const Icon(
                FontAwesome5Solid.headset,
                color: white,
              ),
              color: white,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Ionicons.ios_receipt_outline,
                color: white,
              ),
              color: white,
              onPressed: () {
                Get.to(() => const TransactionsPage());
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'My Diamonds ',
                      style: TextStyle(
                        fontSize: 20,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("User")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: snapshot.hasData
                                    ? snapshot.data!
                                        .data()!['balance']
                                        .toString()
                                    : '0',
                                style: const TextStyle(
                                  fontSize: 35,
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(width: 5),
                              ),
                              const WidgetSpan(
                                child: Icon(
                                  Icons.diamond,
                                  color: yellow,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Consumer<MyBalanceController>(
                    builder: (context, controller, child) {
                      if (controller.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: white,
                          ),
                        );
                      }
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: controller.diamonds.length,
                        itemBuilder: (context, index) {
                          final diamond = controller.diamonds[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              startPayment();
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          diamond['icon'],
                                          width: 100,
                                        ),
                                      ),
                                      Text(
                                        addComma(
                                            diamond['sale_diamond'].toString()),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        addComma(diamond['original_diamond']
                                            .toString()),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        width: Get.width,
                                        decoration: const BoxDecoration(
                                          color: grey,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "₹${(double.parse(diamond['price'].toString()).toStringAsFixed(2))}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (diamond['for'] != "all")
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: purple,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  AntDesign.arrowup,
                                                  color: white,
                                                  size: 14,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Lvl ${diamond['for']}",
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: calculatepercentage(
                                              int.parse(
                                                  diamond['original_diamond']),
                                              int.parse(
                                                  diamond['sale_diamond'])) !=
                                          0
                                      ? Align(
                                          alignment: Alignment.topRight,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffff921d),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    5,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 5,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "${calculatepercentage(int.parse(diamond['original_diamond']), int.parse(diamond['sale_diamond'])).toStringAsFixed(0)}%",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Image.asset(
                                                      "assets/arrows.png",
                                                      width: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Positioned(
                                                top: 0,
                                                right: -5,
                                                bottom: 0,
                                                child: CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor: white,
                                                ),
                                              ),
                                              const Positioned(
                                                top: 0,
                                                left: -5,
                                                bottom: 0,
                                                child: CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor: white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Calculate percentage
  calculatepercentage(int original, int sale) {
    return ((sale - original) / sale) * 100;
  }

  //Add comma after number
  String addComma(String number) {
    String result = "";
    int count = 0;
    for (int i = number.length - 1; i >= 0; i--) {
      if (count == 3) {
        result = ",$result";
        count = 0;
      }
      result = number[i] + result;
      count++;
    }
    return result;
  }
}

import 'package:flutter/material.dart';
import 'package:fun_unlimited/app/controllers/CallController/call_controller.dart';
import 'package:fun_unlimited/app/controllers/UserController/user_controller.dart';
import 'package:provider/provider.dart';

class CallPage extends StatefulWidget {
  final String callid;
  const CallPage({Key? key, required this.callid}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late CallController callController;
  late UserController userController;

  @override
  void initState() {
    super.initState();
    userController = Provider.of<UserController>(context, listen: false);
    callController = Provider.of<CallController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallController>(
      builder: (BuildContext context, value, Widget? child) => WillPopScope(
        onWillPop: () async {
          if (value.isAccepted) {
            await callController.disconnectCall(calluid: callController.uid);
          } else {
            await callController.disconnectCalling();
          }
          return true;
        },
        // child: ZegoUIKitPrebuiltCall(
        //   appID: 1181603960,
        //   appSign:
        //       '5de12f92b097e4d0b3fee8ea25315832053226c5b89182a5bbdd23b271f5ff51',
        //   userID: FirebaseAuth.instance.currentUser!.uid,
        //   userName: userController.user!.name,
        //   callID: widget.callid,
        //   config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        //     // ..onOnlySelfInRoom = (co) async {
        //     //   if (value.isAccepted) {
        //     //     await callController.disconnectCall(
        //     //         calluid: callController.uid);
        //     //   } else {
        //     //     await callController.disconnectCalling();
        //     //   }
        //     //   Get.back();
        //     // }
        //     // ..onHangUp = () async {
        //     //   if (value.isAccepted) {
        //     //     await callController.disconnectCall(
        //     //         calluid: callController.uid);
        //     //   } else {
        //     //     await callController.disconnectCalling();
        //     //   }
        //     //   Get.back();
        //     // },
        // ),
        child: Container(),
      ),
    );
  }
}

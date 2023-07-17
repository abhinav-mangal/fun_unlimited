import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import 'party_controller.dart';

class PreviewWidget extends StatefulWidget {
  final String? uid;
  final String roomId;
  const PreviewWidget({
    Key? key,
    this.uid,
    required this.roomId,
  }) : super(key: key);

  @override
  State<PreviewWidget> createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  int previewViewID = 0;
  Widget canvasView = Container();

  _init() async {
    final controller = Get.find<PartyController>();
    if (controller.isEnginerInited.value == false) {
      await controller.initEnginer();
    }
    final engine = ZegoExpressEngine.instance;
    // await engine.enableCamera(false);
    // await engine.muteMicrophone(true);
    await engine.setVideoMirrorMode(ZegoVideoMirrorMode.BothMirror);

    final canvas = await engine.createCanvasView((viewID) {
      setState(() {
        previewViewID = viewID;
      });
    });
    setState(() {
      canvasView = canvas!;
    });
    await engine.setLowlightEnhancement(ZegoLowlightEnhancementMode.On);
    await engine.loginRoom(widget.roomId,
        ZegoUser(FirebaseAuth.instance.currentUser!.uid, "advdsv"));

    // await engine.startPreview(
    //   canvas: ZegoCanvas(
    //     previewViewID,
    //     viewMode: ZegoViewMode.AspectFill,
    //   ),
    // );
    // ZegoUIKitPrebuiltLiveAudioRoom(appID: appID, appSign: appSign, userID: userID, userName: userName, roomID: roomID, config: config)
    await engine.startPlayingStream(
      widget.uid!,
      canvas: ZegoCanvas(
        previewViewID,
        viewMode: ZegoViewMode.AspectFill,
      ),
      config: ZegoPlayerConfig(
        ZegoStreamResourceMode.Default,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: canvasView,
    );
  }
}

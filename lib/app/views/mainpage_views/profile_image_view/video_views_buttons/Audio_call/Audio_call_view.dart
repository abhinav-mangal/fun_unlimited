// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:fun_unlimited/app/views/mainpage_views/profile_image_view/video_views_buttons/Audio_call/Audio_signaling.dart';
// import 'package:fun_unlimited/app/views/mainpage_views/mainpage_view.dart';
// import 'package:get/get.dart';

// import '../../../../../common_widgets/common_colors.dart';

// class AudioCallView extends StatefulWidget {
//   const AudioCallView({Key? key}) : super(key: key);

//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<AudioCallView> {
//   AudioSignaling signaling = AudioSignaling();
//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   String? roomId;
//   TextEditingController textEditingController = TextEditingController(text: '');

//   bool isTrue = true;

//   @override
//   void initState() {
//     _localRenderer.initialize();
//     _remoteRenderer.initialize();

//     signaling.onAddRemoteStream = ((stream) {
//       _remoteRenderer.srcObject = stream;
//       setState(() {});
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ppurple1,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Join Room Code-: ",
//                     style: TextStyle(color: white),
//                   ),
//                   Flexible(
//                     child: TextFormField(
//                       controller: textEditingController,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(
//               width: 8,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     signaling.joinRoom(
//                       textEditingController.text,
//                       _remoteRenderer,
//                     );
//                   },
//                   child: const CircleAvatar(
//                     radius: 30,
//                     backgroundColor: green,
//                     child: Icon(
//                       Icons.call,
//                       color: white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 15,
//                 ),
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: grey,
//                   child: isTrue
//                       ? InkWell(
//                           onTap: () {
//                             setState(() {
//                               isTrue = false;
//                               signaling.openUserMedia(
//                                   _localRenderer, _remoteRenderer);
//                             });
//                             // signaling.openUserMedia(
//                             //     _localRenderer, _remoteRenderer);
//                           },
//                           child: const CircleAvatar(
//                             radius: 30,
//                             backgroundColor: grey,
//                             child: Icon(
//                               Icons.mic_off,
//                               color: white,
//                             ),
//                           ),
//                         )
//                       : const Icon(
//                           Icons.mic,
//                           color: white,
//                         ),
//                 ),
//                 const SizedBox(
//                   width: 15,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     signaling.hangUp(_remoteRenderer);
//                     _localRenderer.dispose();
//                     _remoteRenderer.dispose();
//                     Get.offAll(() => MainView());
//                   },
//                   child: const CircleAvatar(
//                     radius: 30,
//                     backgroundColor: red,
//                     child: Icon(
//                       Icons.call_end,
//                       color: white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 roomId = await signaling.createRoom(_remoteRenderer);
//                 textEditingController.text = roomId!;
//                 setState(() {});
//               },
//               style: ButtonStyle(
//                 shape: MaterialStateProperty.all(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 backgroundColor: MaterialStateProperty.all(white),
//               ),
//               child: const Text(
//                 "Create room",
//                 style: TextStyle(color: purple),
//               ),
//             ),
//             const SizedBox(
//               width: 8,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationView extends StatefulWidget {
  const CurrentLocationView({Key? key}) : super(key: key);

  @override
  CurrentLocationViewState createState() => CurrentLocationViewState();
}

class CurrentLocationViewState extends State<CurrentLocationView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  // final Completer<GoogleMapController> _controller = Completer();

  // static const CameraPosition _kGoogle = CameraPosition(
  //   target: LatLng(20.42796133580664, 80.885749655962),
  //   zoom: 14.4746,
  // );

  // final List<Marker> _markers = <Marker>[
  //   const Marker(
  //       markerId: MarkerId('1'),
  //       position: LatLng(20.42796133580664, 75.885749655962),
  //       infoWindow: InfoWindow(
  //         title: 'My Position',
  //       )),
  // ];

  // Future<Position> getUserCurrentLocation() async {
  //   await Geolocator.requestPermission()
  //       .then((value) {})
  //       .onError((error, stackTrace) async {
  //     await Geolocator.requestPermission();
  //     print("ERROR$error");
  //   });
  //   return await Geolocator.getCurrentPosition();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: green,
  //       title: const Text("My current Location"),
  //     ),
  //     body: Container(
  //       child: SafeArea(
  //         child: GoogleMap(
  //           initialCameraPosition: _kGoogle,
  //           markers: Set<Marker>.of(_markers),
  //           mapType: MapType.normal,
  //           myLocationEnabled: true,
  //           compassEnabled: true,
  //           onMapCreated: (GoogleMapController controller) {
  //             _controller.complete(controller);
  //           },
  //         ),
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () async {
  //         getUserCurrentLocation().then((value) async {
  //           print("${value.latitude} ${value.longitude}");

  //           _markers.add(Marker(
  //             markerId: const MarkerId("2"),
  //             position: LatLng(value.latitude, value.longitude),
  //             infoWindow: const InfoWindow(
  //               title: 'My Current Location',
  //             ),
  //           ));

  //           CameraPosition cameraPosition = CameraPosition(
  //             target: LatLng(value.latitude, value.longitude),
  //             zoom: 14,
  //           );

  //           final GoogleMapController controller = await _controller.future;

  //           controller
  //               .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //           setState(() {});
  //         });
  //       },
  //       child: const Icon(Icons.local_activity),
  //     ),
  //   );
}

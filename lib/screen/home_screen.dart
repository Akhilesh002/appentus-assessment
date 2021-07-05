import 'dart:async';
import 'dart:io';

import 'package:appentus_assessment/db/db_helper.dart';
import 'package:appentus_assessment/screen/second_screen.dart';
import 'package:appentus_assessment/screen/splash_screen.dart';
import 'package:appentus_assessment/util/constant.dart';
import 'package:appentus_assessment/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box? userBox = DbHelper().getUserBox();
  Completer<GoogleMapController> _controller = Completer();
  Position? currentPosition;
  String? currentAddress;
  CameraPosition? initialCameraPosition;
  Marker? marker;
  List<Marker> markers = <Marker>[];

  @override
  void initState() {
    super.initState();
    checkPermission();
    getCurrentPosition();
  }

  getCurrentPosition() async {
    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (currentPosition != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        zoom: 15,
      );
      marker = Marker(
        markerId: MarkerId('currentPosition'),
        position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        infoWindow: InfoWindow(title: 'You'),
      );
      markers.add(marker!);
      setState(() {});
    }
  }

  checkPermission() async {
    PermissionStatus locationPermissionStatus = await Utility.checkPermission(Permission.location);
    if (locationPermissionStatus.isGranted) {
    } else {
      await Utility.requestPermission(Permission.location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            height: 20.0,
            width: 20.0,
            child: CircleAvatar(backgroundImage: FileImage(File(userBox?.get(Constant.image))), radius: 10, backgroundColor: Colors.white)),
        title: Text(userBox?.get(Constant.name)),
        actions: [
          IconButton(
            onPressed: () {
              Box? userBox = DbHelper().getUserBox();
              if (userBox!.containsKey(Constant.isLoggedIn)) {
                userBox.delete(Constant.isLoggedIn);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
              }
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight - 30,
            width: MediaQuery.of(context).size.width,
            child: initialCameraPosition != null
                ? Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: initialCameraPosition!,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: Set.of(markers),
                      ),
                      Positioned(
                        bottom: 30.0,
                        left: MediaQuery.of(context).size.width / 2 - 100,
                        child: Container(
                          height: 50.0,
                          width: 200.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen()));
                            },
                            child: Text(
                              'Second Screen',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}

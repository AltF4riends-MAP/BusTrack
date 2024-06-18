import 'dart:async';

import 'package:bustrack/src/features/authentication/controllers/navigations.dart';
import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class BusDriverPage extends StatefulWidget {
  final Bus data;

  BusDriverPage(this.data);

  @override
  _BusDriverPageState createState() => _BusDriverPageState();
}

class _BusDriverPageState extends State<BusDriverPage> {
  GoogleMapController? _mapController;
  Marker? _currentLocationMarker;
  Position? _currentPosition;
  ValueNotifier<bool> trackingNotifier = ValueNotifier<bool>(true);
  StreamSubscription<Position>? _positionStreamSubscription;

  LatLng _center = const LatLng(1.5754316068552179, 103.61788395334298);
  String buttonText = "";
  Color boxColor = Color.fromRGBO(255, 0, 0, 1);
  String busName = "";

  List<Bus> busList = [];
  List<Routes> routeList = [];
  List<Stop> stopList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _checkPermissionsAndGetLocation();
  }

  Future<void> _checkPermissionsAndGetLocation() async {
    PermissionStatus permission = await Permission.locationWhenInUse.status;

    if (permission == PermissionStatus.denied) {
      permission = await Permission.locationWhenInUse.request();
    }

    if (permission == PermissionStatus.granted) {
      _getCurrentLocation();
      _listenToLocationUpdates();
    } else if (permission == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else {
      Navigator.pushNamed(context, loginRoute);
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    BitmapDescriptor busMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/homepage/BusIcon2.png',
    );

    setState(() {
      _currentPosition = position;
      _currentLocationMarker = Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Current Location'),
        icon: busMarker,
        anchor: Offset(0.5, 1.0),
      );
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(
      LatLng(position.latitude, position.longitude),
    ));
  }

  void _listenToLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      if (position != null) {
        setState(() {
          _currentPosition = position;
          _currentLocationMarker = Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'Current Location'),
            icon:
                _currentLocationMarker?.icon ?? BitmapDescriptor.defaultMarker,
            anchor: Offset(0.5, 1.0),
          );
        });

        final busInformation = <String, dynamic>{
          "posX": position.latitude,
          "posY": position.longitude
        };
        final dBase = FirebaseFirestore.instance;
        await dBase
            .collection("Bus")
            .doc(widget.data.id)
            .update(busInformation);

        _mapController?.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ));
      }
    });
  }

  late List<Map<String, dynamic>> timeList = List.from(createtimeTable());

  void _toggleTracking() {
    if (trackingNotifier.value) {
      _positionStreamSubscription?.pause();
    } else {
      _positionStreamSubscription?.resume();
    }
    trackingNotifier.value = !trackingNotifier.value;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.25,
              maxChildSize: 0.75,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return ValueListenableBuilder(
                  valueListenable: trackingNotifier,
                  builder: (context, tracking, child) {
                    return Container(
                      color: Colors.white,
                      width: 1000,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(busName),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: FloatingActionButton(
                                backgroundColor: boxColor,
                                onPressed: () {
                                  setState(() {
                                    changeButton();
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text(
                                  buttonText,
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: 2,
                                  ),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: timeList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var timeSlot = timeList[index];
                                    return ListTile(
                                      title: Text(timeSlot['startTime'] + " - " + timeSlot['endTime']),
                                      );
                                  },
                                )),
                            ElevatedButton(
                              onPressed: _toggleTracking,
                              child: Text(tracking
                                  ? "Stop Tracking"
                                  : "Start Tracking"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> fetchData() async {
    ReadAllController read = ReadAllController();
    busList = await read.getAllBus();
    routeList = await read.getAllRoute();
    stopList = await read.getAllStop();

    for (Routes route in routeList) {
      route.setStop(stopList);
    }

    for (Bus bus in busList) {
      bus.setRoute(routeList);
    }

    setState(() {
      buttonText = widget.data.busDriveStatus;
      if (buttonText == "STOP") {
        boxColor = Color.fromRGBO(255, 0, 0, 1);
      } else {
        boxColor = Color.fromRGBO(115, 0, 255, 1);
      }
      busName = widget.data.busName;
    });
  }

  void changeButton() async {
    final dBase = FirebaseFirestore.instance;

    if (buttonText == "STOP") {
      final busInformation = {"busDriveStatus": "DRIVE"};
      await dBase.collection("Bus").doc(widget.data.id).update(busInformation);
      setState(() {
        buttonText = "DRIVE";
        widget.data.busDriveStatus = "DRIVE";
        boxColor = Color.fromRGBO(115, 0, 255, 1);
      });
    } else {
      final busInformation = {"busDriveStatus": "STOP"};
      await dBase.collection("Bus").doc(widget.data.id).update(busInformation);
      setState(() {
        buttonText = "STOP";
        widget.data.busDriveStatus = "STOP";
        boxColor = Color.fromRGBO(255, 0, 0, 1);
      });
    }
  }

  List<Map<String, dynamic>> createtimeTable() {
    DateTime start = DateTime.parse(
        '2023-05-10 ' + widget.data.route.routeTimeStart + ':00');
    DateTime end =
        DateTime.parse('2023-05-10 ' + widget.data.route.routeTimeEnd + ':00');

    Duration duration = Duration(minutes: 30);

    late DateTime start1 = start;
    late DateTime start2;

    List<Map<String, dynamic>> timetable = [];

    for (var i = 0; i < 30; i++) {
      start2 = start1;
      start1 = start1.add(duration);
      Map<String, dynamic> ttSlot = new Map();

      late var oldTimeForm = DateFormat('kk:mm').format(start2);
      late var startTimeForm = DateFormat('kk:mm').format(start1);
      late var endTimeForm = DateFormat('kk:mm').format(end);

      ttSlot["startTime"] = oldTimeForm;
      ttSlot["endTime"] = startTimeForm;

      timetable.add(ttSlot);

      if (startTimeForm == endTimeForm) {
        break;
      }
    }

    return timetable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bus Driver Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(124, 0, 0, 1),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              if (_currentPosition != null) {
                controller.animateCamera(CameraUpdate.newLatLng(
                  LatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude),
                ));
              }
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 17.0,
            ),
            markers:
                _currentLocationMarker != null ? {_currentLocationMarker!} : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(124, 0, 0, 1),
                onPressed: () => _showBottomSheet(context),
                child: Icon(
                  Icons.arrow_upward,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}

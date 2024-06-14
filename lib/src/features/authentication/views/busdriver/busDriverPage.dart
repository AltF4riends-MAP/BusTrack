import 'package:bustrack/src/features/authentication/controllers/navigations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class BusDriverPage extends StatefulWidget {
  @override
  _BusDriverPageState createState() => _BusDriverPageState();
}

class _BusDriverPageState extends State<BusDriverPage> {
  GoogleMapController? _mapController;
  Marker? _currentLocationMarker;
  Position? _currentPosition;

  LatLng _center = const LatLng(1.5754316068552179, 103.61788395334298);
  String buttonText = "STOP";
  Color boxColor = Color.fromRGBO(255, 0, 0, 1);

  @override
  void initState() {
    super.initState();
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
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      // ignore: unnecessary_null_comparison
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

        _mapController?.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ));
      }
    });
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
                return Container(
                  color: Colors.white,
                  width: 1000,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: FloatingActionButton(
                            backgroundColor: boxColor,
                            onPressed: () {
                              setState(() {
                                buttonText =
                                    buttonText == "STOP" ? "DRIVE" : "STOP";
                                if (buttonText == "STOP") {
                                  boxColor = Color.fromRGBO(255, 0, 0, 1);
                                } else {
                                  boxColor = Color.fromRGBO(115, 0, 255, 1);
                                }
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
}

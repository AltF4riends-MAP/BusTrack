import 'package:bustrack/src/features/authentication/controllers/navigations.dart';
import 'package:bustrack/src/features/authentication/views/timetable/view_TableDetail.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTimetable extends StatefulWidget {
  const ViewTimetable({Key? key}) : super(key: key);

  @override
  State<ViewTimetable> createState() => _ViewTimetableState();
}

class _ViewTimetableState extends State<ViewTimetable> {
  List<Bus> busList = [];
  List<Routes> routeList = [];
  List<Stop> stopList = [];
  late GoogleMapController mapController;

  LatLng _center = const LatLng(1.5754316068552179, 103.61788395334298);
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    listenToBusUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "View Timetable",
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        backgroundColor: Color.fromRGBO(104, 1, 1, 1),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 500,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 17.0,
                ),
                markers: _markers,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 820,
                    height: 1100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background_mp.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 350,
                        height: 350,
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
                          itemCount: busList.length,
                          itemBuilder: (context, index) {
                            final bus = busList[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setCentre(bus);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons
                                                  .directions_bus_filled_rounded),
                                              onPressed: () async {},
                                            ),
                                            SizedBox(
                                              width: 70,
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                bus.busName,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 70,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.remove_red_eye),
                                              onPressed: () async {},
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.settings),
                                              onPressed: () async {
                                                Navigator.pushNamed(context,
                                                    manageTimetableRoute,
                                                    arguments: bus);
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.punch_clock_outlined),
                                              onPressed: () async {},
                                            ),
                                            Text(
                                              bus.route.routeTimeStart +
                                                  " - " +
                                                  bus.route.routeTimeEnd,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.stop_circle_outlined),
                                              onPressed: () async {},
                                            ),
                                            Expanded(
                                              child: Text(
                                                bus.route.stop[0].stopName +
                                                    " to\n " +
                                                    bus.route.stop.last
                                                        .stopName,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 4,
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: bus.busStatus == "active"
                                              ? Colors.lightGreen
                                              : Colors.red,
                                          height: 50,
                                          thickness: 8,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda),
            label: 'View Timetable',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Bus',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'LogOut'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, viewTimetableRoute);
              break;
            case 1:
              Navigator.pushNamed(context, addTimetableRoute);
              break;
            case 2:
              Navigator.pushNamed(context, loginRoute);
              break;
          }
        },
      ),
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
      //print(bus.route.stop[0].stopName);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void setCentre(Bus bus) {
    LatLng newCenter = LatLng(bus.posX, bus.posY);
    mapController.animateCamera(
      CameraUpdate.newLatLng(newCenter),
    );
    setState(() {
      _center = newCenter;
      _addMarker(_center, bus.busName, bus.busDriveStatus);
    });
    print(_center);
  }

  void _addMarker(LatLng position, String title, String status) async {
    BitmapDescriptor busMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/homepage/BusIcon2.png',
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(title),
          position: position,
          infoWindow: InfoWindow(title: title, snippet: status),
          icon: busMarker,
        ),
      );
    });
  }

  void listenToBusUpdates() {
    FirebaseFirestore.instance.collection('Bus').snapshots().listen((snapshot) {
      print(
          "CHANGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.modified) {
          Bus updatedBus = Bus.fromFirestore(change.doc);
          _updateBusMarker(updatedBus);
        }
      });
    });
  }

  void _updateBusMarker(Bus bus) {
    LatLng newPosition = LatLng(bus.posX, bus.posY);
    print(newPosition);
    print(bus.busName);
    print(bus);
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == bus.busName);
      _addMarker(newPosition, bus.busName, bus.busDriveStatus);
    });
    mapController.animateCamera(
      CameraUpdate.newLatLng(newPosition),
    );
  }
}

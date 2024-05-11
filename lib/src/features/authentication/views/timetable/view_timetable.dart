import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';
// Import homepage

class ViewTimetable extends StatefulWidget {
  const ViewTimetable({Key? key}) : super(key: key);

  @override
  State<ViewTimetable> createState() => _ViewTimetableState();
}

class _ViewTimetableState extends State<ViewTimetable> {
  List<BusModel> busList = [];
  List<Routes> routeList = [];
  List<Stop> stopList = [];
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(1.5754316068552179, 103.61788395334298);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
        actions: [
          // Add bus button
          IconButton(
            icon: const Text(
              "Add Bus",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/addform');
            },
          ),
        ],
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
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 2,
                            ),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: busList.length,
                            itemBuilder: (context, index) {
                              final bus = busList[index];
                              return ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons
                                              .directions_bus_filled_rounded),
                                          onPressed: () async {},
                                        ),
                                        Text(
                                          bus.busName,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 100,
                                        ),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.remove_red_eye),
                                          onPressed: () async {},
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
                                          bus.routeTimeStart +
                                              "-" +
                                              bus.routeTimeEnd,
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
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                          softWrap: true,
                                          bus.routeTimeStart +
                                              "-" +
                                              bus.routeTimeEnd,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      print(route.stop);
    }

    for (BusModel bus in busList) {
      bus.setRoute(routeList);
      print(bus.route.stop[0].stopName);
    }

    if (mounted) {
      setState(() {});
    }
  }
}

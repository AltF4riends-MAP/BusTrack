import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';

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
          "Add Timetable",
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
                      padding: const EdgeInsets.all(22.0),
                      child: Container(
                        width: 320,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromARGB(255, 0, 0, 0),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 10), // Add spacing between the texts
                            Expanded(
                              child: Text(
                                busList.isNotEmpty
                                    ? busList[0].busName
                                    : 'No data',
                                style: TextStyle(
                                    // Add your text style properties here
                                    ),
                              ),
                            ),
                            SizedBox(
                                width: 10), // Add spacing between the texts
                            Expanded(
                              child: Text(
                                routeList.isNotEmpty
                                    ? routeList[0].routeName
                                    : 'No data',
                                style: TextStyle(
                                    // Add your text style properties here
                                    ),
                              ),
                            ),
                            SizedBox(
                                width: 10), // Add spacing between the texts
                            Expanded(
                              child: Text(
                                stopList.isNotEmpty
                                    ? stopList[0].stopName
                                    : 'No data',
                                style: TextStyle(
                                    // Add your text style properties here
                                    ),
                              ),
                            ),
                          ],
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
    );
  }

  Future<void> fetchData() async {
    ReadAllController read = ReadAllController();
    busList = await read.getAllBus();
    routeList = await read.getAllRoute();
    stopList = await read.getAllStop();

    // Once the data is fetched, you can setState to trigger a rebuild
    if (mounted) {
      setState(() {
        // Update the state variables
      });
    }
  }
}

import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/views/timetable/dropDown.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/src/features/authentication/controllers/navigations.dart';
import 'package:bustrack/src/features/authentication/views/login/formcontainer.dart';

import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';

class AddBus extends StatefulWidget {
  const AddBus({Key? key}) : super(key: key);

  @override
  State<AddBus> createState() => _AddBusState();
}

class _AddBusState extends State<AddBus> {
  List<Stop> _selectedStops = [];
  List<Bus> _busList = [];
  List<Routes> _routeList = [];
  List<Stop> _stopList = []; // Track selected stops
  final dBase = FirebaseFirestore.instance;
  bool _isSigning = false;

  final busName = TextEditingController();
  final busDescription = TextEditingController();
  final busPlateNum = TextEditingController();

  final busStatus = TextEditingController();
  final routeName = TextEditingController();
  final routeStatus = TextEditingController();
  final routeStop = TextEditingController();
  final routeTimeStart = TextEditingController();
  final routeTimeEnd = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Add Bus"),
        backgroundColor: const Color.fromRGBO(124, 0, 0, 1),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
                image: const DecorationImage(
                  image: AssetImage("assets/images/Rectangle.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 700,
                height: 1500,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Add Bus",
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      FormContainerWidget(
                        controller: busName,
                        hintText: "Bus Name",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      FormContainerWidget(
                        controller: busDescription,
                        hintText: "Bus Description",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      FormContainerWidget(
                        controller: busPlateNum,
                        hintText: "Plate Num",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      FormContainerWidget(
                        controller: busStatus,
                        hintText: "Status(active/inactive)",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      FormContainerWidget(
                        controller: routeName,
                        hintText: "Route Name",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      FormContainerWidget(
                        controller: routeStatus,
                        hintText: "Route Status(active/inactive)",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      DropdownChecklist(
                        stopList: _stopList, // Pass your list of stops here
                        selectedStops: _selectedStops,
                        onChanged: (selectedStops) {
                          setState(() {
                            _selectedStops = selectedStops;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      FormContainerWidget(
                        controller: routeTimeStart,
                        hintText: "Start Time",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      FormContainerWidget(
                        controller: routeTimeEnd,
                        hintText: "End Time",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          print("****************" +
                              busName.text +
                              "*********************************");
                          List<String> stopID = [];
                          for (Stop stopp in _selectedStops) {
                            stopID.add(stopp.id);
                          }
                          final routeInformation = <String, dynamic>{
                            "routeName": routeName.text,
                            "routeStatus": routeStatus.text,
                            "routeTimeStart": routeTimeStart.text,
                            "routeTimeEnd": routeTimeEnd.text,
                            "routeStops": stopID,
                          };
                          var busInformation = <String, String>{
                            "busName": busName.text,
                            "busStatus": busStatus.text,
                            "busPlateNum": busPlateNum.text,
                            "busDescription": busDescription.text,
                          };

                          final newRouteRef = dBase.collection("Route").doc();

                          newRouteRef.set(routeInformation).then((value) async {
                            String documentId = newRouteRef.id;
                            busInformation.addAll({
                              "busRoute": documentId,
                            });
                            dBase
                                .collection("Bus")
                                .doc()
                                .set(busInformation)
                                .then((value) {
                              print(busInformation);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Bus information added successfully!'),
                              ),
                            );
                          });

                          busName.clear();
                          busDescription.clear();
                          busPlateNum.clear();
                          busStatus.clear();
                          routeName.clear();
                          routeTimeStart.clear();
                          routeTimeEnd.clear();
                          Navigator.pushNamed(context, viewTimetableRoute);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isSigning
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Add",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, viewTimetableRoute);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    ReadAllController read = ReadAllController();
    _busList = await read.getAllBus();
    _routeList = await read.getAllRoute();
    _stopList = await read.getAllStop();
    for (Routes route in _routeList) {
      route.setStop(_stopList);
      print(route.stop);
    }

    for (Bus bus in _busList) {
      bus.setRoute(_routeList);
      print(bus.route.stop[0].stopName);
    }

    if (mounted) {
      setState(() {});
    }
  }
}

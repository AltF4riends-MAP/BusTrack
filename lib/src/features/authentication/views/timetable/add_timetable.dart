import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/views/timetable/dropDown.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final routeTimeStart = TextEditingController();
  final routeTimeEnd = TextEditingController();

  User? currentUser = null;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool validateFields() {
    if (busName.text.isEmpty) {
      showSnackBar('Bus Name cannot be empty');
      return false;
    }
    if (busDescription.text.isEmpty) {
      showSnackBar('Bus Description cannot be empty');
      return false;
    }
    if (busPlateNum.text.isEmpty) {
      showSnackBar('Bus Plate Number cannot be empty');
      return false;
    }
    if (busStatus.text.isEmpty) {
      showSnackBar('Bus Status cannot be empty');
      return false;
    }

    if (routeStatus.text.isEmpty) {
      showSnackBar('Route Status cannot be empty');
      return false;
    }
    if (routeTimeStart.text.isEmpty) {
      showSnackBar('Start Time cannot be empty');
      return false;
    }
    if (routeTimeEnd.text.isEmpty) {
      showSnackBar('End Time cannot be empty');
      return false;
    }
    if (_selectedStops.isEmpty) {
      showSnackBar('Please select at least one stop');
      return false;
    }
    return true;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<String?> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      return '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          "Add Bus",
        ),
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
                height: 1200,
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            "Bus Name",
                          ),
                        ],
                      ),
                      FormContainerWidget(
                        controller: busName,
                        hintText: "Bus Name",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            "Bus Description",
                          ),
                        ],
                      ),
                      FormContainerWidget(
                        controller: busDescription,
                        hintText: "Bus Description",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            "Bus Plate Num",
                          ),
                        ],
                      ),
                      FormContainerWidget(
                        controller: busPlateNum,
                        hintText: "Plate Num",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            "Bus Status",
                          ),
                        ],
                      ),
                      FormContainerWidget(
                        controller: busStatus,
                        hintText: "Status(active/inactive)",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            "Route Name",
                          ),
                        ],
                      ),
                      FormContainerWidget(
                        controller: routeName,
                        hintText: "Route Name",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            "Route Status",
                          ),
                        ],
                      ),
                      FormContainerWidget(
                        controller: routeStatus,
                        hintText: "Route Status(active/inactive)",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 30),
                      DropdownChecklist(
                        stopList: _stopList,
                        selectedStops: _selectedStops,
                        onChanged: (selectedStops) {
                          setState(() {
                            _selectedStops = selectedStops;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            "Start Time",
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          final selectedTime = await selectTime(context);
                          if (selectedTime != null) {
                            setState(() {
                              routeTimeStart.text = selectedTime;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: FormContainerWidget(
                            controller: routeTimeStart,
                            hintText: "Start Time",
                            isPasswordField: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            "End Time",
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          final selectedTime = await selectTime(context);
                          if (selectedTime != null) {
                            setState(() {
                              routeTimeEnd.text = selectedTime;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: FormContainerWidget(
                            controller: routeTimeEnd,
                            hintText: "End Time",
                            isPasswordField: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          if (!validateFields()) {
                            return;
                          }

                          print("****************" +
                              busName.text +
                              "*********************************");
                          List<String> stopID = [];
                          for (Stop stopp in _selectedStops) {
                            stopID.add(stopp.id);
                          }

                          Map<String, String> stopsMap = {};

                          for (int i = 0; i < stopID.length; i++) {
                            stopsMap[i.toString()] = stopID[i];
                          }

                          List<String> stopIDs =
                              _selectedStops.map((stop) => stop.id).toList();

                          final routeInformation = <String, dynamic>{
                            "routeName": routeName.text,
                            "routeStatus": routeStatus.text,
                            "routeTimeStart": routeTimeStart.text,
                            "routeTimeEnd": routeTimeEnd.text,
                            "routeStops": {}
                          };
                          var busInformation = <String, dynamic>{
                            "busName": busName.text,
                            "busStatus": busStatus.text.toLowerCase(),
                            "busPlateNum": busPlateNum.text,
                            "busDescription": busDescription.text,
                            "busDriveStatus": "STOP",
                            "posX": 0.0001,
                            "posY": 0.0001
                          };

                          var UserInformation = <String, dynamic>{
                            "busDriver": "",
                          };
                          for (int i = 0; i < stopIDs.length; i++) {
                            routeInformation['routeStops'][i.toString()] =
                                stopIDs[i];
                          }

                          final newRouteRef = dBase.collection("Route").doc();

                          newRouteRef.set(routeInformation).then((value) async {
                            String documentId = newRouteRef.id;
                            busInformation.addAll({
                              "busRoute": documentId,
                            });
                            final newBusRefBase = dBase.collection("Bus").doc();

                            newBusRefBase
                                .set(busInformation)
                                .then((value) async {
                              print(busInformation);
                              UserInformation = <String, dynamic>{
                                "busDriver": newBusRefBase.id,
                              };

                              final UserRef = dBase
                                  .collection("User")
                                  .doc(currentUser?.uid);
                              UserRef.update(UserInformation);
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
                                    color: Colors.white,
                                  )
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

    final User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is not null
    if (user != null) {
      currentUser = user;
    }

    if (mounted) {
      setState(() {});
    }
  }
}

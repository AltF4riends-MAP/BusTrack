import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/views/timetable/dropDown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/src/features/authentication/controllers/navigations.dart';
import 'package:bustrack/src/features/authentication/views/login/formcontainer.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';

class ManageBus extends StatefulWidget {
  final Bus _data;
  ManageBus(this._data);

  @override
  State<ManageBus> createState() => _ManageBusState();
}

class _ManageBusState extends State<ManageBus> {
  List<Stop> _selectedStops = [];
  List<Bus> _busList = [];
  List<Routes> _routeList = [];
  List<Stop> _stopList = [];
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    busName.dispose();
    busDescription.dispose();
    busPlateNum.dispose();
    busStatus.dispose();
    routeName.dispose();
    routeStatus.dispose();
    routeTimeStart.dispose();
    routeTimeEnd.dispose();
    super.dispose();
  }

  void _handleStopsChanged(List<Stop> updatedStops) {
    setState(() {
      _selectedStops = updatedStops;
    });
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
    if (busStatus.text.isEmpty) {
      showSnackBar('Bus Status cannot be empty');
      return false;
    }
    if (routeName.text.isEmpty) {
      showSnackBar('Route Name cannot be empty');
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
        title: const Text("Manage Bus"),
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
                        "Manage Bus",
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
                          onChanged: _handleStopsChanged),
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
                          if (!validateFields()) return;

                          List<String> stopID = [];
                          for (Stop stopp in _selectedStops) {
                            stopID.add(stopp.id);
                            print("idddddddddddddddddddd:" + stopp.id);
                          }

                          List<String> stopIDs =
                              _selectedStops.map((stop) => stop.id).toList();

                          final routeInformation = <String, dynamic>{
                            "routeName": routeName.text,
                            "routeStatus": routeStatus.text,
                            "routeTimeStart": routeTimeStart.text,
                            "routeTimeEnd": routeTimeEnd.text,
                            "routeStops": {},
                          };

                          for (int i = 0; i < stopIDs.length; i++) {
                            routeInformation['routeStops'][i.toString()] =
                                stopIDs[i];
                          }

                          final newRouteRef = dBase
                              .collection("Route")
                              .doc(widget._data.route.id);

                          newRouteRef
                              .update(routeInformation)
                              .then((value) async {
                            String documentId = newRouteRef.id;
                            var busInformation = <String, String>{
                              "busName": busName.text,
                              "busStatus": busStatus.text.toLowerCase(),
                              "busPlateNum": busPlateNum.text,
                              "busDescription": busDescription.text,
                              "busRoute": documentId,
                            };

                            dBase
                                .collection("Bus")
                                .doc(widget._data.id)
                                .update(busInformation)
                                .then((value) {
                              print(busInformation);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Bus information updated successfully!'),
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
                          }).catchError((error) {
                            print("Failed to update route: $error");
                          });
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
                                    "Update",
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
    }

    for (Bus bus in _busList) {
      bus.setRoute(_routeList);
      print(bus.route.stop[0].stopName);
    }

    busName.text = widget._data.busName;
    busDescription.text = widget._data.busDescription;
    busPlateNum.text = widget._data.busPlateNum;
    busStatus.text = widget._data.busStatus;
    routeName.text = widget._data.route.routeName;
    routeStatus.text = widget._data.route.routeStatus;
    routeTimeStart.text = widget._data.route.routeTimeStart;
    routeTimeEnd.text = widget._data.route.routeTimeEnd;

    setState(() {
      _selectedStops = List.from(widget._data.route.stop);
    });
  }
}

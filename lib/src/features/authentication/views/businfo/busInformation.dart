import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';
import 'package:intl/intl.dart';

class BusInformation extends StatefulWidget {
  final Bus currentBus;

  const BusInformation({Key? key, required this.currentBus}) : super(key: key);

  @override
  State<BusInformation> createState() => _BusInformationState();
}

class _BusInformationState extends State<BusInformation> {
  void initState() {
    super.initState();
  }

  List<Bus> busList = [];
  List<Routes> routeList = [];
  List<Stop> stopList = [];

  String busName = "";
  int busTimeIndex = -1;

  List<Map<String, dynamic>> createtimeTable() {
    if (widget.currentBus.route.routeTimeStart.isNotEmpty ||
        widget.currentBus.route.routeTimeEnd.isNotEmpty) {
      DateTime start = DateTime.parse(
          '2023-05-10 ' + widget.currentBus.route.routeTimeStart + ':00');
      DateTime end = DateTime.parse(
          '2023-05-10 ' + widget.currentBus.route.routeTimeEnd + ':00');

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
    } else {
      List<Map<String, dynamic>> error = [
        {"startTime": "An Error has occured", "endTime": "Please try again"}
      ];
      return error;
    }
  }

  late List<Map<String, dynamic>> timeList = List.from(createtimeTable());

  Widget updateBusBorder(String sT, String eT) {
    DateTime currentTime = DateTime.now();

    late var nowTimeForm = DateFormat('kk:mm').format(currentTime);

    DateTime nowTime = DateTime.parse('2023-05-10 ' + nowTimeForm + ':00');
    DateTime startTime = DateTime.parse('2023-05-10 ' + sT + ':00');
    DateTime endTime = DateTime.parse('2023-05-10 ' + eT + ':00');

    if (nowTime.isBefore(endTime) && nowTime.isAfter(startTime)) {
      return Icon(Icons.done);
    }

    return Icon(Icons.close);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentBus.busName + ' TimeTable Detail',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Color.fromRGBO(104, 1, 1, 1),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 325,
                height: 300,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 325,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        widget.currentBus.busName + " Information",
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      height: 100,
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Bus Description: " +
                              widget.currentBus.busDescription,
                          overflow: TextOverflow.clip),
                    ),
                    Divider(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Bus Plate Number: " + widget.currentBus.busPlateNum,
                          overflow: TextOverflow.clip),
                    ),
                    Divider(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: Text("Bus Status: " + widget.currentBus.busStatus,
                          overflow: TextOverflow.clip),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            //The list of scheduling
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    // color: Color.fromARGB(255, 0, 0, 0),
                    width: 2,
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: timeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var timeSlot = timeList[index];
                    return Column(children: [
                      Container(
                        width: 275,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: busTimeIndex == index
                                ? Colors.green.shade100
                                : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          title: Text(timeSlot['startTime'] +
                              " - " +
                              timeSlot['endTime']),
                            trailing: updateBusBorder(timeSlot['startTime'].toString(), timeSlot['endTime'].toString()),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 25,
                        thickness: 3,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchData(String currentBus) async {
    ReadAllController read = ReadAllController();
    busList = await read.getAllBus();
    routeList = await read.getAllRoute();
    stopList = await read.getAllStop();

    for (Routes route in routeList) {
      route.setStop(stopList);
      print(route.stop);
    }

    for (Bus bus in busList) {
      bus.setRoute(routeList);
      print(bus.route.stop[0].stopName);
    }

    final docRef = FirebaseFirestore.instance.collection("Bus").doc(currentBus);
    docRef.get().then(
          (value) => (DocumentSnapshot doc) {
            final data = doc.data();
            return data;
          },
          onError: (e) => print("Error getting document: $e"),
        );
  }
}

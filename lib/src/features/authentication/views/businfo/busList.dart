import 'dart:math';

import 'package:bustrack/src/features/authentication/controllers/navigations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class BusList extends StatefulWidget {
  const BusList({Key? key}) : super(key: key);

  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  void initState() {
    super.initState();
    fetchData();
  }

  List<Bus> busList = [];
  List<Routes> routeList = [];
  List<Stop> stopList = [];

  DateTime startS = DateTime.parse('2023-05-10 ' + '09:05' + ':00');
  DateTime endS = DateTime.parse('2024-05-10 18:15:00');

  Duration duration = Duration(minutes: 30);

  late DateTime startSNew = startS;
  late DateTime startSOld = startSNew;

  printTimeTable() {
    for (var i = 0; i < 30; i++) {
      startSOld = startSNew;
      startSNew = startSNew.add(duration);

      late var oldTimeForm = DateFormat('kk:mm').format(startSOld);
      late var startTimeForm = DateFormat('kk:mm').format(startSNew);
      late var endTimeForm = DateFormat('kk:mm').format(endS);

      Text(oldTimeForm + " to " + startTimeForm);

      if (startTimeForm == endTimeForm) {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Information',
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
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2,
                    ),
                  ),
                  child: 
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: busList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final bus = busList[index];
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                              child: ListTile(
                                tileColor: bus.busStatus == "active" ? Colors.green:Colors.red,
                                title: Text(bus.busName),
                                subtitle: Text(bus.route.routeName),
                                onTap: () async {
                                  Navigator.pushNamed(context, busInformation, arguments: bus);
                                },
                            )
                            )
                          )
                        );
                    },
                  )
                ),
            ),
          )
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
    }

    for (Bus bus in busList) {
      bus.setRoute(routeList);
      //print(bus.route.stop[0].stopName);
    }

    if (mounted) {
      setState(() {});
    }
  }

  colorStatus(String status) {
    if (status == "active") {
      return Colors.green;
    } else {
      return Colors.red;
    }
  } //Color of Tile
}

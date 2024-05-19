import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';

class ViewTableDetail extends StatefulWidget {
  final Bus currentBus;

  const ViewTableDetail({Key? key, required this.currentBus}) : super(key: key);

  // const ViewTableDetail(
  //   this.text
  // );

  @override
  State<ViewTableDetail> createState() => _ViewDetailTableState();
}

class _ViewDetailTableState extends State<ViewTableDetail> {
  void initState() {
    super.initState();
  }

  List<Bus> busList = [];
  List<Routes> routeList = [];
  List<Stop> stopList = [];

  DateTime now = DateTime.now();
  DateTime later = DateTime.now().add(const Duration(minutes: 30));

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
                width: 350,
                height: 350,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 350,
                      height: 125,
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      height: 125,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0),
                          width: 2,
                        ),
                      ),
                      child: Text(
                          "Bus Description: " +
                              widget.currentBus.busDescription,
                          overflow: TextOverflow.clip),
                    ),
                    Divider(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      height: 75,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0),
                          width: 2,
                        ),
                      ),
                      child: Text(
                          "Bus Plate Number: " + widget.currentBus.busPlateNum,
                          overflow: TextOverflow.clip),
                    ),
                    Divider(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      height: 75,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0),
                          width: 2,
                        ),
                      ),
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
                child: SizedBox(),
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

import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/src/features/authentication/controllers/navigations.dart';
import 'package:bustrack/src/features/authentication/views/login/firebaseauth.dart';
import 'package:bustrack/src/features/authentication/views/login/formcontainer.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AddBus extends StatefulWidget {
  const AddBus({Key? key}) : super(key: key);

  @override
  State<AddBus> createState() => _AddBusState();
}

class _AddBusState extends State<AddBus> {
  bool _isSigning = false;

  final busName = TextEditingController();
  final busDescription = TextEditingController();
  final busPlateNum = TextEditingController();

  final busStatus = TextEditingController();
  final routeTimeStart = TextEditingController();
  final routeTimeEnd = TextEditingController();

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
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, style: BorderStyle.solid),
              image: const DecorationImage(
                image: AssetImage("assets/images/Rectangle.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 700,
              height: 700,
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
                      style:
                          TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    FormContainerWidget(
                      controller: busName,
                      hintText: "Name",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    FormContainerWidget(
                      controller: busDescription,
                      hintText: "Description",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    FormContainerWidget(
                      controller: busPlateNum,
                      hintText: "Plate Num",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    FormContainerWidget(
                      controller: busStatus,
                      hintText: "Status(active/inactive)",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    FormContainerWidget(
                      controller: routeTimeStart,
                      hintText: "Start Time",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    FormContainerWidget(
                      controller: routeTimeEnd,
                      hintText: "End Time",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        String name = busName.text;
                        String description = busDescription.text;
                        String plateNum = busPlateNum.text;
                        String status = busStatus.text;
                        String routeStart = routeTimeStart.text;
                        String routeEnd = routeTimeEnd.text;

                        BusModel bus = BusModel("", name, description, plateNum,
                            "", status, routeStart, routeEnd);

                        final CollectionReference Bus =
                            FirebaseFirestore.instance.collection('Bus');
                        await Bus.add(bus.toJson());
                        busName.clear();
                        busDescription.clear();
                        busPlateNum.clear();
                        busStatus.clear();
                        routeTimeStart.clear();
                        routeTimeEnd.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Bus information added successfully!'),
                          ),
                        );
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
                                      fontWeight: FontWeight.bold),
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
                                fontWeight: FontWeight.bold),
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
    );
  }
}

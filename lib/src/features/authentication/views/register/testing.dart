import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  DateTime now = DateTime.now();
  late DateTime localTime = now.add(const Duration(hours: 8));

  DateTime startS = DateTime.parse('2023-05-10 07:15:00');
  DateTime endS = DateTime.parse('2024-05-10 18:15:00');

  late var startTimeForm = DateFormat('kk:mm').format(startS);
  late var endTimeForm = DateFormat('kk:mm').format(endS);

  Duration duration = Duration(minutes: 30);

  late DateTime startSNew = startS;
  late DateTime startSOld = startSNew;

  printS() {
    while (startTimeForm != endTimeForm) {
      startSOld = startSNew;
      startSNew = startSNew.add(duration);

      late var oldTimeForm = DateFormat('kk:mm').format(startSOld);
      late var startTimeForm = DateFormat('kk:mm').format(startSNew);
      late var endTimeForm = DateFormat('kk:mm').format(endS);

      log(oldTimeForm);
      log(startTimeForm);

      if (startTimeForm == endTimeForm) {
        log("Time Matched");
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: 350,
            height: 350,
            child: Text(
              printS(),
            ),
          )
        ],
      ),
    );
  }
}

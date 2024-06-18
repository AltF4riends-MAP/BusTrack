import 'package:bustrack/src/features/authentication/controllers/readAllController.dart';
import 'package:bustrack/src/features/authentication/models/bus.dart';
import 'package:bustrack/src/features/authentication/models/route.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/src/features/authentication/controllers/navigations.dart';
import 'package:bustrack/src/features/authentication/views/login/firebaseauth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isLoggedIn;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? currentUser = null;
  List<Bus> _busList = [];
  List<Routes> _routeList = [];
  List<Stop> _stopList = [];
  String userBusDriver = "";
  Bus busDriver = new Bus("", "", "", "", "", "", "", 0, 0);

  @override
  void initState() {
    super.initState();
    fetchData();
    _isLoggedIn = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(124, 0, 0, 1),
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<FirebaseAuthService>().signOut();
              setState(() {
                _isLoggedIn = false;
              });
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black, style: BorderStyle.solid),
                left: BorderSide(color: Colors.black, style: BorderStyle.solid),
                right:
                    BorderSide(color: Colors.black, style: BorderStyle.solid),
                bottom:
                    BorderSide(color: Colors.black, style: BorderStyle.solid),
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/background_mp.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 320,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  left: BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 4,
                  ),
                  top: BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 4,
                  ),
                  right: BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 4,
                  ),
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 4,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImageButton(
                          "assets/images/homepage/TimetableIcon.png",
                          "Timetable",
                          onTap: () async {
                            if (currentUser != null) {
                              DocumentSnapshot userDoc = await _firestore
                                  .collection('User')
                                  .doc(currentUser!.uid)
                                  .get();

                              if (userDoc.exists) {
                                String role = userDoc['role'];
                                // Navigate based on role
                                if (role == 'Admin') {
                                  Navigator.pushNamed(
                                      context, viewTimetableRoute);
                                } else if (role == 'user') {
                                  Navigator.pushNamed(
                                      context, viewTimetableRouteuser);
                                  print("done");
                                }
                              }
                            }
                            ;
                          },
                        ),
                        _buildImageButton(
                          "assets/images/homepage/RoutesIcon.png",
                          "Routes",
                          onTap: () {
                            Navigator.pushNamed(context, viewRoutesPage);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    _buildImageButton(
                      "assets/images/homepage/LocationIcon.png",
                      "Location",
                      onTap: () {
                        // Navigate to location page
                      },
                    ),
                    const SizedBox(height: 20.0),
                    _buildImageButton(
                      "assets/images/homepage/BusIcon.png",
                      "Location",
                      onTap: () {
                        Navigator.pushNamed(context, viewBusDriver,
                            arguments: busDriver);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: _isLoggedIn ? 'Logout' : 'Logged Out',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to home page
              break;
            case 1:
              Navigator.pushNamed(context, manageProfileRoute);
              break;
            case 2:
              if (_isLoggedIn) {
                // Logout logic
              } else {
                Navigator.pushNamed(context, loginRoute);
              }
              break;
          }
        },
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
    final dBase = FirebaseFirestore.instance;
    final newUserRef = dBase.collection("User").doc(user?.uid);
    final doc = await newUserRef.get();
    if (doc.exists) {
      if (doc.data()?['busDriver'] != null) {
        userBusDriver = doc.data()?['busDriver'];
      }
    }

    for (Bus bus in _busList) {
      if (bus.id == userBusDriver) {
        busDriver = bus;
        print(
            "BRUHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
        print(busDriver.busName);
      }

      print(
          "YOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
    }

    // Check if the user is not null
    if (user != null) {
      currentUser = user;
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildImageButton(String imagePath, String label,
      {required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Text(label),
        ],
      ),
    );
  }
}

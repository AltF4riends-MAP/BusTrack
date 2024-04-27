import 'package:bustrack/src/features/authentication/views/login/firebaseauth.dart';
import 'package:bustrack/src/features/authentication/views/login/formcontainer.dart';
import 'package:bustrack/src/features/authentication/views/register/register_form_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Add a variable to track sign-in state
  bool _isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Home Page",
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        backgroundColor: Color.fromRGBO(124, 0, 0, 1),
        actions: [
          // Add the logout button here
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              if (_isLoggedIn) {
                await context.read<FirebaseAuthService>().signOut();
                setState(() {
                  _isLoggedIn = false;
                });
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            border: Border.all(
                color: Color.fromRGBO(0, 0, 0, 1), style: BorderStyle.solid),
            image: new DecorationImage(
              image: new AssetImage("assets/images/Rectangle.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
            child: Container(
          width: 500, // Set the width to 200 pixels
          height: 500, // Set the height to 200 pixels
          decoration: BoxDecoration(
            color: Colors.white, // Set background to transparent
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageButton(
                        "assets/images/homepage/TimetableIcon.png",
                        "Timetable"),
                    _buildImageButton(
                        "assets/images/homepage/RoutesIcon.png", "Routes"),
                  ],
                ),
                const SizedBox(height: 20.0),
                _buildImageButton("assets/images/LocationIcon.png", "Location"),
              ],
            ),
          ),
        )),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                setState(() {});
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Icon(Icons.person),
            ),
            label: _isLoggedIn ? 'Logout' : 'Logged Out',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                setState(() {
                  _isLoggedIn = false;
                });
                /*Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageProfile()),
                      (route) => false,
                    );
                    */
              },
              child: Icon(Icons.logout),
            ),
            label: _isLoggedIn ? 'Logout' : 'Logged Out',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildImageButton(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        // Handle button press here (e.g., print a message)
        print("Button '$label' pressed!");
      },
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

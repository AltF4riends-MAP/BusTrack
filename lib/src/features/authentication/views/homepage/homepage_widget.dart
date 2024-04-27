import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          "Home Page",
        ),
        backgroundColor: Color.fromRGBO(124, 0, 0, 1),
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
            color: Colors.transparent, // Set background to transparent
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
                _buildImageButton(
                    "assets/images/homepage/LocationIcon.png", "Location"),
              ],
            ),
          ),
        )),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildImageButton(String imagePath, String label) {
    return Column(
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
    );
  }
}

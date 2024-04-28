import 'package:bustrack/src/features/authentication/views/homepage/homepage_widget.dart';
import 'package:bustrack/src/features/authentication/views/login/formcontainer.dart';
import 'package:bustrack/src/features/authentication/views/login/login_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

class ManageProfile extends StatefulWidget {
  const ManageProfile({super.key});

  @override
  State<ManageProfile> createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  @override
  void initState() {
    super.initState();
    // Call your function here
    readProfile(_emailController, _passwordController, _idNumController,
        _icNumController, _fNameController, _lNameController);
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _idNumController = TextEditingController();
  TextEditingController _icNumController = TextEditingController();
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _lNameController = TextEditingController();
  bool _isEdit = false;
  bool _isLoggedIn = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _idNumController.dispose();
    _icNumController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          "Manage Profile",
        ),
        backgroundColor: Color.fromRGBO(104, 1, 1, 1),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(children: <Widget>[
          Container(
            width: 820, // Set the width to 200 pixels
            height: 1100,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/background_mp.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Container(
                width: 320, // Set the width to 200 pixels
                height: 600, // Set the height to 200 pixels

                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
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
              ),
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Manage Profile",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _idNumController,
                hintText: "Matric No/Staff ID",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _icNumController,
                hintText: "IC Number/Passport Number",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _fNameController,
                hintText: "First Name",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _lNameController,
                hintText: "Last Name",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  updateProfile(
                      _emailController,
                      _passwordController,
                      _idNumController,
                      _icNumController,
                      _fNameController,
                      _lNameController);
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isEdit
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Save Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ]),
          ))
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                setState(() {
                  _isLoggedIn = false;
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                setState(() {});
                Navigator.pushReplacementNamed(context, '/home');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageProfile()),
                  (route) => false,
                );
              },
              child: Icon(Icons.person),
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                setState(() {
                  _isLoggedIn = false;
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
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

  Future<void> readProfile(
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController idNumController,
      TextEditingController icNumController,
      TextEditingController fNameController,
      TextEditingController lNameController) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final current_user = user?.uid;
    final uid = user?.uid;
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('User')
        .doc(current_user)
        .get();

    if (documentSnapshot.exists) {
      print("Current User:" + current_user!);

      final userData = documentSnapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        emailController.text = userData['email'] ?? '';
        passwordController.text = userData['password'] ?? '';
        idNumController.text = userData['idNum'] ?? '';
        icNumController.text = userData['icNum'] ?? '';
        fNameController.text = userData['fName'] ?? '';
        lNameController.text = userData['lName'] ?? '';
      } else {
        print('User data is null');
      }
    }
    ;
  }

  Future<void> updateProfile(
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController idNumController,
      TextEditingController icNumController,
      TextEditingController fNameController,
      TextEditingController lNameController) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final current_user = user?.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    await users.doc(current_user).update({
      'email': emailController.text,
      'password': passwordController.text,
      'idNum': idNumController.text,
      'icNum': icNumController.text,
      'fName': fNameController.text,
      'lName': lNameController.text,
    });
  }
}

import 'package:bustrack/src/features/authentication/views/homepage/homepage_widget.dart';
import 'package:bustrack/src/features/authentication/views/login/login_widget.dart';
import 'package:bustrack/src/features/authentication/views/login/splashscreen_widget.dart';
import 'package:bustrack/src/features/authentication/views/manageprofile/manage_profile.dart';
import 'package:bustrack/src/features/authentication/views/register/register_form_widget.dart';
import 'package:bustrack/src/features/authentication/views/timetable/view_timetable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCsHDQtI9DItQgSqwy45_y2xG9tDGxuER8",
        appId: "1:540215271818:web:8b22d4aee01acdce862873",
        messagingSenderId: "540215271818",
        projectId: "flutter-firebase-9c136",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => const SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/manageProfile': (context) => const ManageProfile(),
        '/viewTimetable': (context) => const ViewTimetable(),
      },
    );
  }
}

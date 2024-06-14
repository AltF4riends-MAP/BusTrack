import 'package:bustrack/src/features/authentication/controllers/navigations.dart';
import 'package:bustrack/src/features/authentication/views/busdriver/busDriverPage.dart';
import 'package:bustrack/src/features/authentication/views/forgotpassword/forgetPassword.dart';
import 'package:bustrack/src/features/authentication/views/homepage/homepage_widget.dart';
import 'package:bustrack/src/features/authentication/views/login/login_widget.dart';
import 'package:bustrack/src/features/authentication/views/login/splashscreen_widget.dart';
import 'package:bustrack/src/features/authentication/views/manageprofile/manage_profile.dart';
import 'package:bustrack/src/features/authentication/views/register/register_form_widget.dart';
import 'package:bustrack/src/features/authentication/views/timetable/add_timetable.dart';
import 'package:bustrack/src/features/authentication/views/timetable/manage_timetable.dart';
import 'package:bustrack/src/features/authentication/views/timetable/view_timetable.dart';

import 'package:bustrack/src/features/authentication/views/Routes/viewroutes.dart';
import 'package:flutter/material.dart';

Route<dynamic>? createRoute(settings) {
  switch (settings.name) {
    case homeRoute:
      return MaterialPageRoute(
        builder: (context) => HomePage(),
      );
    case loginRoute:
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
      );

    case signUpRoute:
      return MaterialPageRoute(
        builder: (context) => RegisterPage(),
      );

    case manageProfileRoute:
      return MaterialPageRoute(
        builder: (context) => ManageProfile(),
      );

    case viewTimetableRoute:
      return MaterialPageRoute(
        builder: (context) => ViewTimetable(),
      );
    case viewRoutesPage:
      return MaterialPageRoute(
        builder: (context) => RoutePage(),
      );

    case forgotRoute:
      return MaterialPageRoute(
        builder: (context) => (ForgetPassword()),
      );

    case splashScreenRoute:
      return MaterialPageRoute(
        builder: (context) => (SplashScreen()),
      );

    case addTimetableRoute:
      return MaterialPageRoute(
        builder: (context) => (AddBus()),
      );

    case manageTimetableRoute:
      return MaterialPageRoute(
        builder: (context) => (ManageBus(settings.arguments)),
      );
    // case viewTableDetailRoute:
    // return MaterialPageRoute(
    //   builder: (context) => (ViewTableDetail(text: '',)), //
    // );

    case viewBusDriver:
      return MaterialPageRoute(
        builder: (context) => (BusDriverPage()),
      );
  }
  return null;
}

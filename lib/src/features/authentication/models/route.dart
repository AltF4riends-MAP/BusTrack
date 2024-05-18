import 'package:bustrack/src/features/authentication/models/stop.dart';

class Routes {
  String id;
  String routeName;
  String routeStatus;
  List<String> routeStops;
  String routeTimeStart;
  String routeTimeEnd;

  List<Stop> stop = [];

  Routes(this.id, this.routeName, this.routeStatus, this.routeStops,
      this.routeTimeStart, this.routeTimeEnd);

  void setStop(List<Stop> stopList) {
    for (String routes in routeStops) {
      for (Stop stops in stopList) {
        if (stops.id == routes) {
          stop.add(stops);
          print(stops.stopName);
        }
      }
    }
  }
}

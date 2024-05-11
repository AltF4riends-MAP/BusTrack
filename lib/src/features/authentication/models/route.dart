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
      this.routeTimeEnd, this.routeTimeStart);

  void setStop(List<Stop> stopList) {
    for (Stop stops in stopList) {
      for (String routes in routeStops) {
        if (stops.id == routes) {
          stop.add(stops);
          print(stops.stopName);
        }
      }
    }
  }
}

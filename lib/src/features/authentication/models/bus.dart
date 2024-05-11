import 'package:bustrack/src/features/authentication/models/route.dart';

class Bus {
  String id;
  String busName;
  String busDescription;
  String busPlateNum;
  String busRoute;
  String busStatus;
  Routes route = new Routes("", "", "", [], "", "");
  Bus(this.id, this.busName, this.busDescription, this.busPlateNum,
      this.busRoute, this.busStatus);

  void setRoute(List<Routes> routeList) {
    for (Routes routes in routeList) {
      if (routes.id == busRoute) {
        this.route = routes;
      }
    }
  }
}

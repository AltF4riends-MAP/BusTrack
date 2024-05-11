import 'package:bustrack/src/features/authentication/models/route.dart';

class BusModel {
  String id;
  String busName;
  String busDescription;
  String busPlateNum;
  String busRoute;
  String busStatus;
  String routeTimeStart;
  String routeTimeEnd;
  Routes route = new Routes(
    "",
    "",
    "",
    [],
    "",
    "",
  );
  BusModel(this.id, this.busName, this.busDescription, this.busPlateNum,
      this.busRoute, this.busStatus, this.routeTimeEnd, this.routeTimeStart);

  toJson() {
    return {
      "BusName": busName,
      "BusDescription": busDescription,
      "BusPlateNum": busPlateNum,
      "BusStatus": busStatus,
      "RouteTimeStart": routeTimeStart,
      "RouteTimeEnd": routeTimeEnd,
    };
  }

  void setRoute(List<Routes> routeList) {
    for (Routes routes in routeList) {
      if (routes.id == busRoute) {
        this.route = routes;
      }
    }
  }
}

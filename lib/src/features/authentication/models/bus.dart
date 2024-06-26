import 'package:bustrack/src/features/authentication/models/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bus {
  String id;
  String busName;
  String busDescription;
  String busPlateNum;
  String busRoute;
  String busStatus;
  String busDriveStatus;
  double posX;
  double posY;

  Routes route = new Routes("", "", "", [], "", "");
  Bus(this.id, this.busName, this.busDescription, this.busPlateNum,
      this.busRoute, this.busStatus, this.busDriveStatus, this.posX, this.posY);
  factory Bus.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final id = doc.id;
    final busName = data['busName'] ?? '';
    final busRoute = data['busRoute'] ?? '';
    final busDriveStatus = data['busDriveStatus'] ?? '';
    final posX = data['posX'] ?? 0.0;
    final posY = data['posY'] ?? 0.0;

    return Bus(id, busName, '', '', busRoute, '', busDriveStatus, posX, posY);
  }
  void setRoute(List<Routes> routeList) {
    for (Routes routes in routeList) {
      if (routes.id == busRoute) {
        this.route = routes;
      }
    }
  }
}

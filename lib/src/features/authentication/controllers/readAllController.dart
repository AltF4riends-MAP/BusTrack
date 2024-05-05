import "package:bustrack/src/features/authentication/models/bus.dart";
import "package:bustrack/src/features/authentication/models/route.dart";
import "package:bustrack/src/features/authentication/models/stop.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class ReadAllController {
  List<Bus> busList = [];
  List<Routes> routeList = [];
  List<Stop> stopList = [];

  Future<List<Bus>> getAllBus() async {
    final CollectionReference busCollection =
        FirebaseFirestore.instance.collection('Bus');

    try {
      QuerySnapshot querySnapshot = await busCollection.get();

      // Iterate through each document snapshot
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Map each document to a Bus object
        Bus bus = new Bus(
          doc.id,
          data['busName'] ?? '',
          data['busDescription'] ?? '',
          data['busPlateNum'] ?? '',
          data['busRoute'] ?? '',
          data['busStatus'] ?? '',
        );
        busList.add(bus); // Add the Bus object to the list
        print(bus.busName);
      });
    } catch (e) {
      // Handle error
      print('Error fetching buses: $e');
    }
    return busList;
  }

  Future<List<Routes>> getAllRoute() async {
    final CollectionReference routeCollection =
        FirebaseFirestore.instance.collection('Route');

    try {
      QuerySnapshot querySnapshot = await routeCollection.get();

      // Iterate through each document snapshot
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        List<String> routeStops = List<String>.from(data['routeStops'] ?? []);

        // Map each document to a Bus object
        Routes route = new Routes(
          doc.id,
          data['routeName'] ?? '',
          data['routeStatus'] ?? '',
          routeStops,
          data['routeTimeStart'] ?? '',
          data['routeTimeEnd'] ?? '',
        );
        routeList.add(route); // Add the Bus object to the list
        print(route.routeName);
      });
    } catch (e) {
      // Handle error
      print('Error fetching routes: $e');
    }
    return routeList;
  }

  Future<List<Stop>> getAllStop() async {
    final CollectionReference stopCollection =
        FirebaseFirestore.instance.collection('Stop');

    try {
      QuerySnapshot querySnapshot = await stopCollection.get();

      // Iterate through each document snapshot
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Map each document to a Bus object
        Stop stop = new Stop(
          doc.id,
          data['stopName'] ?? '',
          data['posX'] ?? '',
          data['posY'] ?? '',
        );
        stopList.add(stop); // Add the Bus object to the list
        print(stop.stopName);
      });
    } catch (e) {
      // Handle error
      print('Error fetching stops: $e');
    }
    return stopList;
  }
}

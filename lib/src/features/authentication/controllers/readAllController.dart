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
          data['busDriveStatus'] ?? '',
          data['posX'] ?? 0,
          data['posY'] ?? 0,
        );
        busList.add(bus); // Add the Bus object to the list
        print(bus.busName);
        print(bus.posY);
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
    List<Routes> routeList = [];

    try {
      QuerySnapshot querySnapshot = await routeCollection.get();

      // Iterate through each document snapshot
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, String> routeStopsMap =
            Map<String, String>.from(data['routeStops'] ?? {});

        print('Original routeStopsMap: $routeStopsMap');

        // Create a list of map entries and sort them by key
        List<MapEntry<String, String>> sortedEntries =
            routeStopsMap.entries.toList()
              ..sort((a, b) {
                int x = int.parse(a.key);
                int y = int.parse(b.key);
                return x.compareTo(y);
              });

        print('Sorted entries: $sortedEntries');

        // Extract the sorted route stops
        List<String> routeStops =
            sortedEntries.map((entry) => entry.value).toList();

        print('Sorted routeStops: $routeStops');

        // Map each document to a Routes object
        if (routeStops.isNotEmpty) {
          Routes route = Routes(
            doc.id,
            data['routeName'] ?? '',
            data['routeStatus'] ?? '',
            routeStops,
            data['routeTimeStart'] ?? '',
            data['routeTimeEnd'] ?? '',
          );
          routeList.add(route); // Add the Routes object to the list
          print("Route added: ${route.routeStops}");
        }
      });
    } catch (e) {
      // Handle error
      print('Error fetching routes: $e');
    }

    return routeList;
  }

  Future<void> updateRouteStops(String routeId, List<String> stopIds) async {
    final CollectionReference routeCollection =
        FirebaseFirestore.instance.collection('routes');
    Map<String, String> stopsMap = {};

    // Convert the list of stopIds into a map with index as key
    for (int i = 0; i < stopIds.length; i++) {
      stopsMap[i.toString()] = stopIds[i];
    }

    // Update the route document with the new routeStops map
    await routeCollection.doc(routeId).update({'routeStops': stopsMap});
  }

  // Fetch routeStops and sort them based on the index

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

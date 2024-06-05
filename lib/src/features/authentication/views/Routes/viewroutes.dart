import 'package:bustrack/src/features/authentication/models/stop.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'directions_model.dart';
import 'directions_repositroy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(RoutePage());
}

class RoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.5754316068552179, 103.61788395334298),
    zoom: 17.0,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;
  Stop? selectedOriginStop;
  Stop? selectedDestinationStop;

  late DirectionsRepository _directionsRepository;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _directionsRepository = DirectionsRepository(dio: Dio());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Routes'),
        backgroundColor: const Color.fromRGBO(124, 0, 0, 1),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _googleMapController = controller,
              markers: {
                if (_origin != null) _origin!,
                if (_destination != null) _destination!,
              },
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.green,
                    width: 5,
                    points: _info!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background_mp.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 350,
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Stop')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            var stops = snapshot.data!.docs
                                .map((doc) => Stop.fromFirestore(doc))
                                .toList();

                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: stops.length,
                              itemBuilder: (context, index) {
                                final stop = stops[index];
                                final isSelected = stop == selectedOriginStop ||
                                    stop == selectedDestinationStop;

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () => _setStop(stop),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _getStopColor(
                                            stop), // Use _getStopColor function here for background color
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.stop_circle_outlined),
                                              onPressed: () async {},
                                            ),
                                            Expanded(
                                              child: Text(
                                                stop.stopName,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected
                                                      ? Colors.green
                                                      : Colors
                                                          .black, // Keep text color consistent
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _setStop(Stop stop) async {
    await _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(stop.posX, stop.posY),
          zoom: 14.5,
          tilt: 50.0,
        ),
      ),
    );

    if (selectedOriginStop == null) {
      setState(() {
        selectedOriginStop = stop;
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: "You have selected "),
                  TextSpan(
                    text: stop.stopName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  const TextSpan(text: " as your origin"),
                ],
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(stop.posX, stop.posY),
        );
        _info = null;
        _destination = null;
        selectedDestinationStop = null;
      });
      print('Origin selected: ${stop.stopName}');
    } else if (selectedDestinationStop == null) {
      setState(() {
        selectedDestinationStop = stop;
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: "You have selected "),
                  TextSpan(
                    text: stop.stopName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  const TextSpan(text: " as your destination"),
                ],
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.blue,
          ),
        );
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: LatLng(stop.posX, stop.posY),
        );
      });

      final directions = await _directionsRepository.getDirections(
        origin: _origin!.position,
        destination: LatLng(stop.posX, stop.posY),
      );

      setState(() => _info = directions);

      if ((selectedOriginStop != null) && selectedDestinationStop != null) {
        print('Destination selected: ${stop.stopName}');

        // Query to find routes that include both selectedOriginStop and selectedDestinationStop
        print('Querying routes that include both stops...');
        final routeQuerySnapshot =
            await FirebaseFirestore.instance.collection('Route').get();

        List<String> routeIds = [];
        for (var routeDoc in routeQuerySnapshot.docs) {
          Map<String, dynamic> routeStops = routeDoc['routeStops'];
          List<String> stopIds = routeStops.values.cast<String>().toList();

          if (stopIds.contains(selectedOriginStop!.id) &&
              stopIds.contains(selectedDestinationStop!.id)) {
            routeIds.add(routeDoc.id);
          }
        }

        print('Routes passing through both stops: $routeIds');

        // Query to find buses that follow these routes
        if (routeIds.isNotEmpty) {
          print('Querying buses that follow the routes...');
          final busQuerySnapshot = await FirebaseFirestore.instance
              .collection('Bus')
              .where('busRoute', whereIn: routeIds)
              .get();

          List<String> busNames = [];
          for (var busDoc in busQuerySnapshot.docs) {
            busNames.add(busDoc['busName']);
          }

          print('Buses passing through the selected stops: $busNames');

          // Display bus names
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Buses passing through the selected stops'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var busName in busNames)
                        Row(
                          children: [
                            Icon(Icons.directions_bus_filled_rounded),
                            SizedBox(
                                width:
                                    10), // Add some spacing between icon and text
                            Text(
                              busName,
                              style:
                                  TextStyle(fontSize: 16), // Increase text size
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('No routes pass through both selected stops.'),
              duration: const Duration(seconds: 2),
            ),
          );
          print('No routes pass through both selected stops.');
        }
      }
    } else {
      setState(() {
        selectedOriginStop = stop;
        selectedDestinationStop = null;
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: "You have selected "),
                  TextSpan(
                    text: stop.stopName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  const TextSpan(text: " as your origin"),
                ],
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(stop.posX, stop.posY),
        );
        _destination = null;
        _info = null;
      });
      print('Origin re-selected: ${stop.stopName}');
    }
  }

  Color _getStopColor(Stop stop) {
    if (stop == selectedOriginStop) {
      return Colors.lightGreenAccent; // Highlight origin stop
    } else if (stop == selectedDestinationStop) {
      return Colors.lightBlueAccent; // Highlight destination stop
    } else {
      return Colors.white; // Default color
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:flutter_map/flutter_map.dart';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as goe;
import 'package:location/location.dart' as loc;
import 'package:map/addrss_screen.dart';
import 'package:map/feilde_name.dart';
import 'package:map/location_sevices.dart';

String currentaa = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.makePermission();
  await LocationService.makeService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

String currentLocation = "";

class MyHomePage extends StatefulWidget {
  final routpoints;
  MyHomePage({super.key, this.routpoints});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<String> allAdresses = [];
String? empty;

class _MyHomePageState extends State<MyHomePage> {
  final flutter_map.MapController mapController = flutter_map.MapController();
  double lattut = 1.2878;
  double longtut = 103.8666;
  loc.Location location = loc.Location();

  var tracking;
  Future<void> _getcLocation() async {
    var location = loc.Location();
    try {
      tracking = await location.getLocation();
      mapController.move(
        LatLng(tracking.latitude, tracking.longitude),
        15.0,
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getcLocation();
  }

  void _getLocation() async {
    try {
      var userLocation = await location.getLocation();
      if (userLocation.latitude != null && userLocation.longitude != null) {
        setState(() async {
          lattut = userLocation.latitude ?? 1.2878;
          longtut = userLocation.longitude ?? 103.8666;
          empty = await getLoctionName(lattut, longtut);
        });
      } else {
        debugPrint("All Data is Null");
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     _getLocation();
        //     setState(() async {
        //       // empty ??= await getLoctionName(lattut, longtut);
        //       currentLocation = await getLoctionName(lattut, longtut);
        //     });
        //   },
        // ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: const Text(
            "Map Screen",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              bottom: 0.0,
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                    onLongPress: (tapPosition, point) async {
                      try {
                        lattut = point.latitude;
                        longtut = point.longitude;
                        currentLocation = await getLoctionName(lattut, longtut);
                        allAdresses.add(currentLocation);
                        setState(() {});
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    onTap: (tapPosition, point) async {
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      setState(() async {
                        lattut = position.latitude;
                        longtut = position.longitude;
                      });
                    },
                    initialCenter: LatLng(lattut, longtut),
                    initialZoom: 7,
                    minZoom: 1.0,
                    maxZoom: 20,
                    interactionOptions:
                        const InteractionOptions(flags: InteractiveFlag.all)),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 60,
                        height: 60,
                        point: LatLng(lattut, longtut),
                        child: const Icon(
                          Icons.location_pin,
                          size: 60,
                          color: Colors.red,
                        ),
                      ),
                      Marker(
                        width: 60,
                        height: 60,
                        point: LatLng(lattut, longtut),
                        child: Text(currentLocation),
                      ),
                    ],
                  ),
                  widget.routpoints != null
                      ? PolylineLayer(
                          polylineCulling: false,
                          polylines: [
                            Polyline(
                                points: widget.routpoints,
                                color: Colors.blue,
                                strokeWidth: 9)
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: Column(
                  children: [
                    FloatingActionButton(
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.location_on,
                        size: 30,
                      ),
                      onPressed: () async {
                        _getLocation();
                        setState(() async {
                          // empty ??= await getLoctionName(lattut, longtut);
                          currentLocation =
                              await getLoctionName(lattut, longtut);
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton(
                      shape: const CircleBorder(),
                      child: const FittedBox(
                        child: Icon(
                          Icons.location_history,
                          size: 30,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddressesScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton(
                        shape: const CircleBorder(),
                        child: const FittedBox(
                          child: Icon(
                            Icons.search,
                            size: 30,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FeildsName(),
                          ));
                        }),
                  ],
                )),
          ],
        ));
  }
}

Future<String> getLoctionName(double latitude, double longitude) async {
  List<goe.Placemark> placemarks =
      await goe.placemarkFromCoordinates(latitude, longitude);

  goe.Placemark place1 = placemarks[0];
  goe.Placemark place2 = placemarks[1];
  // print("${place1}  ................... ${place2}");
  String currentAddress =
      "${place1.name} ${place1.street} ${place1.administrativeArea} ${place1.subAdministrativeArea} ";
  return currentAddress;
}

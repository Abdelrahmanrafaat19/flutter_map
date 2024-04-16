import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:map/main.dart';

import 'package:map/my_input.dart';
import 'package:http/http.dart' as http;

class FeildsName extends StatefulWidget {
  String start;
  String end;
  FeildsName({super.key, this.start = "", this.end = ""});

  @override
  State<FeildsName> createState() => _FeildsNameState();
}

class _FeildsNameState extends State<FeildsName> {
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  bool isVisible = false;
  List<LatLng> routpoints = [const LatLng(52.05884, -1.345583)];
  @override
  void initState() {
    start = TextEditingController(text: widget.start);
    end = TextEditingController(text: widget.end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text(
          "Routing",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                myInput(controler: start, hint: 'Enter Starting PostCode'),
                const SizedBox(
                  height: 15,
                ),
                myInput(controler: end, hint: 'Enter Ending PostCode'),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500]),
                    onPressed: () async {
                      List<Location> startl =
                          await locationFromAddress(start.text);
                      List<Location> endl = await locationFromAddress(end.text);

                      var v1 = startl[0].latitude;
                      var v2 = startl[0].longitude;
                      var v3 = endl[0].latitude;
                      var v4 = endl[0].longitude;

                      var url = Uri.parse(
                          'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
                      var response = await http.get(url);
                      debugPrint(response.body);
                      setState(() {
                        routpoints = [];
                        var ruter = jsonDecode(response.body)['routes'][0]
                            ['geometry']['coordinates'];
                        for (int i = 0; i < ruter.length; i++) {
                          var reep = ruter[i].toString();
                          reep = reep.replaceAll("[", "");
                          reep = reep.replaceAll("]", "");
                          var lat1 = reep.split(',');
                          var long1 = reep.split(",");
                          routpoints.add(LatLng(
                              double.parse(lat1[1]), double.parse(long1[0])));
                        }
                        isVisible = !isVisible;
                        debugPrint(routpoints.toString());
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(
                            routpoints: routpoints,
                          ),
                        ),
                      );
                    },
                    child: const Text('Press')),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

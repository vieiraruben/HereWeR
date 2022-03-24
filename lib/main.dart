import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:location/location.dart';
import 'package:mapview/firestoreData/firestoreConfig/firebase_options.dart';
import 'package:mapview/firestoreData/markers_data.dart';
import 'marker.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
         await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
         );
           } else {
             await Firebase.initializeApp();
             }

  await getMarkers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo!!!!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page!!!!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyMarkers markersToDisplay = MyMarkers(markers);
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;

  Future<void> _getUserLocation() async {
    Location location = Location();
    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    final _locationData = await location.getLocation();
    setState(() {
      _userLocation = _locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserLocation();
    getMarkers();
    return FlutterMap(
      options: MapOptions(
        center: LatLng.LatLng(51.506584, -0.171870),
        zoom: 16.7,
        allowPanning: true,
        nePanBoundary: LatLng.LatLng(51.511976, -0.155764),
        swPanBoundary: LatLng.LatLng(51.49, -0.187530),
        plugins: [
          LocationMarkerPlugin(), // <-- add plugin here
        ],
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
          attributionBuilder: (_) {
            return Text("HereWeR");
          },
        ),
        OverlayImageLayerOptions(overlayImages: [
          OverlayImage(
              bounds: LatLngBounds(LatLng.LatLng(51.50885, -0.1684),
                  LatLng.LatLng(51.50485, -0.175)),
              opacity: 1,
              imageProvider: const NetworkImage(
                  'https://i.pinimg.com/564x/16/98/40/169840717d863e92c4c0ffc3cacd4c55.jpg'))
        ]),
        CircleLayerOptions(circles: [
          CircleMarker(
              //radius marker
              point: LatLng.LatLng(51.50685, -0.171870),
              color: Colors.blue.withOpacity(0),
              borderStrokeWidth: 3.0,
              borderColor: Colors.blue,
              useRadiusInMeter: true,
              radius: 220 //radius
              )
        ]),
        markersToDisplay.displayMarkers(),
        LocationMarkerLayerOptions(
          positionStream:
              const LocationMarkerDataStreamFactory().geolocatorPositionStream(
            stream: geo.Geolocator.getPositionStream(
              locationSettings: const geo.LocationSettings(
                accuracy: geo.LocationAccuracy.high,
                distanceFilter: 5,
              ),
            ),
          ),
          marker: const DefaultLocationMarker(
            color: Colors.blue,
          ),
        )
      ],
    );
  }
}

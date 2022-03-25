import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:mapview/firestoreData/firestoreConfig/firebase_options.dart';
import 'package:mapview/firestoreData/markers_data.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import '../geolocation/user_location.dart';

void main() async {
  await getMarkers("toilettes");
  await getUserLocationPermission();
}

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);
  // final List<Marker> markers;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng.LatLng(51.506584, -0.171870),
          zoom: 16.7,
          allowPanning: true,
          nePanBoundary: LatLng.LatLng(51.511976, -0.155764),
          swPanBoundary: LatLng.LatLng(51.49, -0.187530),
          plugins: [
            const LocationMarkerPlugin(), // <-- add plugin here
          ],
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            attributionBuilder: (_) {
              return const Text("HereWeR");
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
          ),
    
          MarkerLayerOptions(
            markers: [
              ... markers
            ]
          ),
    
    
    
        ],
      ),
    );
  }
}
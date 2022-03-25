import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import '../firestoreData/markers_data.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

List<Marker> mapMarkers = [];

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
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
        children: <Widget>[
          TileLayerWidget(options: TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            attributionBuilder: (_) {
              return const Text("HereWeR");
            },
          )),
          OverlayImageLayerWidget(options: OverlayImageLayerOptions(overlayImages: [
            OverlayImage(
                bounds: LatLngBounds(LatLng.LatLng(51.50885, -0.1684),
                    LatLng.LatLng(51.50485, -0.175)),
                opacity: 1,
                imageProvider: const NetworkImage(
                    'https://i.pinimg.com/564x/16/98/40/169840717d863e92c4c0ffc3cacd4c55.jpg'))
            ]
          )),
          CircleLayerWidget(options: CircleLayerOptions(circles: [
            CircleMarker(
                //radius marker
                point: LatLng.LatLng(51.50685, -0.171870),
                color: Colors.blue.withOpacity(0),
                borderStrokeWidth: 3.0,
                borderColor: Colors.blue,
                useRadiusInMeter: true,
                radius: 220 //radius
                )
              ]
            )
          ),
          LocationMarkerLayerWidget(options: LocationMarkerLayerOptions(
            positionStream: const LocationMarkerDataStreamFactory()
                .geolocatorPositionStream(
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
          )),
          MarkerLayerWidget(
            options: MarkerLayerOptions(markers: [...mapMarkers]),
          )
        ],
      ),
    );
  }
}

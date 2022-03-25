import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' as LatLng;
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
          center: LatLng.LatLng(51.50654, -0.173030),
          zoom: 16.7,
          minZoom: 16.0,
          maxZoom: 17.8,
          allowPanning: true,
          nePanBoundary: LatLng.LatLng(51.520, -0.1713),
          swPanBoundary: LatLng.LatLng(51.503, -0.17457),
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
          CircleLayerWidget(options: CircleLayerOptions(circles: [
            CircleMarker(
              //radius marker

                point: LatLng.LatLng(51.50654, -0.173330),
                color: Color.fromARGB(255, 12, 130, 232),
                borderStrokeWidth: 3.0,
                borderColor: Colors.blue,
                useRadiusInMeter: true,
                radius: 600 //radius
            )
          ]
          )
          ),
          OverlayImageLayerWidget(options: OverlayImageLayerOptions(overlayImages: [
            OverlayImage(
                bounds: LatLngBounds(LatLng.LatLng(51.50885, -0.166),
                    LatLng.LatLng(51.504, -0.177)),
                opacity: 1,
                imageProvider:const NetworkImage("https://www.nicepng.com/png/full/471-4710932_love-box-festival-map.png"))
            ]
          )),

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

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mapview/firestoreData/markers_data.dart';

import '../models/marker.dart';


class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<Marker> restList = [];
  bool showRestaurants = false;
  List<Marker> croixRougeList = [];
  bool showCroixRouge = true;
  List<Marker> wcList= [];
  bool showWc = false;
  Map<String, List<Marker>> mapMarkers = {};
  List<Marker> activeMarkers = [];


  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = false;
  var isDialOpen = ValueNotifier<bool>(false);
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;




  @override
  void initState() {

    mapMarkers = {"restaurant" : restList, "wc" : wcList, "croix rouge" : croixRougeList};
    for (MyMarker marker in markers) {
      Marker mapMarker = Marker(point: marker.coor, builder: (ctx) => MyMarker(marker.type, marker.coor));
      mapMarkers[marker.type]?.add(mapMarker);
    }
    activeMarkers.addAll(croixRougeList);
    super.initState();
  }


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
            options: MarkerLayerOptions(
                markers: [
                  ... activeMarkers
                ]),
          )
        ],
      ),






    floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    floatingActionButton: SpeedDial(
      icon: Icons.search,
      activeIcon: Icons.loupe,
      spacing: 3,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      dialRoot: customDialRoot
          ? (ctx, open, toggleChildren) {
        return ElevatedButton(
          onPressed: toggleChildren,
          style: ElevatedButton.styleFrom(
            primary: Colors.blue[900],
            padding: const EdgeInsets.symmetric(
                horizontal: 22, vertical: 18),
          ),
          child: const Text(
            "Custom Dial Root",
            style: TextStyle(fontSize: 17),
          ),
        );
      } : null,
      buttonSize:
      buttonSize, // it's the SpeedDial size which defaults to 56 itself
      // iconTheme: IconThemeData(size: 22),
      label: extend
          ? const Text("Open")
          : null, // The label of the main button.
      /// The active label of the main button, Defaults to label if not specified.
      activeLabel: extend ? const Text("Close") : null,

      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the SpeedDial childrens size
      childrenButtonSize: childrenButtonSize,
      visible: visible,
      direction: SpeedDialDirection.down,
      switchLabelPosition: switchLabelPosition,

      /// If true user is forced to close dial manually
      closeManually: closeManually,

      /// If false, backgroundOverlay will not be rendered.
      renderOverlay: renderOverlay,
      overlayColor: Colors.black,
      overlayOpacity: 0.1,
      onOpen: () => debugPrint('OPENING DIAL'),
      onClose: () => debugPrint('DIAL CLOSED'),
      useRotationAnimation: useRAnimation,
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      activeForegroundColor: Colors.white,
      activeBackgroundColor: Colors.blue,
      elevation: 100.0,
      isOpenOnStart: false,
      animationSpeed: 75,
      shape: customDialRoot
          ? const RoundedRectangleBorder()
          : const StadiumBorder(),
      childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.restaurant_rounded),
          backgroundColor: !showRestaurants ? Colors.grey : Colors.blueAccent,
          foregroundColor: Colors.white,
          onTap: () => setState(() {
            List<Marker>? list = mapMarkers["restaurant"];
            if (showRestaurants == false){
              activeMarkers.addAll(list!);
              showRestaurants = true;
            }
            else {
              activeMarkers.removeWhere((element) => list!.contains(element));
              showRestaurants = false;
            }
          }),
        ),
        SpeedDialChild(
          child: const Icon(Icons.wc_rounded),
          backgroundColor: !showWc ? Colors.grey : Colors.green,
          foregroundColor: Colors.white,
          onTap: () => setState(() {
              List<Marker>? list = mapMarkers["wc"];
              if (showWc == false){
                activeMarkers.addAll(list!);
                showWc = true;
              }
              else {
                activeMarkers.removeWhere((element) => list!.contains(element));
                showWc = false;
              }
          }),
        ),
        SpeedDialChild(
          child: const Icon(Icons.health_and_safety_rounded),
          backgroundColor: !showCroixRouge ? Colors.grey : Colors.redAccent,
          foregroundColor: Colors.white,
          onTap: () => setState(() {
            List<Marker>? list = mapMarkers["croix rouge"];
            if (showCroixRouge == false){
              activeMarkers.addAll(list!);
              showCroixRouge = true;
            }
            else {
              activeMarkers.removeWhere((element) => list!.contains(element));
              showCroixRouge = false;
            }
          }),
        ),
      ],
    ),
    );
  }
}

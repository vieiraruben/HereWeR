import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../models/marker.dart';

List<Marker> mapMarkers = [];
class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var rmicons = true;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = false;
  var isDialOpen = ValueNotifier<bool>(false);
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FlutterMap(
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
          child: !rmicons ? const Icon(Icons.accessibility) : null,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          label: 'First',
          onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: !rmicons ? const Icon(Icons.brush) : null,
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          label: 'Second',
          onTap: () => setState(() {
            mapMarkers.add(Marker(point: LatLng.LatLng(51.50654, -0.173030), builder: (ctx) => MyMarker("restaurant", LatLng.LatLng(51.50654, -0.173030))));
          }),
        ),
        SpeedDialChild(
          child: !rmicons ? const Icon(Icons.margin) : null,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          label: 'Show Snackbar',
          visible: true,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(("Third Child Pressed")))),
          onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
        ),
      ],
    ),
    );
  }
}

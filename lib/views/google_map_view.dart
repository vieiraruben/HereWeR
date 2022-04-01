import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapview/geolocation/user_location_permission.dart';
import 'package:mapview/services/circle.dart';
import 'package:mapview/services/circle_service.dart';
import 'package:mapview/utilities/geo_to_latlng.dart';
import 'package:mapview/widgets/admin_widgets/marker_creation_form.dart';
import '../services/marker.dart';
import '../services/marker_service.dart';
import '../utilities/calculate_distance.dart';

late String markerType;
late String markerName;
late double radius;

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final FireStoreMarkerCloudStorage _markersService =
      FireStoreMarkerCloudStorage();
  final FireStoreCircleCloudStorage _circlesService =
      FireStoreCircleCloudStorage();
  late GoogleMapController _controller;

  late LocationData currentLocation;
  late Location location;

  Set<MarkerModel> tempMarkers = HashSet<MarkerModel>();
  Set<Polygon> polygons = HashSet<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  Set<Circle> circles = HashSet<Circle>();

  int tempPolygonIdCounter = 1;
  int tempCircleIdCounter = 1;
  int tempMarkerIdCounter = 1;

  bool isAdmin = true;
  bool isPolygon = false;
  bool isCircle = false;
  bool isMarker = false;
  bool isInteract = false;
  bool isUserCentered = false;
  bool isLocalScene = false;
  bool isLocalSceneActivated = false;
  late Circle? currentScene;

  static const CameraPosition startCam = CameraPosition(
    target: LatLng(51.5089, -0.1729),
    zoom: 17,
  );

  void _goToTheEvent() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(startCam));
  }

  chargeMarkers() {
    _markersService.markers.get().then((docs) async {
      if (docs.docs.isNotEmpty) {
        for (var doc in docs.docs) {
          MarkerModel marker = MarkerModel.fromSnapshot(doc);
          markersSet.add(await _markersService.initMarker(marker));
          setState(() {});
        }
      }
    });
  }

  chargeCircles() {
    _circlesService.circles.get().then((docs) async {
      if (docs.docs.isNotEmpty) {
        for (var doc in docs.docs) {
          CircleModel circle = CircleModel.fromSnapshot(doc);
          circlesSet.add(await _circlesService.initCircle(circle));
          setState(() {});
        }
      }
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    location = Location();
    _controller = _cntlr;
    _markersService.loadIconPaths();
    chargeCircles();
    chargeMarkers();

    location.onLocationChanged.listen((loc) async {
      if (isUserCentered) {
        print("test");
        _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(loc.latitude!, loc.longitude!),
              zoom: await _controller.getZoomLevel()),
        ));
      }

      for (Circle circle in circlesSet) {
        double distance = calculateDistance(loc.latitude!, loc.longitude!,
            circle.center.latitude, circle.center.longitude);
        if (distance <= circle.radius) {
          isLocalScene = true;
          radius = circle.radius;
          currentScene = circle;
          setState(() {});
        } else {
          isLocalScene = false;
          currentScene = null;
        }
      }

      if (isLocalScene & isLocalSceneActivated) {
        double zoomLvl = 16 + (1.5 * 100 / radius);
        _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(currentScene!.center.latitude,
                  currentScene!.center.longitude),
              zoom: zoomLvl),
        ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: startCam,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            circles: circlesSet,
            markers: markersSet,
            polygons: polygons,
            onTap: (point) {
              if (isPolygon) {
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              } else if (isMarker) {
                setState(() {
                  _setMarkers(point, markerType, markerName);
                });
              } else if (isCircle) {
                setState(() {
                  _setCircles(point);
                });
              }
            },
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    constraints: BoxConstraints.tight(const Size(36, 36)),
                    child: const Icon(Icons.travel_explore, size: 18),
                    shape: const CircleBorder(),
                    onPressed: () {
                      setState(() {
                        isUserCentered = false;
                        _goToTheEvent();
                      });
                    },
                    fillColor: Colors.tealAccent,
                    highlightColor: Colors.blue,
                  ),
                  RawMaterialButton(
                    constraints: BoxConstraints.tight(const Size(36, 36)),
                    child: const Icon(Icons.center_focus_strong, size: 18),
                    shape: const CircleBorder(),
                    onPressed: () {
                      setState(() {
                        isUserCentered = !isUserCentered;
                      });
                    },
                    fillColor: isUserCentered ? Colors.blue : Colors.grey,
                  ),
                  if (isLocalScene) getLocalToggle(),
                ],
              )),
          if (isAdmin) getAdminTools(),
        ],
      ),
    );
  }

  Widget getLocalToggle() {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(const Size(36, 36)),
      child: Icon(
          isLocalSceneActivated ? Icons.zoom_out_map : Icons.zoom_in_map,
          size: 18),
      shape: const CircleBorder(),
      onPressed: () {
        isLocalSceneActivated = !isLocalSceneActivated;
        if (!isLocalSceneActivated) {
          _goToTheEvent();
        }
        setState(() {});
      },
      fillColor: isLocalSceneActivated ? Colors.blue : Colors.grey,
    );
  }

  _setMarkers(LatLng point, String type, String name) async {
    final String markerId = "$tempMarkerIdCounter";
    tempMarkerIdCounter++;
    MarkerModel markerModel = MarkerModel(
        documentId: markerId,
        markerPosition: latLngToGeo(point),
        type: type,
        name: name);
    Marker marker = await _markersService.initMarker(markerModel);
    markersSet.add(marker);
    tempMarkers.add(markerModel);
    setState(() {});
  }

  void _setCircles(LatLng point) {
    final String circleId = "circle_$tempCircleIdCounter";
    tempCircleIdCounter++;
    setState(() {
      circles.add(
        Circle(
          circleId: CircleId(circleId),
          center: point,
          radius: radius,
          strokeColor: Colors.red,
          strokeWidth: 1,
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonId = "polygon_$tempPolygonIdCounter";
    tempPolygonIdCounter++;
    setState(() {
      polygons.add(
        Polygon(
          polygonId: PolygonId(polygonId),
          points: polygonLatLngs,
          fillColor: Colors.transparent,
          strokeWidth: 2,
          strokeColor: Colors.red,
        ),
      );
    });
  }

  Widget getAdminTools() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RawMaterialButton(
            constraints: BoxConstraints.tight(const Size(66, 36)),
            fillColor: isInteract ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                isPolygon = false;
                isCircle = false;
                isMarker = false;
                isInteract = true;
              });
            },
            child: const Text(
              'interact',
            ),
          ),
          RawMaterialButton(
            constraints: BoxConstraints.tight(const Size(66, 36)),
            fillColor: isPolygon ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                isPolygon = true;
                isCircle = false;
                isMarker = false;
                isInteract = false;
              });
            },
            child: const Text(
              'polygon',
            ),
          ),
          RawMaterialButton(
            constraints: BoxConstraints.tight(const Size(66, 36)),
            fillColor: isMarker ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                isPolygon = false;
                isCircle = false;
                isMarker = true;
                isInteract = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Define marker',
                            textAlign: TextAlign.center),
                        contentPadding: const EdgeInsets.all(8),
                        content: (const MarkersCreationForm()),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text("Validate"))
                        ],
                      ));
            },
            child: const Text(
              'marker',
            ),
          ),
          RawMaterialButton(
            constraints: BoxConstraints.tight(const Size(66, 36)),
            fillColor: isCircle ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                isPolygon = false;
                isCircle = true;
                isMarker = false;
                isInteract = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Choose radius'),
                        contentPadding: const EdgeInsets.all(8),
                        content: TextField(
                          decoration: const InputDecoration(
                              icon: Icon(Icons.zoom_out_map),
                              hintText: 'ex: 100',
                              suffixText: 'meters'),
                          keyboardType: const TextInputType.numberWithOptions(),
                          onChanged: (input) {
                            setState(() {
                              radius = double.parse(input);
                            });
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("ok"))
                        ],
                      ));
            },
            child: const Text(
              'circle',
            ),
          ),
          RawMaterialButton(
            padding: EdgeInsets.all(4.0),
            constraints: BoxConstraints.tight(const Size(66, 36)),
            fillColor: tempMarkers.isNotEmpty || circles.isNotEmpty
                ? Colors.blue
                : Colors.grey,
            onPressed: () {
              setState(() {
                for (MarkerModel marker in tempMarkers) {
                  _markersService.addMarker(marker: marker);
                }
                for (Circle circle in circles) {
                  double lat = circle.center.latitude;
                  double lng = circle.center.longitude;
                  GeoPoint centerGeo = GeoPoint(lat, lng);
                  CircleModel myCircle = CircleModel(
                      documentId: circle.circleId.toString(),
                      center: centerGeo,
                      radius: circle.radius);
                  _circlesService.addCircle(circle: myCircle);
                }
                tempMarkers.clear();
                circles.clear();
              });
            },
            child: const Text(
              'save',
            ),
          ),
        ],
      ),
    );
  }
}

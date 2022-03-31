
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapview/geolocation/user_location_permission.dart';
import 'package:mapview/services/circle.dart';
import 'package:mapview/services/circle_service.dart';
import 'package:mapview/utilities/geo_to_latlng.dart';
import '../constants/icon_imgs_paths.dart';
import '../services/marker.dart';
import '../services/marker_service.dart';
import '../utilities/calculate_distance.dart';


class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  Map <String, BitmapDescriptor> iconBms = {};

  final FireStoreMarkerCloudStorage _markersService = FireStoreMarkerCloudStorage();
  final FireStoreCircleCloudStorage _circlesService = FireStoreCircleCloudStorage();
  late  GoogleMapController _controller;

  late LocationData currentLocation;
  late Location location;
  late BitmapDescriptor sourceIcon;

  Set<Marker> markers = HashSet<Marker>();
  Set<Polygon> polygons = HashSet<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  Set<Circle> circles = HashSet<Circle>();
  late double radius;

  int tempPolygonIdCounter =1;
  int tempCircleIdCounter =1;
  int tempMarkerIdCounter =1;

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


  void _goToTheEvent()  {
    _controller.animateCamera(CameraUpdate.newCameraPosition(startCam));
  }

  _loadBmIcons() async {
    BitmapDescriptor iconBm;
    for (var img in iconImgs){
       var iconName = img.replaceAll("assets/images/icons8-", "");
       iconName = iconName.replaceAll("-500.png", "");
       iconBm = await BitmapDescriptor.fromAssetImage(
           const ImageConfiguration(devicePixelRatio: 3),
           img);
       iconBms[iconName] = iconBm;
     }
  }

  chargeMarkers() async{
    _markersService.markers.get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (var doc in docs.docs) {
          MarkerModel marker = MarkerModel.fromSnapshot(doc);
          markersSet.add(_markersService.initMarker(marker));
          setState(() {
          });
        }
      }
    });
  }



  void _onMapCreated(GoogleMapController _cntlr) async{

    location = Location();
    _controller = _cntlr;
    await _loadBmIcons();

    location.onLocationChanged.listen((loc) async {
      if(isUserCentered) {
        _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(loc.latitude!, loc.longitude!),
                  zoom: await _controller.getZoomLevel()),
            )
        );
      }

      for (Circle circle in circles){
        double distance = calculateDistance(loc.latitude!, loc.longitude!, circle.center.latitude, circle.center.longitude);
        if (distance <= circle.radius){
          isLocalScene = true;
          currentScene = circle;
          setState(() {
          });
        }
        else{
          isLocalScene = false;
          currentScene = null;
        }
      }

      if (isLocalScene & isLocalSceneActivated){
        double zoomLvl = 17 + (1 * 100/radius);
        _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(currentScene!.center.latitude, currentScene!.center.longitude),
                  zoom: zoomLvl),
            )
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    chargeMarkers();
    getUserLocationPermission();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.terrain,
            myLocationButtonEnabled: true,
            initialCameraPosition: startCam,
            onMapCreated: _onMapCreated,
            circles: circles,
            markers:  markersSet,
            polygons: polygons,
            onTap: (point){
              if (isPolygon){
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              }
              else if (isMarker){
                setState(() {
                  _setMarkers(point);
                });
              }
              else if (isCircle){
                setState(() {
                  _setCircles(point);
                });
              }
            },
          ),

          Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget> [
                  RawMaterialButton(
                    onPressed: (){
                      setState(() {
                        isUserCentered = !isUserCentered;
                      });
                    },
                    child: const Text(
                      'UserCentered',
                    ),
                    fillColor: isUserCentered ? Colors.blue: Colors.grey,
                  ),

                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        isUserCentered = false;
                        _goToTheEvent();
                      });
                    },
                    child: const Text(
                      'GoToEvent',
                    ),
                  ),

                 if (isLocalScene) getLocalToggle(),

                ],
              )
          ),
          if (isAdmin) getAdminTools(),
            ],
          ),

        );
  }

  Widget getLocalToggle() {
    return RawMaterialButton(
      onPressed: (){
        isLocalSceneActivated = !isLocalSceneActivated;
        if (!isLocalSceneActivated){
          _goToTheEvent();
        }
        setState(() {
        });
      },
      child: const Text(
        'localScene',
      ),
      fillColor: isLocalSceneActivated? Colors.blue: Colors.grey,
    );
  }

  _setMarkers(LatLng point) {
    final String markerId = "$tempMarkerIdCounter";
    tempMarkerIdCounter++;
    MarkerModel marker = MarkerModel(documentId: markerId, markerPosition: latLngToGeo(point));
    markersSet.add(_markersService.initMarker(marker));
    setState(() {

    });
  }

  void _setCircles(LatLng point){
    final String circleId = "circle_$tempCircleIdCounter";
    tempCircleIdCounter++;
    setState(() {
      circles.add(
        Circle(
          circleId: CircleId(circleId),
          center : point,
          radius: radius,
          strokeColor: Colors.red,
          strokeWidth: 1,
        ),
      );
    });
  }


  void _setPolygon(){
    final String polygonId = "polygon_$tempPolygonIdCounter";
    tempPolygonIdCounter++;
    setState(() {
      polygons.add(
        Polygon(
          polygonId: PolygonId(polygonId),
          points : polygonLatLngs,
          strokeWidth: 2,
          strokeColor: Colors.yellow,
        ),
      );
    });
  }


  Widget getAdminTools(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: <Widget>[
          RawMaterialButton(
            fillColor: isInteract ? Colors.blue : Colors.grey,
            onPressed: (){
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
            fillColor: isPolygon ? Colors.blue : Colors.grey,
            onPressed: (){setState(() {
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
            fillColor: isMarker ? Colors.blue : Colors.grey,
            onPressed: (){setState(() {
              isPolygon = false;
              isCircle = false;
              isMarker = true;
              isInteract = false;
            });
            },
            child: const Text(
              'marker',
            ),

          ),
          RawMaterialButton(
            fillColor: isCircle ? Colors.blue : Colors.grey,
            onPressed: (){setState(() {
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
                    decoration:  const InputDecoration(icon: Icon(Icons.zoom_out_map),
                        hintText: 'ex: 100', suffixText: 'meters'),
                    keyboardType: const TextInputType.numberWithOptions(),
                    onChanged: (input){
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
            fillColor: markers.isNotEmpty || circles.isNotEmpty ? Colors.blue : Colors.grey,
            onPressed: (){setState(() {
              for (Marker marker in markers){
                double lat = marker.position.latitude;
                double lng = marker.position.longitude;
                GeoPoint markerGeo = GeoPoint(lat, lng);
                //MarkerModel myMarker = MarkerModel(documentId: marker.markerId.toString(), markerPosition: markerGeo);
                //_markersService.addMarker(marker: myMarker);
              }
              for (Circle circle in circles){
                double lat = circle.center.latitude;
                double lng = circle.center.longitude;
                GeoPoint centerGeo = GeoPoint(lat, lng);
                CircleModel myCircle = CircleModel(documentId: circle.circleId.toString(), center: centerGeo, radius: circle.radius);
                _circlesService.addCircle(circle: myCircle);
              }
              markers.clear();
              circles.clear();
            });
            },
            child: const Text(
              'save markers',
            ),
          ),
        ],
      ),

    );
  }





}


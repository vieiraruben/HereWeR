import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapview/views/mapview.dart';
import '../models/marker.dart';
import 'package:latlong2/latlong.dart' as LatLng;




List <MyMarker> markers = [];
  getMarkers() async{
    markers = [];
    CollectionReference markersRef = await FirebaseFirestore.instance.collection('markers');
    QuerySnapshot querySnapshot = await markersRef.get();
    for (var doc in querySnapshot.docs) {
          String type = doc.get("type");

          GeoPoint geoPoint = doc.get("position");
          double lat = geoPoint.latitude;
          double lng = geoPoint.longitude;
          LatLng.LatLng coor = LatLng.LatLng(lat, lng);

          MyMarker marker = MyMarker(type, coor);

          markers.add(marker);
    }
  }



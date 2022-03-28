import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapview/views/mapview.dart';
import '../models/marker.dart';
import 'package:latlong2/latlong.dart' as LatLng;





  getMarkers(String whichType) async{
    mapMarkers = [];
    CollectionReference markersRef = await FirebaseFirestore.instance.collection('markers');
    QuerySnapshot querySnapshot = await markersRef.get();
    for (var doc in querySnapshot.docs) {
      //if (doc.get("type") == whichType) {
          String type = doc.get("type");
          GeoPoint geoPoint = doc.get("position");
          double lat = geoPoint.latitude;
          double lng = geoPoint.longitude;
          LatLng.LatLng latLng = LatLng.LatLng(lat, lng);

          MyMarker myMarker = MyMarker(type, latLng);
          Marker marker = Marker(
            point: myMarker.coor,
            builder: (ctx) => myMarker,
          );

          mapMarkers.add(marker);

      //}
    }
  }



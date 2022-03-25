import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapview/marker.dart';
import 'package:latlong2/latlong.dart' as LatLng;



FirebaseFirestore FS = FirebaseFirestore.instance;
CollectionReference markersRef = FS.collection('markers');

List<Marker> markers = [];

  getMarkers(String whichType)  {
    markers = [];
    markersRef.get().then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      if (doc.get("type") == whichType) {
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
          markers.add(marker);
      }
    }
  });
}


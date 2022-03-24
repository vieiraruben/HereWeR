import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapview/marker.dart';
import 'package:latlong2/latlong.dart' as LatLng;



FirebaseFirestore FS = FirebaseFirestore.instance;
CollectionReference markersRef = FS.collection('markers');

List<MyMarker> markers = [];

  getMarkers()  {
  markersRef.get().then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      String type = doc.get("type");
      GeoPoint geoPoint = doc.get("position");
      double lat = geoPoint.latitude;
      double lng = geoPoint.longitude;
      LatLng.LatLng latLng = LatLng.LatLng(lat, lng);

      MyMarker marker = MyMarker(type : type, coor: latLng);
      markers.add(marker);
    }
  });
}


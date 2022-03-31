
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapview/services/marker.dart';
import 'package:mapview/utilities/geo_to_latlng.dart';

Set<Marker> markersSet = {};
class FireStoreMarkerCloudStorage {
  final markers = FirebaseFirestore.instance.collection('markers');

  void addMarker({
    required MarkerModel marker,
  }) async {
    await markers.add({
      "position": marker.markerPosition,
      //"icon" : marker.icon;
    });
  }

  Marker initMarker(MarkerModel marker) {
    final MarkerId markerId = MarkerId(marker.documentId);
    LatLng markerLatLng = geoToLatLng(marker.markerPosition);
    final Marker googleMarker = Marker(
        markerId: markerId, position: markerLatLng,
    );
    return googleMarker;
  }



}

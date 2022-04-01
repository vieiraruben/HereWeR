import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapview/services/circle.dart';

import '../utilities/geo_to_latlng.dart';

Set<Circle> circlesSet = {};
class FireStoreCircleCloudStorage{
  final circles = FirebaseFirestore.instance.collection('circles');

  void addCircle({
    required CircleModel circle,
  }) async {
    await circles.add({
      "position": circle.center,
      "radius": circle.radius,
    });
  }

  Future<Circle> initCircle(CircleModel circle) async{
    final CircleId circleId = CircleId(circle.documentId);
    LatLng circleLatLng = geoToLatLng(circle.center);
    final Circle googleCircle = Circle(
        strokeWidth: 2,
        circleId: circleId, center: circleLatLng ,
        consumeTapEvents: true,
        radius: circle.radius,
    );
    return googleCircle;
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapview/services/circle.dart';

import '../utilities/geo_to_latlng.dart';

//Set des cercles à afficher
Set<Circle> circlesSet = {};

//class gérant les intéractions avec la firestore pour les Circles
class FireStoreCircleCloudStorage{
  final circles = FirebaseFirestore.instance.collection('circles');

  //Methode pour ajouté un Circle à firestore à partir d'un CircleModel
  void addCircle({
    required CircleModel circle,
  }) async {
    await circles.add({
      "position": circle.center,
      "radius": circle.radius,
    });
  }

  //Fonction qui créé un Circle google à partir d'un CircleModel
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
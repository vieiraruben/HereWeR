import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//Class qui définie toutes les informations necessaires à la création d'un Circle
@immutable
class CircleModel {
  final String documentId;
  final GeoPoint center;
  final double radius;

  const CircleModel({
    required this.documentId,
    required this.center,
    required this.radius
  });

//Methode permettant d'instancier un CircleModel à partir d'un document FireStore
  CircleModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        center = snapshot.data()["position"],
        radius = snapshot.data()["radius"];
}

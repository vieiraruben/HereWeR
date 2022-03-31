import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


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

  CircleModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        center = snapshot.data()["center"],
        radius = snapshot.data()["radius"];
}

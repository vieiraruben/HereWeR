import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapview/utilities/calculate_distance.dart';
import 'package:mapview/utilities/timeToGo.dart';

@immutable
class MarkerModel {

  final String documentId;
  final GeoPoint markerPosition;
  final String name;
  final String type;

  const MarkerModel({
    required this.type,
    required this.documentId,
    required this.name,
    required this.markerPosition,
  });

  MarkerModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        type = snapshot.data()["type"],
        markerPosition = snapshot.data()["position"],
        name = snapshot.data()["name"];
}





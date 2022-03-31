import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


@immutable
class MarkerModel {

  final String documentId;
  final GeoPoint markerPosition;
  //final String icon;

  const MarkerModel({
    required this.documentId,
    required this.markerPosition,
    //required this.icon
  });

  MarkerModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        //icon = snapshot.data()["icon"],
        markerPosition = snapshot.data()["position"];

}


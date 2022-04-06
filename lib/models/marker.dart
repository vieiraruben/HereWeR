
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Class qui définie toutes les informations necessaires à la création d'un Marker
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

  //Methode permettant d'instancier un MarkerModel à partir d'un document FireStore
  MarkerModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        type = snapshot.data()["type"],
        markerPosition = snapshot.data()["position"],
        name = snapshot.data()["name"];


  @override
  String toString() {
    // TODO: implement toString
    double lat = markerPosition.longitude;
    double lng = markerPosition.latitude;
    return "marker identified by $documentId named $name of type $type located at ($lat , $lng)";
  }
}






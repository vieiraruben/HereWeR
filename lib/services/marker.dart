import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:mapview/utilities/calculate_distance.dart';
import 'package:mapview/utilities/geo_to_latlng.dart';

@immutable
class MarkerModel {

  final String documentId;
  final GeoPoint markerPosition;
  final String type;

  const MarkerModel({
    required this.type,
    required this.documentId,
    required this.markerPosition,
    //required this.icon
  });

  MarkerModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        type = snapshot.data()["type"],
        markerPosition = snapshot.data()["position"];

}

 markerOnTapWidget(MarkerModel marker) async {

        Distance distance = const Distance();
        LocationData location = await Location().getLocation();
        GeoPoint markerLocation = marker.markerPosition;
        double m = calculateDistance(location.latitude,location.longitude, markerLocation.longitude, markerLocation.latitude);
        BotToast.showAttachedWidget(
            attachedBuilder: (_) => FractionallySizedBox(
              heightFactor: 0.2,
              widthFactor: 0.4,
              alignment: Alignment.center,

              child: Card(
                color: Colors.white54,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white54, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            duration: const Duration(seconds: 5),
            target: const Offset(200, 200));
      }



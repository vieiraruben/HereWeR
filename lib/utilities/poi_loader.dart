// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mapview/services/circle_service.dart';
// import 'package:mapview/services/marker.dart';
// import 'package:mapview/services/marker_service.dart';

// final FireStoreMarkerCloudStorage _markersService =
//       FireStoreMarkerCloudStorage();

// chargeMarkers(int filter) {
//     _markersService.markers.get().then((docs) async {
//       if (docs.docs.isNotEmpty) {
//         for (var doc in docs.docs) {
//           MarkerModel marker = MarkerModel.fromSnapshot(doc);
//           markersSet.add(await _markersService.initMarker(marker, 70));
//         }
//       }
//     });
// }

// chargeCircles(int filter) {
//   Color circleColor = Colors.blue;
//   double circleRadius = 15;

//   for (Marker i in markersSet) {
//           switch (
//             i.icon.toString()) {
//             case "beer-mug":
//             case "soda":
//             case "restaurant":
//               circleColor = Colors.yellow;
//               circleRadius = 30;
//               break;
//             case "dj":
//               circleColor = Colors.purple;
//               circleRadius = 45;
//               break;
//             case "rock-music":
//               circleColor = Colors.blue.shade900;
//               circleRadius = 50;
//               break;
//             case "stage":
//               circleColor = Colors.pink;
//               circleRadius = 60;
//               break;
//             case "international-music":
//               circleColor = Colors.deepOrange;
//               circleRadius = 50;
//               break;
//             case "country-music":
//               circleColor = Colors.brown;
//               circleRadius = 30;
//               break;
//             case "camping-tent":
//               circleColor = Colors.lightGreen;
//               circleRadius = 35;
//               break;
//             case "atm":
//             case "charging-battery":
//               circleColor = Colors.green;
//               circleRadius = 15;
//               break;
//             case "medical-bag":
//               circleColor = Colors.red;
//               circleRadius = 18;
//               break;
//             case "cocktail":
//               circleColor = Colors.orange;
//               circleRadius = 25;
//               break;
//             case "hamburger":
//             case "cola":
//               circleColor = Colors.brown;
//               circleRadius = 30;
//               break;
//             case "loudspeaker":
//               circleColor = Colors.teal.shade100;
//               circleRadius = 35;
//               break;
//             case "theme-park":
//               circleColor = Colors.pink.shade100;
//               circleRadius = 50;
//           }
//           circlesSet.add(Circle(
//               circleId: CircleId(i),
//               fillColor: circleColor.withOpacity(0.70),
//               radius: circleRadius,
//               center: LatLng(doc.data()["position"].latitude + 0.00007,
//                   (doc.data()["position"].longitude)),
//               strokeWidth: 0));
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapview/services/circle_service.dart';
import 'package:mapview/services/marker.dart';
import 'package:mapview/services/marker_service.dart';

class PoiLoader {
  
  chargeMarkers() {
    final FireStoreMarkerCloudStorage _markersService =
      FireStoreMarkerCloudStorage();

    _markersService.markers.get().then((docs) async {
      if (docs.docs.isNotEmpty) {
        for (var doc in docs.docs) {
          MarkerModel marker = MarkerModel.fromSnapshot(doc);
          markersSet.add(await _markersService.initMarker(marker, 70));
          loadInitialCircles(marker);
        }
      }
    });
  }

  loadInitialCircles(MarkerModel marker) {
    Color circleColor = Colors.blue;
    double circleRadius = 15;

    switch (marker.type) {
      case "beer-mug":
      case "soda":
      case "restaurant":
        circleColor = Colors.yellow;
        circleRadius = 30;
        break;
      case "dj":
        circleColor = Colors.purple;
        circleRadius = 45;
        break;
      case "rock-music":
        circleColor = Colors.blue.shade900;
        circleRadius = 50;
        break;
      case "stage":
        circleColor = Colors.pink;
        circleRadius = 60;
        break;
      case "international-music":
        circleColor = Colors.deepOrange;
        circleRadius = 50;
        break;
      case "country-music":
        circleColor = Colors.brown;
        circleRadius = 30;
        break;
      case "camping-tent":
        circleColor = Colors.lightGreen;
        circleRadius = 35;
        break;
      case "atm":
      case "charging-battery":
        circleColor = Colors.green;
        circleRadius = 15;
        break;
      case "medical-bag":
        circleColor = Colors.red;
        circleRadius = 18;
        break;
      case "cocktail":
        circleColor = Colors.orange;
        circleRadius = 25;
        break;
      case "hamburger":
      case "cola":
        circleColor = Colors.brown;
        circleRadius = 30;
        break;
      case "loudspeaker":
        circleColor = Colors.teal.shade100;
        circleRadius = 35;
        break;
      case "theme-park":
        circleColor = Colors.pink.shade100;
        circleRadius = 50;
    }
    circlesSet.add(Circle(
        circleId: CircleId(marker.type),
        fillColor: circleColor.withOpacity(0.70),
        radius: circleRadius,
        center: LatLng(marker.markerPosition.latitude + 0.00007,
            (marker.markerPosition.longitude)),
        strokeWidth: 0));
  }

  // loadFilteredCircles(int filter) {
  //   for 

  // }
}

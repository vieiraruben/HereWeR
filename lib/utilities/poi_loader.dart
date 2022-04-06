import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapview/models/marker.dart';

import '../services/circle_service.dart';

class PoiLoader {
  Set<Circle> unfiltered = {};
  Set<Circle> food = {};
  Set<Circle> stage = {};
  Set<Circle> camping = {};
  Set<Circle> necessities = {};
  Set<Circle> medical = {};
  Set<Circle> drinks = {};
  Set<Circle> fun = {};
  Set<Circle> toilets = {};

  

  loadInitialCircles(MarkerModel marker) {
    List<Set> sets = [
      unfiltered,
      food,
      stage,
      camping,
      necessities,
      medical,
      drinks,
      fun,
      toilets
    ];
    double circleRadius = 15;
    Color circleColor = Colors.blue;

    switch (marker.type) {
      case "beer-mug":
      case "soda":
        circleRadius = 30;
        circleColor = Colors.yellow;
        break;
      case "restaurant":
        circleRadius = 30;
        circleColor = Colors.yellow;
        break;
      case "dj":
        circleRadius = 45;
        circleColor = Colors.purple;
        break;
      case "rock-music":
        circleRadius = 50;
        circleColor = Colors.blue.shade900;
        break;
      case "stage":
        circleRadius = 60;
        circleColor = Colors.pink;
        break;
      case "international-music":
        circleRadius = 50;
        circleColor = Colors.deepOrange;
        break;
      case "country-music":
        circleRadius = 30;
        circleColor = Colors.brown;
        break;
      case "camping-tent":
        circleRadius = 35;
        circleColor = Colors.lightGreen;
        break;
      case "atm":
      case "charging-battery":
        circleRadius = 15;
        circleColor = Colors.green;
        break;
      case "medical-bag":
        circleRadius = 18;
        circleColor = Colors.red;
        break;
      case "cocktail":
        circleRadius = 25;
        circleColor = Colors.orange;
        break;
      case "hamburger":
      case "cola":
        circleRadius = 30;
        circleColor = Colors.brown;
        break;
      case "loudspeaker":
        circleRadius = 35;
        circleColor = Colors.teal.shade100;
        break;
      case "theme-park":
        circleRadius = 50;
        circleColor = Colors.pink.shade100;
        break;
      case "water":
      case "lake":
      case "grass":
      case "outdoor-swimming-pool":
      case "clothes":
      case "electronic-music":
      case "metal-music":
      case "pint":
      default:
        break;
    }

    Circle circle = Circle(
        circleId: CircleId(marker.documentId),
        fillColor: circleColor.withOpacity(0.70),
        radius: circleRadius,
        center: LatLng(marker.markerPosition.latitude + 0.00007,
            (marker.markerPosition.longitude)),
        strokeWidth: 0);

    unfiltered.add(circle);

    for (int i = 1; i < sets.length; i++) {
      Color circleColor = Colors.grey;
      if (i == 1 &&
          (marker.type == "restaurant" || marker.type == "hamburger")) {
        circleColor = Colors.yellow;
      } else if (i == 2) {
        switch (marker.type) {
          case "dj":
            circleColor = Colors.purple;
            break;
          case "rock-music":
            circleColor = Colors.blue.shade900;
            break;
          case "stage":
            circleColor = Colors.pink;
            break;
          case "international-music":
            circleColor = Colors.deepOrange;
            break;
          case "country-music":
            circleColor = Colors.brown;
            break;
        }
      } else if (i == 3 && marker.type == "camping-tent") {
        circleColor = Colors.lightGreen;
      } else if (i == 4) {
        switch (marker.type) {
          case "atm":
          case "charging-battery":
            circleColor = Colors.green;
        }
      } else if (i == 5 && marker.type == "medical") {
        circleColor = Colors.red;
      } else if (i == 6) {
        switch (marker.type) {
          case "beer-mug":
          case "pint":
          case "soda":
            circleColor = Colors.yellow;
            break;
          case "cocktail":
            circleColor = Colors.orange;
            break;
          case "cola":
            circleColor = Colors.brown;
        }
      } else if (i == 7 && marker.type == "theme-park") {
        circleColor = Colors.pink.shade300;
      } else if (i == 8 && marker.type == "toilet") {
        circleColor = Colors.blue;
      }
      sets[i].add(Circle(
          circleId: CircleId(marker.documentId),
          fillColor: circleColor.withOpacity(0.70),
          radius: circleRadius,
          center: LatLng(marker.markerPosition.latitude + 0.00007,
              (marker.markerPosition.longitude)),
          strokeWidth: 0));
    }
  }
}

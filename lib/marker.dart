import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:mapview/firestoreData/markers_data.dart';
import 'package:mapview/main.dart';
import 'package:mapview/views/mapview.dart';

class MyMarker extends StatefulWidget {
  String type;
  LatLng.LatLng coor;
  IconData icon = Icons.restaurant;
  MyMarker(this.type, this.coor) {
    switch (this.type) {
      case "restaurant":
        {
          icon = Icons.restaurant;
        }
        break;

      case "toilettes":
        {
          icon = Icons.wc;
        }
        break;

      case "croix rouge":
        {
          icon = Icons.health_and_safety;
        }
        break;

      default:
        {
          icon = Icons.warning_outlined;
        }
        break;
    }
  }
  @override
  State<MyMarker> createState() => _MyMarkerState();
}

class _MyMarkerState extends State<MyMarker> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () async {
        await getMarkers("croix rouge");
        setState(() {
          const MapView();
          // MapView(markers: markers);
        });
      },
      constraints: const BoxConstraints.expand(width: 40, height: 40),
      child: Icon(
        widget.icon,
        color: Colors.black,
        size: 25,
      ),
    );
  }
}

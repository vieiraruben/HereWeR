import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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

      case "wc":
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
      onPressed: () async{
        showTopSnackBar(
            context,
            const CustomSnackBar.info(
            message:
            "There is some information. You need to do something with that",
        ));
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

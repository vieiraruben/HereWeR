
import 'package:flutter/material.dart';





class MyMarker extends StatefulWidget {
  IconData icon;
  MyMarker({Key? key, required this.icon}) : super(key:key);

  @override
  State<MyMarker> createState() => _MyMarkerState();
}

class _MyMarkerState extends State<MyMarker> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 30,
        backgroundColor: const Color.fromRGBO(255,255,255,0),
        child :RawMaterialButton(
          onPressed: () {},
          constraints: const BoxConstraints.expand(width: 40, height: 40),
          child: Icon(
            widget.icon,
            color: Colors.black,
            size: 25,
          ),
        )
        );
  }
}
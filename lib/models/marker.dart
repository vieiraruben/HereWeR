/*
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';





class MyMarker extends StatefulWidget {
  final String type;
  final LatLng coor;
  IconData icon = Icons.restaurant;
  num radius;
  MyMarker(this.type, this.coor, { Key? key , this.radius = 0.0}) : super(key: key) {
    switch (type) {
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

      case "scene":
        {
          icon = Icons.music_note;
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
    if (widget.type != "scene"){
    return RawMaterialButton(
      constraints: const BoxConstraints.expand(width: 40, height: 40),
      child: Icon(
        widget.icon,
        color: Colors.black,
        size: 25,
      ),
      onPressed: () async {
        Distance distance = const Distance();
        Position currentPosition = await GeolocatorPlatform.instance.getCurrentPosition();
        LatLng currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
        double m = round(distance.as(LengthUnit.Meter, currentLatLng , widget.coor));
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[ Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:  [
                      Icon(widget.icon),
                      const Text("crowed")
                    ],
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        const Icon(Icons.add_road),
                        Text("$m meters")
                      ],
                    ),
                  ]
                ),
              ),
            ),
            duration: const Duration(seconds: 5),
            target: const Offset(200, 200));
      },
    );
  }
    else{
      return GestureDetector(
        
        onTap: () {
          print("Tapped a Container");
        },
        child: Card(
          borderOnForeground: true,
          color: Color.fromARGB(0, 0, 0, 0),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
}




  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
*/

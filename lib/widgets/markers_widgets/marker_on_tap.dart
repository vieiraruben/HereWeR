import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'restaurant.dart';

import '../../services/marker.dart';
import '../../utilities/calculate_distance.dart';
import '../../utilities/timeToGo.dart';

markerOnTapWidget(MarkerModel marker) async {

  LocationData location = await Location().getLocation();
  GeoPoint markerLocation = marker.markerPosition;
  double userDistance = calculateDistance(location.latitude,location.longitude, markerLocation.latitude, markerLocation.longitude) * 1000;
  String timeText = timeToGo(4, userDistance).toString() + " min away";
  BotToast.showAttachedWidget(
      attachedBuilder: (_) => FractionallySizedBox(
        heightFactor: marker.name.length > 10 ? 0.25 : 0.2,
        widthFactor: marker.name.length > 10 ? 0.5 : 0.4,

        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white54, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),

          child : Padding(padding :
          const EdgeInsets.all(8.0),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(marker.name,
                    style: const TextStyle(fontSize: 24)
                ),

                Text(timeText),
                ElevatedButton(
                  onPressed: (){
                    BotToast.cleanAll();
                    BotToast.showAttachedWidget(
                        attachedBuilder: (void Function() cancelFunc) {return const RestaurantWidget();},
                        duration: const Duration(minutes: 30),
                        target: const Offset(210, 50)
                    );
                  },
                  child: const Text("Learn more"),
                )
              ],
            ),
          ),
        ),
      ),
      duration: const Duration(seconds: 5),
      target: const Offset(210, 200));
}
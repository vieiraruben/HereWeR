import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'restaurant.dart';

import '../../services/marker.dart';
import '../../utilities/calculate_distance.dart';
import '../../utilities/timeToGo.dart';



//Widget qui apparait lorsque l'on tap un marker
markerOnTapWidget(MarkerModel marker) async {

  //Il renvoie le temps de parcours de l'utilisateur jusqu'au marker
  LocationData location = await Location().getLocation();
  GeoPoint markerLocation = marker.markerPosition;
  double userDistance = calculateDistance(location.latitude,location.longitude, markerLocation.latitude, markerLocation.longitude) * 1000;

  //On suppose une vitesse de 4km/h
  String timeText = timeToGo(4, userDistance).toString() + " min away";

  //un Toast d'une durée de 5 sec est affiché
  BotToast.showAttachedWidget(
      attachedBuilder: (_) => FractionallySizedBox(

        //La taille de la box dépend de la longueure du nom du marker
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
                //Affichage du nom du marker
                Text(marker.name,
                    style: const TextStyle(fontSize: 24)
                ),

                Text(timeText),
                //Le boutton renvoie un nouveau toast avec un contenu définie dans un autre fichier
                //pour l'instant celui ci est toujours le même mais il faudrait le faire varier en fonction du marker
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
      //emplacement du toast sur l'écran
      target: const Offset(210, 200));
}
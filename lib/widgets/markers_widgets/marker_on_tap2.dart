import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'demo_content_view.dart';

import '../../services/marker.dart';
import '../../utilities/calculate_distance.dart';
import '../../utilities/timeToGo.dart';

//Widget qui apparait lorsque l'on tap un marker
markerOnTapWidget(MarkerModel marker, Location location, BuildContext context) {
  //Il renvoie le temps de parcours de l'utilisateur jusqu'au marker

  List<String> typesWithContent = ["stage", "dj", "restaurant"];

  BotToast.showAttachedWidget(
      attachedBuilder: (_) => FractionallySizedBox(
            //La taille de la box dépend de la longueure du nom du marker
            heightFactor: (typesWithContent.contains(marker.type)) ? 0.5 : 0.2,
            widthFactor: 0.8,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 25,
              shadowColor: Colors.black.withOpacity(1),
              borderOnForeground: false,
              color: Theme.of(context).scaffoldBackgroundColor,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Affichage du nom du marker
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        Image.asset(
                            "assets/images/icons/icons8-" +
                                marker.type +
                                "-64.png",
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            height: 25),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(marker.name, textScaleFactor: 1.2)
                            ]),
                        FutureBuilder(
                            future: location.getLocation(),
                            builder: (context,
                                AsyncSnapshot<LocationData> location) {
                              if (location.hasData) {
                                GeoPoint markerLocation = marker.markerPosition;
                                double userDistance = calculateDistance(
                                        location.data!.latitude,
                                        location.data!.longitude,
                                        markerLocation.latitude,
                                        markerLocation.longitude) *
                                    1000;
                                return Text(
                                    timeToGo(4, userDistance).toString() +
                                        " min away");
                              } else {
                                return const Text("... min away");
                              }
                            })
                      ])),
                  //Le boutton renvoie un nouveau toast avec un contenu définie dans un autre fichier
                  //pour l'instant celui ci est toujours le même mais il faudrait le faire varier en fonction du marker
                  (typesWithContent.contains(marker.type)) ? Expanded(child: SingleChildScrollView(
         child: DemoContentView(marker: marker))) : const SizedBox() ,
                ],
              ),
            ),
          ),
      duration: const Duration(seconds: 30),
      //emplacement du toast sur l'écran
      target: const Offset(200, 50));
}

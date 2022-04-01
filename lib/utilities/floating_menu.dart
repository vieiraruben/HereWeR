import 'package:flutter/material.dart';
import 'package:mapview/constants/routes.dart';
import 'package:mapview/utilities/here_we_r_icons_icons.dart';


Widget getMenu(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 30, top: 60, right: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black.withOpacity(0.3)),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(HereWeRIcons.icons8_customer_64),
                          color: Colors.white,
                          iconSize: 35,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        IconButton(
                          onPressed: () {Navigator.of(context).pushNamed(chatRoute);},
                          icon: const Icon(HereWeRIcons.icons8_communication_64),
                          color: Colors.white,
                          iconSize: 35),
                        const SizedBox(
                          height: 5,
                        ),
                        IconButton(
                          onPressed: () {Navigator.of(context).pushNamed(searchRoute);},
                          icon: const Icon(HereWeRIcons.icons8_search_64),
                          color: Colors.white,
                          iconSize: 35),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ), 
                ), const SizedBox(height: 10),
                Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black.withOpacity(0.3)),
                  child: Padding(padding: const EdgeInsets.all(3.0),
                  child: Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(HereWeRIcons.icons8_filter_64),
                          color: Colors.white,
                          iconSize: 35,
                        ),
                        ])
                  )
                )],
            )
          ],
        ),
      ],
    ),
  );
}
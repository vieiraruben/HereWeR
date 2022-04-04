import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapview/constants/routes.dart';
import 'package:mapview/utilities/here_we_r_icons_icons.dart';

int action = 0;

Widget getMenu(BuildContext context, StreamController _controller) {
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
                          onPressed: () {
                            _controller.add(3);
                          },
                          icon: const Icon(HereWeRIcons.icons8_customer_64),
                          color: Colors.white,
                          iconSize: 35,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        IconButton(
                            onPressed: () {
                              _controller.add(2);
                            },
                            icon: const Icon(
                                HereWeRIcons.icons8_communication_64),
                            color: Colors.white,
                            iconSize: 35),
                        const SizedBox(
                          height: 5,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(searchRoute);
                            },
                            icon: const Icon(HereWeRIcons.icons8_search_64),
                            color: Colors.white,
                            iconSize: 35),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black.withOpacity(0.3)),
                    child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(children: [
                          PopupMenuButton(
                            elevation: 0,
                            color: Colors.black.withOpacity(0.3),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            itemBuilder: (context) => list,
                            onSelected: (v) {
                              _controller.add(v);
                            },
                            icon: const Icon(HereWeRIcons.icons8_filter_64,
                                color: Colors.white),
                            iconSize: 35,
                          ),
                        ]))),
                const SizedBox(height: 10),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black.withOpacity(0.3)),
                    child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(children: [
                          IconButton(
                            onPressed: () {
                              print(1);
                              _controller.add(1);
                            },
                            icon:
                                const Icon(HereWeRIcons.icons8_my_location_64),
                            color: Colors.white,
                            iconSize: 35,
                          ),
                        ])))
              ],
            )
          ],
        ),
      ],
    ),
  );
}

int getAction() {
  return action;
}

const textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

showPopupMenu(BuildContext context) {
  const textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  showMenu<String>(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    elevation: 0,
    color: Colors.black.withOpacity(0.3),
    context: context,
    position: const RelativeRect.fromLTRB(
        55, 100, 45, 0), //position where you want to show the menu on screen
    items: [
      const PopupMenuItem<String>(
          child: ListTile(
              leading: Icon(HereWeRIcons.icons8_stage_64,
                  color: Colors.white, size: 35),
              title: Text('Stages', style: textStyle)),
          value: '1'),
      const PopupMenuItem<String>(
          child: ListTile(
              leading: Icon(HereWeRIcons.icons8_toilet_64,
                  color: Colors.white, size: 35),
              title: Text('Restrooms', style: textStyle)),
          value: '2'),
      const PopupMenuItem<String>(
          child: ListTile(
              leading: Icon(HereWeRIcons.icons8_about_64,
                  color: Colors.white, size: 35),
              title: Text('Info', style: textStyle)),
          value: '2'),
      const PopupMenuItem<String>(
          child: ListTile(
              leading: Icon(HereWeRIcons.icons8_cocktail_64,
                  color: Colors.white, size: 35),
              title: Text('Bars', style: textStyle)),
          value: '3'),
      const PopupMenuItem<String>(
          child: ListTile(
              leading: Icon(HereWeRIcons.icons8_restaurant_64,
                  color: Colors.white, size: 35),
              title: Text('Food', style: textStyle)),
          value: '4'),
      const PopupMenuItem<String>(
          child: ListTile(
              leading: Icon(HereWeRIcons.icons8_clothes_64,
                  color: Colors.white, size: 35),
              title: Text('Merch Store', style: textStyle)),
          value: '2'),
      const PopupMenuItem<String>(
          child: ListTile(
              leading: Icon(HereWeRIcons.icons8_medical_bag_64,
                  color: Colors.white, size: 35),
              title: Text('Medical', style: textStyle)),
          value: '2'),
      const PopupMenuItem<String>(
          child: ListTile(
              leading: Icon(HereWeRIcons.icons8_atm_64,
                  color: Colors.white, size: 35),
              title: Text('ATM', style: textStyle)),
          value: '2'),
      const PopupMenuItem<String>(
          child: ListTile(
              leading: Icon(HereWeRIcons.icons8_camping_tent_64,
                  color: Colors.white, size: 35),
              title: Text('Camping', style: textStyle)),
          value: '2'),
    ],
  );
}

List<PopupMenuEntry> list = [
  const PopupMenuItem<int>(
    value: 5,
    child: ListTile(
      leading:
          Icon(HereWeRIcons.icons8_stage_64, color: Colors.white, size: 35),
      title: Text('Stages', style: textStyle),
    ),
  ),
  const PopupMenuItem<String>(
      child: ListTile(
          leading: Icon(HereWeRIcons.icons8_toilet_64,
              color: Colors.white, size: 35),
          title: Text('Restrooms', style: textStyle)),
      value: '2'),
  const PopupMenuItem<String>(
      child: ListTile(
          leading:
              Icon(HereWeRIcons.icons8_about_64, color: Colors.white, size: 35),
          title: Text('Info', style: textStyle)),
      value: '2')
];

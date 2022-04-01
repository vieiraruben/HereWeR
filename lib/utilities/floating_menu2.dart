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
                            onPressed: () {
                              Navigator.of(context).pushNamed(chatRoute);
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
                          IconButton(
                            onPressed: () {
                              showPopupMenu(context);
                            },
                            icon: const Icon(HereWeRIcons.icons8_filter_64),
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

showPopupMenu(BuildContext context) {

  const textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  showMenu<String>(
    
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    elevation: 0,
    color: Colors.black.withOpacity(0.3),
    context: context,
    position: RelativeRect.fromLTRB(
        55, 100, 45, 0), //position where you want to show the menu on screen
    items: [
      const PopupMenuItem<String>(child: ListTile(leading: Icon(HereWeRIcons.icons8_stage_64, color: Colors.white, size:35),
        title: Text('Stages', style: textStyle)), value: '1'),
      const PopupMenuItem<String>(child: ListTile(leading: Icon(HereWeRIcons.icons8_toilet_64, color: Colors.white, size:35),
        title: Text('Restrooms', style: textStyle)), value: '2'),
      const PopupMenuItem<String>(child: ListTile(leading: Icon(HereWeRIcons.icons8_comments_64, color: Colors.white, size:35),
        title: Text('Info', style: textStyle)), value: '2'),
      const PopupMenuItem<String>(child: ListTile(leading: Icon(HereWeRIcons.icons8_cocktail_64, color: Colors.white, size:35),
        title: Text('Bars', style: textStyle)), value: '3'),
      const PopupMenuItem<String>(child: ListTile(leading: Icon(HereWeRIcons.icons8_restaurant_64, color: Colors.white, size:35),
        title: Text('Food', style: textStyle)), value: '4'),
      const PopupMenuItem<String>(child: ListTile(leading: Icon(HereWeRIcons.icons8_clothes_64, color: Colors.white, size:35),
        title: Text('Merch Store', style: textStyle)), value: '2'),
      const PopupMenuItem<String>(child: ListTile(leading: Icon(HereWeRIcons.icons8_medical_bag_64, color: Colors.white, size:35),
        title: Text('Medical', style: textStyle)), value: '2'),
      const PopupMenuItem<String>(child: ListTile(leading: Icon(HereWeRIcons.icons8_electronic_music_64, color: Colors.white, size:35),
        title: Text('ATM', style: textStyle)), value: '2'),
      const PopupMenuItem<String>(child: ListTile(leading: Icon(HereWeRIcons.icons8_treatment_64, color: Colors.white, size:35),
        title: Text('Camping', style: textStyle)), value: '2'),
    ],
  );
}

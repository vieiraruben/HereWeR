import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapview/constants/routes.dart';
import 'package:mapview/utilities/here_we_r_icons_icons.dart';
import 'package:mapview/views/search_view.dart';

bool isFiltered = false;
CameraPosition? eventPositional;

enum MenuAction {
  userProfile,
  chat,
  search,
  didPopFromSearch,
  filter,
  cleanFilter,
  locate,
  food,
  stage,
  camping,
  necessities,
  medical,
  drinks,
  fun,
  toilets,
}

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
                            _controller.add(MenuAction.userProfile);
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
                              _controller.add(MenuAction.chat);
                            },
                            icon: const Icon(
                                HereWeRIcons.icons8_communication_64),
                            color: Colors.white,
                            iconSize: 35),
                        const SizedBox(
                          height: 5,
                        ),
                        IconButton(
                            onPressed: () async {
                              eventPositional = null;
                              eventPositional = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SearchView()),
                              );
                              _controller.add(MenuAction.didPopFromSearch);
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
                      child: (!isFiltered)
                          ? PopupMenuButton(
                              elevation: 0,
                              color: Colors.black.withOpacity(0.3),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              itemBuilder: (context) => list,
                              onSelected: (v) {
                                _controller.add(v);
                                isFiltered = true;
                              },
                              icon: const Icon(HereWeRIcons.icons8_filter_64,
                                  color: Colors.white),
                              iconSize: 35,
                            )
                          : IconButton(
                              onPressed: () {
                                _controller.add(MenuAction.cleanFilter);
                                isFiltered = false;
                              },
                              icon: const Icon(
                                  HereWeRIcons.icons8_clear_filters_64),
                              color: Colors.white,
                              iconSize: 35),
                    )),
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
                              _controller.add(MenuAction.locate);
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

const textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

List<PopupMenuEntry> list = [
  const PopupMenuItem<MenuAction>(
      child: ListTile(
          leading:
              Icon(HereWeRIcons.icons8_stage_64, color: Colors.white, size: 35),
          title: Text('Stages', style: textStyle)),
      value: MenuAction.stage),
  const PopupMenuItem<MenuAction>(
      child: ListTile(
          leading: Icon(HereWeRIcons.icons8_toilet_64,
              color: Colors.white, size: 35),
          title: Text('Restrooms', style: textStyle)),
      value: MenuAction.toilets),
  const PopupMenuItem<MenuAction>(
      child: ListTile(
          leading:
              Icon(HereWeRIcons.icons8_about_64, color: Colors.white, size: 35),
          title: Text('Info', style: textStyle)),
      value: MenuAction.medical),
  const PopupMenuItem<MenuAction>(
      child: ListTile(
          leading: Icon(HereWeRIcons.icons8_cocktail_64,
              color: Colors.white, size: 35),
          title: Text('Bars', style: textStyle)),
      value: MenuAction.drinks),
  const PopupMenuItem<MenuAction>(
      child: ListTile(
          leading: Icon(HereWeRIcons.icons8_restaurant_64,
              color: Colors.white, size: 35),
          title: Text('Food', style: textStyle)),
      value: MenuAction.food),
  const PopupMenuItem<MenuAction>(
      child: ListTile(
          leading: Icon(HereWeRIcons.icons8_clothes_64,
              color: Colors.white, size: 35),
          title: Text('Merch Store', style: textStyle)),
      value: MenuAction.necessities),
  const PopupMenuItem<MenuAction>(
      child: ListTile(
          leading: Icon(HereWeRIcons.icons8_medical_bag_64,
              color: Colors.white, size: 35),
          title: Text('Medical', style: textStyle)),
      value: MenuAction.medical),
  const PopupMenuItem<MenuAction>(
      child: ListTile(
          leading:
              Icon(HereWeRIcons.icons8_atm_64, color: Colors.white, size: 35),
          title: Text('ATM', style: textStyle)),
      value: MenuAction.necessities),
  const PopupMenuItem<MenuAction>(
      child: ListTile(
          leading: Icon(HereWeRIcons.icons8_camping_tent_64,
              color: Colors.white, size: 35),
          title: Text('Camping', style: textStyle)),
      value: MenuAction.camping),
];

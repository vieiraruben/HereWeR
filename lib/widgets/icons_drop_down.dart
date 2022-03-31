import 'package:flutter/material.dart';
import 'package:mapview/views/google_map_view.dart';

import '../services/marker_service.dart';

class IconsDropDown extends StatefulWidget {
  const IconsDropDown({Key? key}) : super(key: key);

  @override
  State<IconsDropDown> createState() => _IconsDropDownState();
}

class _IconsDropDownState extends State<IconsDropDown> {
  String dropdownType = 'add';

  @override
  Widget build(BuildContext context) {
    return
      DropdownButton<String>(
        value: dropdownType,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? newValue) async {
          setState(() {

          });
          dropdownType = newValue!;
          markerType = newValue;
        },
        items: iconPaths.keys
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
  }
}
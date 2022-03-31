import 'package:flutter/material.dart';
import 'package:mapview/views/google_map_view.dart';

import '../services/marker_service.dart';

class MarkersCreationForm extends StatefulWidget {
  const MarkersCreationForm({Key? key}) : super(key: key);

  @override
  State<MarkersCreationForm> createState() => _MarkersCreationFormState();
}

class _MarkersCreationFormState extends State<MarkersCreationForm> {
  String dropdownType = 'add';

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    return
      Column(
        children: [
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
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Full Name',
            ),
            onChanged: (text) {
              markerName = nameController.text;
            },
          )
        ],
      );
  }
}
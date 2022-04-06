import 'package:flutter/material.dart';



import '../../services/marker_service.dart';
import '../../views/google_map_view.dart';


//Formulaire à remplir pour créer un nouveau marker
class MarkersCreationForm extends StatefulWidget {
  const MarkersCreationForm({Key? key}) : super(key: key);

  @override
  State<MarkersCreationForm> createState() => _MarkersCreationFormState();
}


class _MarkersCreationFormState extends State<MarkersCreationForm> {
  String dropdownType = 'add';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markerType = selectedMarker.type;
    markerName = selectedMarker.name;
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: selectedMarker.name);
    return
      FractionallySizedBox(
        heightFactor: 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              //DropDownButton qui contient la liste de tout les icones disponibles
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Type'),
                value: dropdownType = selectedMarker.type,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
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

              //Textfield pour choisir le nom du marker
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Marker name',
                ),
                onChanged: (text) {
                  markerName = nameController.text;
                },
              )
            ],
          ),
      );
  }
}
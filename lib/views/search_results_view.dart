import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapview/services/firebase_database.dart';

class SearchResultsView extends StatefulWidget {
  const SearchResultsView({Key? key, required this.searchTerm})
      : super(key: key);

  final String searchTerm;

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  late final FirebaseCloudDatabase _dbService;

  @override
  void initState() {
    _dbService = FirebaseCloudDatabase();
    super.initState();
  }

  void search(searchTerm) async {}

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder(
          future: _dbService.searchUsers(widget.searchTerm),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return Column(
                  children: snapshot.data!.docs.map((e) {
                return Row(children: [CircleAvatar(
                radius: 20,
                backgroundColor: const Color.fromARGB(255, 192, 229, 228),
                foregroundImage:
                    Image.asset('assets/images/defaultprofile.png').image),
                Text(e["username"])]);
              }).toList());
            } else if (snapshot.hasError) {
              return CircleAvatar(
                radius: 20,
                backgroundColor: const Color.fromARGB(255, 192, 229, 228),
                foregroundImage:
                    Image.asset('assets/images/defaultprofile.png').image,
              );
            } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return Text("No results found");
            } else {
              return Text("Loading...");
            }
          })
    ]);
  }
}

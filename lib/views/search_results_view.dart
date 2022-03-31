import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapview/services/firebase_database.dart';
import 'package:mapview/utilities/floating_menu.dart';
import 'package:mapview/views/user_profile_view.dart';

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
                return Padding(padding: EdgeInsets.symmetric(vertical: 5), child:  GestureDetector(
                  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UserProfileView(username: e["username"],)),
  ),
                  child:
                Row(children: [
                  
                  CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color.fromARGB(255, 192, 229, 228),
                      foregroundImage: (e.data().keys.contains("photoUrl"))
                          ? CachedNetworkImageProvider(
                              "https://firebasestorage.googleapis.com/v0/b/herewer-a1d7b.appspot.com/o/" +
                                  e["photoUrl"] +
                                  "?alt=media")
                          : Image.asset('assets/images/defaultprofile.png')
                              .image), SizedBox(width:10),
                  Text(e["username"])
                ])));
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

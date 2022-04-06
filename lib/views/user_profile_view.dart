import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapview/services/firebase_database.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({ Key? key, required this.username }) : super(key: key);
  
  final String username;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Stack(
                  children: [
                    FutureBuilder(
                future: FirebaseCloudDatabase().getUser(widget.username),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [Center(
                        child:
                      CircleAvatar(
                        radius: 75,
                        backgroundColor:
                            const Color.fromARGB(255, 192, 229, 228),
                        foregroundImage: (snapshot.data!.docs.first
                        .data().keys.contains("photoUrl"))
                          ? CachedNetworkImageProvider(
                              "https://firebasestorage.googleapis.com/v0/b/herewer-a1d7b.appspot.com/o/" +
                                  snapshot.data!.docs.first["photoUrl"] +
                                  "?alt=media")
                          : Image.asset('assets/images/defaultprofile.png')
                              .image),
                             
                    ), const SizedBox(height: 50),]);
                  } else {
                    return const Center(child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Color.fromARGB(255, 192, 229, 228),
                    ));
                  }
                }),
                Center(
                      child: Image.asset("assets/images/profileborder.png", height: 150, width: 150,),
                       
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Text("Music is life ✌🏻",),

                
                
              ],
            ),
          ),
        ),
      
    );
  }
}
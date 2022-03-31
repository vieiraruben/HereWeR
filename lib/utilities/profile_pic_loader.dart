// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:mapview/services/firebase_database.dart';

// Future<ImageProvider?> downloadPic(String username) async {
//   String? url = await FirebaseCloudDatabase().getProfilePic(username);
//   if (url != null && url != "default") {
//     return CachedNetworkImageProvider(url);
//   } else { 
//     return Image.asset('assets/images/defaultprofile.png').image;
//   }
// }
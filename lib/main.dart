import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'flutter_maps/google_map/showMap.dart';


String result = "";
String deviceNameP='';

void main() {
//MapView.setApiKey("AIzaSyDVlsGtxNYsdrq1G0KGg2yTJiHUBtpId7g");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // to remove Red DEBUG Banner
    home: HomePage(),
  ));
}

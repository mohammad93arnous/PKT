import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pktapp/LinkWithEmail.dart';
import 'package:pktapp/userProfile.dart';
import 'package:map_view/map_view.dart';
import 'package:pktapp/util/theme.dart';
import 'Adding Device.dart';
import 'BillSpliter.dart';
import 'DeviceInfo.dart';
import 'HomePage.dart';
import 'LoginScreen.dart';
import 'RegistertionAccount.dart';
import 'flutter_maps/google_map/showMap.dart';

String result = "";
String deviceNameP='';

void main() {
//MapView.setApiKey("AIzaSyDVlsGtxNYsdrq1G0KGg2yTJiHUBtpId7g");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // to remove Red DEBUG Banner
    home: UserPof(),
  ));
}

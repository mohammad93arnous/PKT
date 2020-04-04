import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pktapp/flutter_maps/google_map/showMap.dart';
import 'AUTH/Auth.dart';
import 'SnackBar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'BillSpliter.dart';
import 'RegistertionAccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'DeviceInfo.dart';
import 'flutter_maps/google_map/showMap.dart';
import 'LinkWithEmail.dart';


class UserPof extends StatefulWidget {
  UserPof( {this.deviceName,this.deviceSerial,this.accountName,this.email});
  @override
  State<StatefulWidget> createState() => new _UserPofState();
  final String deviceName;
  final String deviceSerial;
  final String accountName;
  final String email;
}

class _UserPofState extends State<UserPof> {
//String accountName2=widget.accountName;
//String accountEmail="Email";
  @override
  void initState() {
    super.initState();
  }

//void _userNameLog(){
//    setState(() {
//      if(widget.accountName.isNotEmpty){
//        accountName=widget.accountName;
//
//      }
//    });
//}

//void _userEmailLog(){
//  setState(() {
//    if(widget.email.isNotEmpty){
//      accountEmail=widget.email;
//
//    }
//  });
//}

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      // Key For calling Scaffold to show SnackBar
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Account Name"),
              accountEmail: Text("Email"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.blue
                    : Colors.white,
                child: Text(
                  "M",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
                title: Text(
                  "Profile",
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BillSpliter()));
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BillSpliter()));
                },
                trailing: Icon(Icons.account_box)),
            ListTile(
              title: Text("Live Location"),onTap: (){Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => ShowMap()));},
              trailing: Icon(Icons.location_on),
            ),
            ListTile(
              title: Text("Devices"),
              trailing: Icon(Icons.perm_device_information),
            ),
            ListTile(
              title: Text("History"),
              trailing: Icon(Icons.history),
            ),

          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
      //backgroundColor: Color.fromARGB(255, 255, 10, 10),
      title: Text(
      "Parental Kids Tracker",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
          color: Colors.amberAccent.shade700),
    ),
    centerTitle: true,

    backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        child: Icon(Icons.person),
        onPressed: () => debugPrint("Add A Kid"),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.account_box), title: Text("Account")),
        BottomNavigationBarItem(
          icon: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ShowMap()));
              },
              child: Icon(Icons.gps_fixed)),
          title: Text("GPS"),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box), title: Text("New Device"))
      ]),

    );
  }
}

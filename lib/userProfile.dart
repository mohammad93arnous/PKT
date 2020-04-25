
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:pktapp/AddDeviceAfterAuth.dart';
import 'package:pktapp/HomePage.dart';
import 'package:pktapp/flutter_maps/google_map/showMap.dart';
import 'SnackBar.dart';
import 'flutter_maps/google_map/ShowGivinDeviceMap.dart';
import 'flutter_maps/google_map/showMap.dart';
import 'models/CustomText.dart';

//******************* Importing all needed packages for this class *****************************
class UserPof extends StatefulWidget {
  UserPof(
      {this.uID,
      this.deviceName,
      this.deviceSerial,
      this.accountName,
      this.email});

  @override
  State<StatefulWidget> createState() => new _UserPofState();
  String uID;
  String deviceName;
  String deviceSerial;
  String accountName;
  String email;
}

class _UserPofState extends State<UserPof> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String uID;
  String email = 'Email';
  String userName = 'UserName';
  bool dataFetched = false;
  DocumentSnapshot userData;
  FirebaseUser user;
  String editedUserName;
  String editedDeviceName;
  QuerySnapshot deviceFBData;

  ////// Variables filled from FB//////

  @override
  void initState() {
    setState(() {
      uID = widget.uID;
    });
    getUserInfo().whenComplete(() {
      getDevicesData(userData);
      saveDeviceToken();
    });
    super.initState();
  }
  final FirebaseMessaging _fcm = FirebaseMessaging();
  saveDeviceToken() async {
    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = Firestore.instance.collection('UsersAccount').document(uID);
      await tokens.updateData({
        'FBNotificationToken': fcmToken,
        'FBFBNotificationTokenCreatedAt': FieldValue.serverTimestamp(), // optional
        'UserPlatform': Platform.operatingSystem // optional
      });
    }
  }



  Future getUserInfo() async {
    userData = await Firestore.instance
        .collection('UsersAccount')
        .document(uID)
        .get()
        .whenComplete(() {
      setState(() {
        dataFetched = true;
      });
      getDevicesData(userData);
    });
    setState(() {
      userName = userData.data['AccountName'];
      email = userData.data['Email'];
    });
  }

  showEditUserNameBottomSheet(BuildContext context) {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.lightGreen.shade300.withOpacity(0.70),
            border: Border.all(color: Colors.white54, width: 1),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      Icons.perm_contact_calendar,
                      color: Colors.white,
                      size: 120,
                    )),
              ),
              flex: 5,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Change User Name ?',
                      style: CustomTextStyle.textFormFieldMedium
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        labelText: 'Edit Your User Name',
                        labelStyle:
                            TextStyle(color: Colors.amberAccent.shade700),
                        focusColor: Colors.black,
                        hoverColor: Colors.black,
                        isDense: true,
                      ),
                      onChanged: (value) {
                        if (value == null) {
                          snackError('Invalid', context);
                        } else {
                          setState(() {
                            editedUserName = value;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        await Firestore.instance
                            .collection('UsersAccount')
                            .document(uID)
                            .updateData({
                          'AccountName': editedUserName,
                        });
                        Navigator.pop(context);
                        setState(() {
                          userName = editedUserName;
                        });
                      },
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Change",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(color: Colors.amberAccent.shade700),
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.black,
        elevation: 2);
  }

  showEditDeviceInfoBottomSheet(BuildContext context, String docID) {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.lightGreen.shade300.withOpacity(0.70),
            border: Border.all(color: Colors.white54, width: 1),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 120,
                    )),
              ),
              flex: 5,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Change Device Name ?',
                      style: CustomTextStyle.textFormFieldMedium
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        labelText: 'Edit Your Device Name',
                        labelStyle:
                            TextStyle(color: Colors.amberAccent.shade700),
                        focusColor: Colors.black,
                        hoverColor: Colors.black,
                        isDense: true,
                      ),
                      onChanged: (value) {
                        if (value == null) {
                          snackError('Invalid', context);
                        } else {
                          if (!mounted) return;
                          setState(() {
                            editedDeviceName = value;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (!mounted) return;
                        FocusScope.of(context).requestFocus(FocusNode());
                        await Firestore.instance
                            .collection('Devices')
                            .document(docID)
                            .updateData({
                          'DeviceName': editedDeviceName,
                        });
                        Navigator.pop(context);
                        if (!mounted) return;
                      },
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Change",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(color: Colors.amberAccent.shade700),
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.black,
        elevation: 2);
  }

// get devices list from Firebase through UserData Variable
  getDevicesData(DocumentSnapshot data) async {
    if (data == null) {
      getUserInfo().whenComplete(() {
        getDevicesData(userData);
      });
    } else {
      Stream<QuerySnapshot> deviceData = Firestore.instance
          .collection('Devices')
          .where('UID', isEqualTo: uID)
          .snapshots();
      deviceData.listen((QuerySnapshot devData) {
        if (devData.documents == null) {
          // Do Nothing
        } else {
          setState(() {
            deviceFBData = devData;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Key For calling Scaffold to show SnackBar

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  children: <Widget>[
                    Text(userName),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        showEditUserNameBottomSheet(context);
                      },
                    )
                  ],
                ),
              ),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  '${userName[0]}',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
                title: Text(
                  "Profile",
                ),
                onTap: () {},
                trailing: Icon(Icons.account_box)),
            ListTile(
              title: Text("Live Location"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ShowMap()));
              },
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
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut().whenComplete(() {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
                });
              },
              title: Text(
                "SignOut",
                style: TextStyle(color: Colors.red),
              ),
              trailing: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
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
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          icon: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ShowMap(
                          uID: uID,
                        )));
              },
              child: Icon(Icons.gps_fixed)),
          title: Text("GPS"),
        ),
        BottomNavigationBarItem(
            icon: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AddDeviceAfterAuth(
                            uID: uID,
                          )));
                },
                child: Icon(Icons.add_box)),
            title: Text("New Device"))
      ]),
      body: userBody(),
    );
  }

  Widget userBody() {
    if (deviceFBData == null) {
      return Container();
    } else {
      return Container(
        height: 624,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: deviceFBData.documents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onLongPress: () {
                        showModalBottomSheet(
                            context: _scaffoldKey.currentContext,
                            backgroundColor:
                                Colors.lightGreen.shade300.withOpacity(0.40),
                            builder: (BuildContext context) {
                              return Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              showEditDeviceInfoBottomSheet(
                                                  context,
                                                  deviceFBData
                                                      .documents[i].documentID);
                                            },
                                            color: Colors.amberAccent.shade700,
                                            //Colors.blue.withOpacity(0.5),
                                            child: Text('Edit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                          ),
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              String docIdDeleted = deviceFBData
                                                  .documents[i].documentID;
                                              await Firestore.instance
                                                  .collection('Devices')
                                                  .document(docIdDeleted)
                                                  .delete();
                                              await Firestore.instance
                                                  .collection('SerialNumbers')
                                                  .document(docIdDeleted)
                                                  .updateData({
                                                'ReservedUID': " ",
                                                'SerialReserved': false
                                              });
                                            },
                                            color: Colors.amberAccent.shade700,
                                            //Colors.blue.withOpacity(0.5),
                                            child: Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade300.withOpacity(0.70),
                          border: Border.all(color: Colors.white54, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 15,
                              left: 9,
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: AssetImage('assets/band.png'),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 160,
                              child: Text(
                                deviceFBData.documents[i].data['DeviceName']
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Positioned(
                              top: 35,
                              left: 75,
                              child: Text(
                                'Distance From You: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Positioned(
                              top: 35,
                              left: 212,
                              child: Text(
                                deviceFBData.documents[i].data['DistanceAway']
                                        .toString() +
                                    ' meters',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Positioned(
                              top: 55,
                              left: 75,
                              child: Text(
                                'Loctation:',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Positioned(
                              top: 55,
                              left: 150,
                              child: Text(
                                'Dammam,Alsalam',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Positioned(
                                top: 30,
                                left: 370,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ShowGivenDeviceMap(
                                                  uID: uID,
                                                  deviceID: deviceFBData
                                                      .documents[i]
                                                      .data[
                                                          'DeviceSerialNumber']
                                                      .toString(),
                                                )));
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    }
  }
} //********************************The End of the Class  ********************************

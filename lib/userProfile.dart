import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pktapp/HomePage.dart';
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
import 'models/CustomText.dart';


class UserPof extends StatefulWidget {
  UserPof( {this.uID,this.deviceName,this.deviceSerial,this.accountName,this.email});
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
  String email='Email';
  String userName='UserName';
  bool dataFetched=false;
  DocumentSnapshot userData;
  FirebaseUser user;
   String editedUserName;

  @override
  void initState() {
    setState(() {
      uID=widget.uID;
    });
      getUserInfo();
    super.initState();
  }


  getUserInfo()async{
    userData=await Firestore.instance.collection('UsersAccount').document(uID).get().whenComplete((){
      setState(() {
        dataFetched=true;
      });
    });
    setState(() {
      userName=userData.data['AccountName'];
      email=userData.data['Email'];
    });
  }

showEditUserNameBottomSheet(BuildContext context) {
  return _scaffoldKey.currentState.showBottomSheet((context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(color: Colors.lightGreen.shade300.withOpacity(0.70), border: Border.all(color: Colors.white54, width: 1), borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
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
                    style: CustomTextStyle.textFormFieldMedium.copyWith(fontSize: 16, color: Colors.white),
                  ),
//                  Text(
//                    'Edit User Name',
//                    style: CustomTextStyle.textFormFieldMedium.copyWith(fontSize: 16, color: Colors.white),
//                  ),
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
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid)),
                      labelText: 'Edit Your User Name',
                      labelStyle: TextStyle(color: Colors.amberAccent.shade700),
                      focusColor: Colors.black,
                      hoverColor: Colors.black,
                      isDense: true,
                    ),
                    onChanged: (value){
                      if(value==null){
                        snackError('Invalid', context);
                      }else{
                        setState(() {
                          editedUserName=value;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  RaisedButton(
                    onPressed: () async{
                      await Firestore.instance.collection('UsersAccount').document(uID).updateData({
                        'AccountName': editedUserName,
                      });
                      Navigator.pop(context);
                      setState(() {
                        userName= editedUserName;
                      });
                    },
                    padding: EdgeInsets.only(left: 48, right: 48),
                    child: Text(
                      "Change",
                      style: CustomTextStyle.textFormFieldMedium.copyWith(color: Colors.amberAccent.shade700),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  )
                ],
              ),
            ),
            flex: 5,
          )
        ],
      ),
    );
  }, shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16))),
      backgroundColor: Colors.black,
      elevation: 2);
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
                    SizedBox(width: 20,),
                    IconButton(
                      icon: Icon(Icons.edit,color: Colors.white,size: 18,),
                      onPressed: (){
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
            ListTile(
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) => HomePage()));
              },
              title: Text("SignOut",style: TextStyle(color:Colors.red),),
              trailing: Icon(Icons.exit_to_app,color: Colors.red,),
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
//      floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.indigoAccent,
//        child: Icon(Icons.person),
//        onPressed: () => debugPrint("Add A Kid"),
//      ),
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
body: userBody(),
    );
  }
  Widget userBody(){
    return Container(
      height: 624,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                  color: Colors.lightGreen.shade300.withOpacity(0.70),
                  border: Border.all(color: Colors.white54, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[

                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}

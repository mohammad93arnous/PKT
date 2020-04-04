import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:email_validator/email_validator.dart';
import 'Adding Device.dart';
import 'RegistertionAccount.dart';
import 'SnackBar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DeviceInfo.dart';
import 'dart:io';


class LinkWithEmail extends StatefulWidget {
  LinkWithEmail({this.accountName,this.password,this.deviceName,this.deviceSerial,this.result});
  @override
  State<StatefulWidget> createState() => new _LinkWithEmailState();
  final String accountName;
  final String password;
  final String deviceName;
  final String deviceSerial;
  final String result;



}

class _LinkWithEmailState extends State<LinkWithEmail> {
  final _scaffoldKey = GlobalKey(); // Scaffold Key
  String email;
  String userID='';
  FirebaseUser user;


  @override
  void initState() {
    print(widget.accountName);
    print(widget.password);
    print(widget.deviceName);
    print(widget.deviceSerial);


    super.initState();
  }


  Future signUp () async{
    if(email==null){
      snackError('Email is Empty', context);
    }else{
      try{
       user= await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password:widget.password
        );

      }catch (e){
        snackError(e.toString(), context);
      }
    }
    saveUser();
    return user;
  }

  Future saveUser()async{
    if(user !=null){
      if(user.uid !=null && user.email !=null){
        setState(() {
          userID=user.uid;
        });
        await Firestore.instance.collection('UsersAccount').document(userID).setData({
          'AccountName':widget.accountName,
          'Email':email,
          'UserID':userID,
          'FamilyUser':{
            'UserId1':' '
          },
          'Devices':{
            '1':{
              'DeviceLocations':{
                'Location1':{
                  'Altitude':' ',
                  'Latitude':'',
                },
              },
              'DeviceName':widget.deviceName,
              'DeviceSerialNumber':widget.deviceSerial,
              'QR':widget.result,
            }
          }
        });

//      else if (_loginPassword == null) {
//        snackError('Password cannot be empty', context);
//        passValidated=false;//new
//      }

      if(email!=null && email.length>6){
          if (email.contains("@") ==true){
                    Navigator.of(context).push(MaterialPageRoute(
                         builder: (BuildContext context) => UserPof()));
              }else {
             return  snackError(" Email must be lower case",context);

              }
              }else{
              return snackError("Invalid Email",context);
              }
      }else{
        snackError('Connection Error', context);
      }
    }else{
      snackError('Email Does Not Exist ', context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
        title: Text(
          "Link with email",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 30.0,
              color: Colors.amberAccent.shade700),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset('assets/images/email.png'),
              ),
              height: 250.0,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-z@. 0-9 _-]"))],
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(//should be all small
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    hintText: "Input your email",
                    prefixIcon: Icon(Icons.account_circle)),
                onChanged: (val){
                  setState(() {
                    email=val;
                  });
                },
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.all(30.0),
//              child: TextField(
//                keyboardType: TextInputType.text,
//                style: TextStyle(color: Colors.black),
//                decoration: InputDecoration(

//                  border: OutlineInputBorder(
//                      borderSide: BorderSide(width: 2, color: Colors.green),
//                      borderRadius: BorderRadius.circular(20.0)),
//                  focusedBorder: OutlineInputBorder(
//                      borderRadius: BorderRadius.circular(20.0),
//                      borderSide: BorderSide(width: 0.5, color: Colors.green)),
//                  hintText: "Verification code",
//                ),
//              ),
//            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.white70,
                  ),
                  RaisedButton(
                    onPressed: () {

                      saveUser();
                      signUp();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                          UserPof(
                            deviceName:widget.deviceName,
                            deviceSerial :widget.deviceSerial,
                            accountName: widget.accountName,
                            email: email,

                          )
                      ));

                    },
                    child: Text(
                      'Complete',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}

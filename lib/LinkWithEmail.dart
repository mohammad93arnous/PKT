import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:pktapp/DeviceInfo.dart';
import 'SnackBar.dart';
import 'userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LinkWithEmail extends StatefulWidget {
  LinkWithEmail({this.accountName, this.password, this.deviceName, this.deviceSerial, this.result});
  @override
  State<StatefulWidget> createState() => new _LinkWithEmailState();
  String accountName;
  String password;
  String deviceName;
  String deviceSerial;
  String result;
}

class _LinkWithEmailState extends State<LinkWithEmail> {
  final _scaffoldKey = GlobalKey(); // Scaffold Key
  String email;


  @override
  void initState() {
    super.initState();
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
              child: TextField(
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-z@. 0-9 _-]"))
                ],
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    //should be all small
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    hintText: "Input your email",
                    prefixIcon: Icon(Icons.account_circle)),
                onChanged: (val) {
                  setState(() {
                    email = val;
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
                      if(email==null){
                        snackError('Email cannot be empty', context);
                      }else{
                        if(email.length<=5|| email.contains('@')==false){
                          snackError('Email Invalid', context);
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => DeviceInfo(
                                accountName: widget.accountName,
                                email: email,
                                password: widget.password,
                              )));
                        }
                      }
                    },
                    child: Text(
                      'Next',
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

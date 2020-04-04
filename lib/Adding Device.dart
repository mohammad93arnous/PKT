import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:pktapp/DeviceInfo.dart';

import 'RegistertionAccount.dart';

class AddingDevice extends StatefulWidget {
  @override
  AddingDeviceState createState() {
    return new AddingDeviceState();
  }
}

class AddingDeviceState extends State<AddingDevice> {
  String result = "";
  String myResult;

  Future scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "Scan QR Code",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.amberAccent.shade700),
          )),
          backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
        ),

        body:  SingleChildScrollView(
    child: Column(
        children: <Widget>[
    Padding(
    padding: const EdgeInsets.all(30.0),
          child:  Text(
              result,
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(135.0,15.0,135.0,100.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DeviceInfo(

                          result:result,

                        )
                ));
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
          ),
      ]
        )
        ),





      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),heroTag: "fe",
        label: Text("Scan QR Code",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
            color: Colors.amberAccent.shade700)),backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
        onPressed: scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,






    );

  }
}



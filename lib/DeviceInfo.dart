import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:pktapp/LinkWithEmail.dart';
import 'Adding Device.dart';
import 'SnackBar.dart';
import 'userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'RegistertionAccount.dart';
class DeviceInfo extends StatefulWidget {
  DeviceInfo({this.result});
  @override
  State<StatefulWidget> createState() => new _DeviceInfoState();
final result;
}

class _DeviceInfoState extends State<DeviceInfo> {

  final _scaffoldKey = GlobalKey(); // Scaffold Key

  bool _obscureTextLogin = true;
  TextEditingController deviceAccountName = new TextEditingController();
  TextEditingController deviceSer = new TextEditingController();

  bool deviceNameValidated = false;
  bool deviceSerialValidated = false;

String deviceName;
String deviceSerial;

  @override
  void initState() {
    super.initState();
  }
  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
  deviNameValidation() {
    if (deviceAccountName.text == null || deviceName.length <= 3) {
      snackError('Name Must Contain Text Only', context);
      deviceNameValidated = false;
    } else if (deviceAccountName.text.contains('-,*,/,+,=,(,),%,@,!', 0) ==
        true) {
      snackError('Name Must Contain Text Only', context);
      deviceNameValidated = false;
    } else {
      setState(() {
        deviceNameValidated = true;
      });
    }
  }

  deviSiralValidation() {
    if (deviceSer.text == null || deviceSerial.length <= 3) {
      snackError('Serial Number Must Contain Text Only', context);
      deviceSerialValidated = false;
    } else if (deviceSer.text.contains('-,*,/,+,=,(,),%,@,!', 0) ==
        true) {
      snackError('Serial Number Must Contain Text Only', context);
      deviceSerialValidated = false;
    } else {
      setState(() {
        deviceSerialValidated = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
        title: Text(
          "Device Information",
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
                child: Image.asset('assets/band.png'),
              ),
              height: 250.0,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z 0-9 _-]"))],
    controller: deviceAccountName,
    keyboardType: TextInputType.text,
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
                    hintText: "Input your Device Name",
                    prefixIcon: Icon(Icons.watch)),
                onChanged: (val){
                  setState(() {
                    deviceName=val;
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                controller: deviceSer,
                keyboardType: TextInputType.text,
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
                    hintText: "Device Serial Number",
                    prefixIcon: Icon(Icons.create)),
                onChanged: (val){
                  setState(() {
                    deviceSerial=val;
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AddingDevice()));
                },

                child: Text(
                  'Scan QR Code',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                color: Colors.white70,
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

                      validatingBeforeNavigate();



                    },
                    child: Text(
                      'Save',
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




  Future validatingBeforeNavigate() {
    print(deviceNameValidated.toString());
    print(deviceSerialValidated.toString());
    if (deviceName == null) {
      snackError('Device Name cannot be empty', context);
    } else if (deviceSerial == null) {
      snackError('Device Serial Number cannot be empty', context);
    } else if (deviceName == null) {
      snackError('Re-Password cannot be empty', context);
    } else {
      deviNameValidation();
      deviSiralValidation();

      if (deviceNameValidated == false && deviceSerialValidated == false) {
        setState(() {
          deviceNameValidated = false;
          deviceSerialValidated = false;
        });
      } else {
//        loginAccountName.clear();
//        loginPasswordController.clear();
//        loginRePasswordController.clear();

        print(deviceNameValidated.toString());
        print(deviceSerialValidated.toString());
        if (deviceNameValidated == false && deviceSerialValidated == false) {
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                RegistertionAccount(
                deviceName:deviceName,
                deviceSerial :deviceSerial,
                  result: widget.result,

                  )
          ));
        }
      }
    }
  }

}

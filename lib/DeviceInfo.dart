import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart'as prefix0;
import 'SnackBar.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'main.dart';
import 'userProfile.dart';
//******************* Importing all needed packages for this class *****************************
class DeviceInfo extends StatefulWidget {
  DeviceInfo({this.result,this.uID,this.accountName, this.password,this.email});

  @override
  State<StatefulWidget> createState() => new _DeviceInfoState();
  String result;
  String uID;
  String accountName;
  String password;
  String email;

}

class _DeviceInfoState extends State<DeviceInfo> {
  String userID = '';
  FirebaseUser user;
  bool _obscureTextLogin = true;
  TextEditingController deviceAccountName = new TextEditingController();
  TextEditingController deviceSer = new TextEditingController();

  bool deviceNameValidated = false;
  bool deviceSerialValidated = false;

  String deviceName = '';
  String deviceSerial = '';
  String qrResult;
  Position position;

  @override
  void initState() {
    checkIfQRScanned();
    getLocation();
    super.initState();
  }

  void _toggleLogin() {
    if (!mounted) return;
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkIfQRScanned() {
    if (result == null) {
      if (!mounted) return;
      setState(() {
        deviceSerial = 'Device Serial Number';
        deviceName = 'Input your Device Name';
      });
    } else if (result != null) {
      if (!mounted) return;
      setState(() {
        deviceSer.text = result;
        //deviceSerial=result;
        deviceAccountName.text = deviceNameP;
      });
    }
  }

  deviNameValidation() {
    if(deviceNameP==null){
      if (deviceAccountName.text == null || deviceName.length <= 3) {
        snackError('Name Must Contain Text Only', context);
        deviceNameValidated = false;
      } else if (deviceAccountName.text.contains('-,*,/,+,=,(,),%,@,!', 0) ==
          true) {
        snackError('Name Must Contain Text Only', context);
        deviceNameValidated = false;
      } else {
        if (!mounted) return;
        setState(() {
          deviceNameValidated = true;
        });
      }
    }else{
      if (!mounted) return;
      setState(() {
        deviceNameValidated = true;
      });
    }
  }

  deviSiralValidation() {
    if(result==null){
      if (deviceSer.text == null || deviceSerial.length <= 3) {
        snackError('Serial Number Must Contain Text Only', context);
        deviceSerialValidated = false;
      } else if (deviceSer.text.contains('-,*,/,+,=,(,),%,@,!', 0) == true) {
        snackError('Serial Number Must Contain Text Only', context);
        deviceSerialValidated = false;
      } else {
        if (!mounted) return;
        setState(() {
          deviceSerialValidated = true;
        });
      }
    }else{
      if (!mounted) return;
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
              child: TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z 0-9 _-]"))
                ],
                controller: deviceAccountName,
                keyboardType: TextInputType.text,
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
                    hintText: "Input your Device Name $deviceName",
                    prefixIcon: Icon(Icons.watch)),
                onChanged: (val) {
                  if (!mounted) return;
                  setState(() {
                    deviceName = val;
                    deviceNameP = val;
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
                decoration: InputDecoration(
                  //should be all small
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    hintText: 'Device Serial Number $deviceSerial',
                    prefixIcon: Icon(Icons.create)),
                onChanged: (val) {
                  if (!mounted) return;
                  setState(() {
                    deviceSerial = val;
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
//                  Navigator.of(context).push(MaterialPageRoute(
//                      builder: (BuildContext context) => AddingDevice()));
                  scanQR().whenComplete((){
                    if (!mounted) return;
                    setState(() {
                      result = qrResult;
                    });
                    checkIfQRScanned();
                  });
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
                      'Cancel',
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
                      'Connect',
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
  Future scanQR() async {
    try {
      qrResult = await BarcodeScanner.scan();
      if (!mounted) return;
      setState(() {
        result = qrResult;
      });
      checkIfQRScanned();
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        snackError('Camera permission was denied', context);
      } else {
        snackError('Unknown Error', context);
      }
    } on FormatException {
      snackError('You pressed the back button before scanning anything', context);
    } catch (ex) {
      snackError('Unknown Error', context);
    }
    //checkIfQRScanned();
  }
  Future validatingBeforeNavigate() {
    print(deviceNameValidated.toString());
    print(deviceSerialValidated.toString());
    if(deviceNameP!=null && deviceSer.text!=null){
      validateSerialNumber(deviceNameP,deviceSer.text);
    }else{
      print('else');
      if (deviceName == null) {
        snackError('Device Name cannot be empty', context);
      } else if (deviceSerial == null|| result==null) {
        snackError('Device Serial Number cannot be empty', context);
      } else if (deviceName == null||deviceNameP==null) {
        snackError('Re-Password cannot be empty', context);
      } else {
        deviNameValidation();
        deviSiralValidation();

        if (deviceNameValidated == false && deviceSerialValidated == false) {
          if (!mounted) return null;
          setState(() {
            deviceNameValidated = false;
            deviceSerialValidated = false;
          });
        } else {
          print(deviceNameValidated.toString());
          print(deviceSerialValidated.toString());
          if (deviceNameValidated == false && deviceSerialValidated == false) {
          } else {
            validateSerialNumber(deviceName,deviceSerial);

          }
        }
      }
    }
  }

  Future validateSerialNumber(String deviceName,String serialNumber)async {
    await Firestore.instance.collection('SerialNumbers').document(deviceSerial).get().then((serialData){
      if(serialData.exists==false){
        //Serial Not Found
        snackError('Invalid Serial', context);
        print('Serial Not Found');
      }else{
        if(serialData.data['SerialReserved']==true){
          snackError('Invalid Serial', context);
          print('serial Found But Associated to another user');
          //serial Found But Associated to another user
        }else{
          print('Serial Found and free to use');
          //Serial Found and free to use
          signUp().then((val){
           if(user==null){
             snackError('Cannot SignIn please try again', context);
           }else{
             if(user.uid==null){
               snackError('Cannot SignIn please try again', context);
             }else{
               saveUser().whenComplete((){
                 addDevice(serialNumber,deviceName);
               });
             }
           }
          });
        }
      }
    });
  }

  getLocation() async {
    position = await Geolocator().getCurrentPosition(desiredAccuracy: prefix0.LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    return position;
  }

  Future addDevice(String serial,String deviceName)async{
    print('Saving Device to DB');
    int distanceAway=0;
    await Firestore.instance.collection('Devices').document(serial).setData(({
      'DeviceName':deviceName,
      'DeviceSerialNumber':serial,
      'DistanceAway':distanceAway,
      'Location':GeoPoint(position.latitude,position.longitude),
      'UID':userID,
    })).whenComplete((){
      updateSerial(serial).whenComplete((){
        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => UserPof(uID: userID,)));
      });
    });
  }

  Future updateSerial(String serial)async{
    await Firestore.instance.collection('SerialNumbers').document(serial).updateData(({
      'SerialReserved':true,
      'ReservedUID':widget.uID,
    }));
  }


  Future signUp() async {
    print('Creating User');
    if (widget.email == null) {
      snackError('Email is Empty', context);
    } else {
      await FirebaseAuth.instance.signOut();
      try {
        user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email:widget.email, password: widget.password);
      } catch (e) {
        snackError(e.toString(), context);
      }
    }
    return user;
  }

  Future saveUser() async {
    print('adding User to DB');
    if (user != null) {
      if (user.uid != null && user.email != null) {
        if (!mounted) return;
        setState(() {
          userID = user.uid;
        });
        await Firestore.instance.collection('UsersAccount').document(userID).setData({
          'AccountName': widget.accountName,
          'Email': widget.email,
          'UserID': userID,
        });
        if (widget.email != null && widget.email.length > 6) {
          if (widget.email.contains("@") == true) {
            // Do Nothing
          } else {
            return snackError(" Email must be lower case", context);
          }
        } else {
          return snackError("Invalid Email", context);
        }
      } else {
        snackError('Connection Error', context);
      }
    } else {
      snackError('Email Does Not Exist ', context);
    }
  }
}//********************************The End of the Class  ********************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as prefix0;
import 'SnackBar.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'main.dart';
import 'userProfile.dart';

//******************* Importing all needed packages for this class *****************************
class AddDeviceAfterAuth extends StatefulWidget {
  AddDeviceAfterAuth({this.result, this.uID});//calling the variable from another class

  @override
  State<StatefulWidget> createState() => new _AddDeviceAfterAuthState();
  String result;//the result of the serial number
  String uID;//user ID
}

class _AddDeviceAfterAuthState extends State<AddDeviceAfterAuth> {//adding a new device when the user logging in the account .
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
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkIfQRScanned() {//checking when the user open the camera to scan QR code and take the result and save it .
    if (result == null) {
      setState(() {
        deviceSerial = 'Device Serial Number';
        deviceName = 'Input your Device Name';
      });
    } else if (result != null) {
      setState(() {
        deviceSer.text = result;
        //deviceSerial=result;
        deviceAccountName.text = deviceNameP;
      });
    }
  }

  deviNameValidation() {//device name method that gives some conditions for choosing a name of the device.
    if (deviceNameP == null) {
      if (deviceAccountName.text == null || deviceName.length <= 3) {
       snackError('Name must be more than three characters', context);
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
    } else {
      setState(() {
        deviceNameValidated = true;
      });
    }
  }

  deviSiralValidation() {//device serial method that gives some conditions for input the serial number of the device .
    if (result == null) {
      if (deviceSer.text == null || deviceSerial.length <= 3) {
        snackError('Serial Number Must be more than three numbers', context);
        deviceSerialValidated = false;
      } else if (deviceSer.text.contains('-,*,/,+,=,(,),%,@,!', 0) == true) {
        snackError('Serial Number Must Contain Text Only', context);
        deviceSerialValidated = false;
      } else {
        setState(() {
          deviceSerialValidated = true;
        });
      }
    } else {
      setState(() {
        deviceSerialValidated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {//a widget and making an app bar .
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
      body: SingleChildScrollView(//the body
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset('assets/band.png'),//importing an image and set it in the page
              ),
              height: 250.0,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(//creating text field and giving conditions of the input keyboard type
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
                  setState(() {
                    deviceName = val;
                    deviceNameP = val; //why?? for what?
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
                  setState(() {
                    deviceSerial = val;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {//activate the button of the scan QR
                  scanQR().whenComplete(() {
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

  Future scanQR() async { //scan QR function that when the user click on Scan QR this function will be called and its will read the QR code
    try {
      qrResult = await BarcodeScanner.scan();
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
      snackError(
          'You pressed the back button before scanning anything', context);
    } catch (ex) {
      snackError('Unknown Error', context);
    }
    //checkIfQRScanned();
  }

  Future validatingBeforeNavigate() {//is a function that chick the information that the user input and if the information are true it will continue to the next page.
    print(deviceNameValidated.toString());
    print(deviceSerialValidated.toString());
    if (deviceNameP != null && deviceSer.text != null) {
      validateSerialNumber(deviceNameP, deviceSer.text);
    } else {
      print('else');
      if (deviceName == null) {//Local notifications if the the user missed some inputs and press the next button.
        snackError('Device Name cannot be empty', context);
      } else if (deviceSerial == null || result == null) {
        snackError('Device Serial Number cannot be empty', context);
      } else if (deviceName == null || deviceNameP == null) {
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
          print(deviceNameValidated.toString());
          print(deviceSerialValidated.toString());
          if (deviceNameValidated == false && deviceSerialValidated == false) {
          } else {
            validateSerialNumber(deviceName, deviceSerial);
          }
        }
      }
    }
  }

  Future validateSerialNumber(String deviceName, String serialNumber) async {//Function to validate the serial number of the device
    await Firestore.instance//every device has a reserved serial number in the database , the function will chick with the firebase if the
        .collection('SerialNumbers') // serial number is reserved or is free to use .
        .document(deviceSerial)
        .get()
        .then((serialData) {
      if (serialData.exists == false) {
        //Serial Not Found
        snackError('Invalid Serial', context);
        print('Serial Not Found');
      } else {
        if (serialData.data['SerialReserved'] == true) {
          snackError('Invalid Serial', context);
          print('serial Found But Associated to another user');
          //serial Found But Associated to another user
        } else {
          print('Serial Found and free to use');
          //Serial Found and free to use
          addDevice(serialNumber, deviceName);
        }
      }
    });
  }

  getLocation() async {//getting the user's android device location
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: prefix0.LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    return position;
  }

  Future addDevice(String serial, String deviceName) async {//upload information of the device to the firebase in the collection of device
    int distanceAway = 0;
    await Firestore.instance
        .collection('Devices')
        .document(serial)
        .setData(({
          'DeviceName': deviceName,
          'DeviceSerialNumber': serial,
          'DistanceAway': distanceAway,
          'Location': GeoPoint(position.latitude, position.longitude),
          'UID': widget.uID,
        }))
        .whenComplete(() {
      updateSerial(serial).whenComplete(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => UserPof(
                  uID: widget.uID,
                )));
      });
    });
  }

  Future updateSerial(String serial) async {//uploading the serial number of the wearable device
    await Firestore.instance
        .collection('SerialNumbers')
        .document(serial)
        .updateData(({
          'SerialReserved': true,
          'ReservedUID': widget.uID,
        }));
  }
} //********************************The End of the Class  ********************************

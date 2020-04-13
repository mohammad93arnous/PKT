import 'package:firebase_database/firebase_database.dart';

class user_device {
  String _id ;
  String _name;
  double _latitude;
  double _longitude;
  String _description;
  String _devicetImage;

  user_device(this._id,this._name,
      this._latitude,this._longitude,
      this._description,this._devicetImage);


  user_device.map(dynamic obj){
    this._name = obj['name'];
    this._latitude = obj['latitude'];
    this._longitude = obj['longitude'];
    this._description = obj['description'];
    this._devicetImage = obj['devicetImage'];
  }

  String get id => _id;
  String get name => _name;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get description => _description;
  String get devicetImage => _devicetImage;

  user_device.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _latitude = snapshot.value['latitude'];
    _longitude = snapshot.value['longitude'];
    _description = snapshot.value['description'];
    _devicetImage = snapshot.value['devicetImage'];
  }
}
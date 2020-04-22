import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

String key = "AIzaSyD2OiBYq57wAfvwboGtwwGk6xqTHNKLceY";

//'pk.eyJ1IjoiaWdhdXJhYiIsImEiOiJjazFhOWlkN2QwYzA5M2RyNWFvenYzOTV0In0.lzjuSBZC6LcOy_oRENLKCg',
class ShowMap extends StatefulWidget {
  ShowMap({this.uID});
  @override
  _ShowMapState createState() => _ShowMapState();
  String uID;
}
bool clientsToggle = false;
// Dependanceies
//google_maps_flutter: ^0.0.3+3
//geoflutterfire: ^2.1.0
//location: ^2.5.3
class _ShowMapState extends State<ShowMap> {
  final Firestore _database = Firestore.instance;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor pinLocationIcon;
  QuerySnapshot fbData;
int _circleIdCounter=1;
double radius;
Set<Circle>_circles=HashSet<Circle>();
bool _isCircle=false;
  @override
  void initState(){
    crearmarcadores();
    super.initState();
    setCustomMapPin();
    _currentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }




  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.0),
        'assets/map-marker.png');
  }
  MapType _defaultMapType = MapType.normal;

  void _changeMapType() {
    if (!mounted) return;
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal ? MapType.normal : MapType.normal;
    });
  }

  void _changeMapType2() {
    if (!mounted) return;
    setState(() {
      _defaultMapType = _defaultMapType == MapType.satellite ? MapType.satellite : MapType.satellite;
    });
  }
  crearmarcadores() async{
//    await _database.collection('Devices')
//        .where('UID',isEqualTo: widget.uID)
//        .getDocuments().then((docs) {
//      if(docs.documents.isNotEmpty){
//        for(int i= 0; i < docs.documents.length; i++) {
//          initMarker(docs.documents[i].data, docs.documents[i].documentID);
//        }
//      }
//    });
    Stream<QuerySnapshot> deviceData = Firestore.instance.collection('Devices')
        .where('UID',isEqualTo: widget.uID).snapshots();
    deviceData.listen((QuerySnapshot devData){
      if(devData.documents.isNotEmpty){
        setState(() {
          clientsToggle = true;
        });
        for(int i= 0; i < devData.documents.length; i++) {
          initMarker(devData.documents[i].data, devData.documents[i].documentID);
//          _setCircles(devData.documents[i].data['Location']);


        }
      }
    });
  }

  void _setCircles(point){
    String circleIdval='circle_id_$_circleIdCounter';
    _circleIdCounter++;
    print('Circle | Latitude: ${point.latitude} Longitude: ${point.longitude} Redius: $radius');
    _circles.add(Circle(circleId: CircleId(circleIdval),
        center: point,
        radius: radius,
        fillColor: Colors.redAccent.withOpacity(0.5),
        strokeWidth: 3,strokeColor: Colors.redAccent));

  }


  void initMarker(lugar, lugaresid) {
    var markerIdVal = lugaresid;
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,icon:pinLocationIcon ,
      position: LatLng(lugar['Location'].latitude, lugar['Location'].longitude),
      infoWindow: InfoWindow(title: lugar['DeviceName']),
    );
    if (!mounted) return;
    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
      GoogleMap(

        mapType:_defaultMapType,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
        circles: _circles,
        onTap: (point){
          if(_isCircle){
            setState(() {
              _circles.clear();
              _setCircles(point);
            });
          }
        },
      ),
        floatingActionButton:SpeedDial(backgroundColor:Colors.lightGreen.shade700.withOpacity(0.50),animatedIcon:AnimatedIcons.list_view,
    children: [
    SpeedDialChild(backgroundColor:Colors.amberAccent.shade700,
    child: Icon(Icons.location_searching),
    label: "current location",
    onTap: ()=>_currentLocation()),
    SpeedDialChild(backgroundColor:Colors.amberAccent.shade700,
    child: Icon(Icons.map),
    label: "Normal Map",
    onTap: ()=>_changeMapType()
    ),
    SpeedDialChild(backgroundColor:Colors.amberAccent.shade700,
    child: Icon(Icons.map),
    label: "Satellite Map",
    onTap: ()=>_changeMapType2()
    ),
    SpeedDialChild(backgroundColor:Colors.amberAccent.shade700,
    child: Icon(Icons.check_circle),
    label: "Circle",
    onTap: () {
    _isCircle = true;
    radius = 50;
    return radius = 80.0;
    }
//             showDialog(context: context,
//           child: AlertDialog(backgroundColor: Colors.grey[900],
//           title: Text("Choose the radius (M)",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), ),
//             content: Padding(
//               padding: EdgeInsets.all(8),
//               child: Material(color: Colors.black,
//               child: TextField(style: TextStyle(fontSize: 16,color:Colors.white ),
//                 decoration: InputDecoration(icon: Icon(Icons.zoom_out_map),
//                 hintText: 'Ex: 100',suffixText: 'Meters',),
//                 keyboardType: TextInputType.numberWithOptions(),
//                 onChanged: (input)  {
//                 setState(() {
//                   radius=double.parse(input);  });
//                 },),)),
//
//
//           actions: <Widget>[
//             FlatButton(  onPressed: ()=>Navigator.pop(context),
//             child: Text('OK',style: TextStyle(fontWeight: FontWeight.bold),
//             )),],));},


    ),
    ],) ,

      );
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }
  
}

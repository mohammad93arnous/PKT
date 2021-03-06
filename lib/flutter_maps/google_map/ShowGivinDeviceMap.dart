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
import '../../main.dart';
String key = "AIzaSyD2OiBYq57wAfvwboGtwwGk6xqTHNKLceY";

class ShowGivenDeviceMap extends StatefulWidget {
  ShowGivenDeviceMap({this.uID, this.deviceID});

  @override
  _ShowGivenDeviceMapState createState() => _ShowGivenDeviceMapState();
  String uID;
  String deviceID;
}

class _ShowGivenDeviceMapState extends State<ShowGivenDeviceMap> {
  final Firestore _database = Firestore.instance;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor pinLocationIcon;
  DocumentSnapshot fbData;

  Set<Circle>_circles=HashSet<Circle>();
  int _circleIdCounter=1;
  bool _isCircle=false;
  @override
  void initState() {
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
        ImageConfiguration(devicePixelRatio: 1.0), 'assets/map-marker.png');
  }

  MapType _defaultMapType = MapType.normal;

  void _changeMapTypeToNormal() {
    if (!mounted)
      return; //It is an error to call setState unless mounted is true.
    setState(() {
      _defaultMapType =
          _defaultMapType == MapType.normal ? MapType.normal : MapType.normal;
    });
  }

  void _changeMapTypeToSatellite() {
    if (!mounted)
      return; //It is an error to call setState unless mounted is true.
    setState(() {
      _defaultMapType = _defaultMapType == MapType.satellite
          ? MapType.satellite
          : MapType.satellite;
    });
  }

  void _setCircles(LatLng point){
    final String circleIdVal= 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    _circles.add(
      Circle(
        circleId: CircleId(circleIdVal),
        center: point,
        radius: radius,
        fillColor: Colors.redAccent.withOpacity(0.5),
        strokeWidth: 3,
        strokeColor: Colors.redAccent
      )
    );
  }

  crearmarcadores() async {
    Stream<DocumentSnapshot> deviceData = Firestore.instance
        .collection('Devices')
        .document(widget.deviceID)
        .snapshots();
    deviceData.listen((DocumentSnapshot devData) {
      if (devData.data.isNotEmpty) {
        setState(() {
          fbData=devData;
        });
        initMarker(devData.data, devData.data.length.toString());
      }
    });
  }

  void initMarker(lugar, lugaresid) {
    var markerIdVal = lugaresid;
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      icon: pinLocationIcon,
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
      body: GoogleMap(
        mapType: _defaultMapType,
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
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
        animatedIcon: AnimatedIcons.list_view,
        children: [
          SpeedDialChild(
              backgroundColor: Colors.amberAccent.shade700,
              child: Icon(Icons.location_searching),
              label: "current location",
              onTap: () => _currentLocation()),
          SpeedDialChild(
              backgroundColor: Colors.amberAccent.shade700,
              child: Icon(Icons.map),
              label: "Normal Map",
              onTap: () => _changeMapTypeToNormal()),
          SpeedDialChild(
              backgroundColor: Colors.amberAccent.shade700,
              child: Icon(Icons.map),
              label: "Satellite Map",
              onTap: () => _changeMapTypeToSatellite()),
          SpeedDialChild(
              backgroundColor: Colors.amberAccent.shade700,
              child: Icon(Icons.add_circle_outline, color: Colors.green),
              label: "Add Circle",
              onTap: () {
                _isCircle=true;
                return showDialog(
                  context: context,
                  child: AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: Text('Choose the radius (m)',style: TextStyle(color: Colors.white),),
                    content: Padding(padding: EdgeInsets.all(8),
                    child: Material(
                      color: Colors.black,
                      child: TextField(
                        style: TextStyle(fontSize: 16,color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ex: 100',suffixText: 'meters',
                        ),
                        keyboardType: TextInputType.numberWithOptions(),
                        onChanged: (input){
                          setState(() {
                            radius=double.parse(input);
                          });
                        },
                      ),
                    ),
                    ),actions: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('OK',style: TextStyle(fontWeight: FontWeight.bold),),
                      )
                  ],
                  )
                );
//                setState(() {
//                  radius = radius + 10;
//                });
//                crearmarcadores();
//                print(radius.toString());
              }),
        ],
      ),
    );
  }

  void _currentLocation() async {
    //taking the current location of the user's android device .
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

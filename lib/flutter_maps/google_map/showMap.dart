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
class _ShowMapState extends State<ShowMap> {
  final Firestore _database = Firestore.instance;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  BitmapDescriptor pinLocationIcon;
  QuerySnapshot fbData;
  double radius=80.0;

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
    Stream<QuerySnapshot> deviceData = Firestore.instance.collection('Devices')
        .where('UID',isEqualTo: widget.uID).snapshots();
    deviceData.listen((QuerySnapshot devData){
      if(devData.documents.isNotEmpty){
        setState(() {
          clientsToggle = true;
        });
        for(int i= 0; i < devData.documents.length; i++) {
          initMarker(devData.documents[i].data, devData.documents[i].documentID);

        }
      }
    });
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
    var circleIdVal=lugaresid;
    final CircleId circleId = CircleId(circleIdVal);
  final Circle circle=Circle(
        circleId: circleId,
        center: LatLng(lugar['Location'].latitude, lugar['Location'].longitude),
        fillColor: Colors.redAccent.withOpacity(0.5),
        strokeWidth: 3,
        strokeColor: Colors.redAccent,
        radius: radius
    );
    if (!mounted) return;
    setState(() {
      // adding a new marker to map
      circles[circleId] = circle;
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
        circles: Set<Circle>.of(circles.values),
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

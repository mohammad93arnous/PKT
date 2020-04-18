import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

String key = "AIzaSyD2OiBYq57wAfvwboGtwwGk6xqTHNKLceY";

//'pk.eyJ1IjoiaWdhdXJhYiIsImEiOiJjazFhOWlkN2QwYzA5M2RyNWFvenYzOTV0In0.lzjuSBZC6LcOy_oRENLKCg',
class ShowGivenDeviceMap extends StatefulWidget {
  @override
  _ShowGivenDeviceMapState createState() => _ShowGivenDeviceMapState();
}
// Dependanceies
//google_maps_flutter: ^0.0.3+3
//geoflutterfire: ^2.1.0
//location: ^2.5.3
class _ShowGivenDeviceMapState extends State<ShowGivenDeviceMap> {
  final Firestore _database = Firestore.instance;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState(){
    crearmarcadores();
    super.initState();
  }

  crearmarcadores() async{
    await _database.collection('Devices')
        .getDocuments().then((docs) {
      if(docs.documents.isNotEmpty){
        for(int i= 0; i < docs.documents.length; i++) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }
  void initMarker(lugar, lugaresid) {
    var markerIdVal = lugaresid;
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lugar['Location'].latitude, lugar['Location'].longitude),
      infoWindow: InfoWindow(title: lugar['DeviceName']),
    );

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
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _currentLocation,
        label: Text('Your Location'),
        icon: Icon(Icons.location_on),
      ),
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

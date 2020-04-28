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

String key = "AIzaSyD2OiBYq57wAfvwboGtwwGk6xqTHNKLceY";//the API key to active the google services which activating google map

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

  bool clientsToggle=false;
  GoogleMapController mapController;
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
    if (!mounted) return;//It is an error to call setState unless mounted is true.
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal ? MapType.normal : MapType.normal;
    });
  }

  void _changeMapType2() {
    if (!mounted) return;//It is an error to call setState unless mounted is true.
    setState(() {
      _defaultMapType = _defaultMapType == MapType.satellite ? MapType.satellite : MapType.satellite;
    });
  }
  crearmarcadores() async{//this function will fetch the data from firebase and chick in the Devices collection and then take the information about how many devices are there
    //and then will create marker with a circle around it .
    Stream<QuerySnapshot> deviceData = Firestore.instance.collection('Devices')
        .where('UID',isEqualTo: widget.uID).snapshots();
    deviceData.listen((QuerySnapshot devData){
      if(devData.documents.isNotEmpty){//chick if the collection of the device and the data we need is empty or not
        if (!mounted) return;//It is an error to call setState unless mounted is true.
        setState(() {
          clientsToggle = true;
          fbData=devData;
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
//    var circleIdVal=lugaresid;
//    final CircleId circleId = CircleId(circleIdVal);
//    final Circle circle=Circle(
//        circleId: circleId,
//        center: LatLng(lugar['Location'].latitude, lugar['Location'].longitude),
//        fillColor: Colors.redAccent.withOpacity(0.5),
//        strokeWidth: 3,
//        strokeColor: Colors.redAccent,
//        radius: radius
//
//    );
//    if (!mounted) return;
//    setState(() {
//      // adding a new marker to map
//      circles[circleId] = circle;
//    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(//seeting the camera position
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:MapBody(context),
      //making a small button that when pressed will view a list that contain some small buttons .
      floatingActionButton:SpeedDial(
        backgroundColor:Colors.lightGreen.shade700.withOpacity(0.50),
        animatedIcon:AnimatedIcons.list_view,
        marginRight: 10,
        marginBottom: 90,// Scale of height
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
              child: Icon(Icons.add_circle_outline,color: Colors.green),
              label: "Increse Circle",
              onTap: (){
                if (!mounted) return;
            setState(() {
              radius=radius+5;
            });
            crearmarcadores();
                print(radius.toString());
              }
          ),
          SpeedDialChild(backgroundColor:Colors.amberAccent.shade700,
              child: Icon(Icons.remove_circle_outline,color: Colors.red,),
              label: "Decrese Circle",
              onTap: (){
                if (!mounted) return;
            setState(() {
              radius=radius-5;
            });
            crearmarcadores();
                print(radius.toString());
              }
          ),
        ],) ,
    );
  }
  Widget MapBody(BuildContext context){//the widget that will hold the map
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.black,
              child: GoogleMap(//calling the map from the google map package
                mapType:_defaultMapType,//calling the default map type that will allow the user change between map type
                initialCameraPosition: _kGooglePlex,//calling the camera postion that made up before
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                markers: Set<Marker>.of(markers.values),//set the markers on the map and its mean the number of the wearable devices that have been registered.
                circles: Set<Circle>.of(circles.values),//make a circle around the device.
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height-95.0,// Card Position
              left: 10.0,
              child: Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width,
                child:clientsToggle ?
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(8.0),
                  itemCount: fbData.documents.length,
                  itemBuilder: (context,i){
                    return Padding(
                      padding: EdgeInsets.only(left: 2.0,top: 10.0),
                      child: InkWell(
                        onTap: (){
                          zoomInTarget(
                              fbData.documents[i].data['Location'].latitude,
                              fbData.documents[i].data['Location'].longitude
                          );
                        },
                        child: Container(
                          height: 100.0,
                          width: 125.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.lightGreen.shade700.withOpacity(0.50),
                          ),
                          child: Center(
                            child: Text(fbData.documents[i].data['DeviceName']),
                          ),
                        ),
                      ),
                    );
                  },
                ):Container(height: 1.0,width: 1.0,),
              ),
            )
          ],
        )
      ],
    );
  }

  zoomInTarget(deviceLat,deviceLong) async {//a method that will zoom when the target is choosed
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                deviceLat,
                deviceLong
            ),
            zoom: 16.0,
            bearing: 80.0,
            tilt: 30.0
        ),
    ));
  }

  void _currentLocation() async {//taking the current location of the user's android device .
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

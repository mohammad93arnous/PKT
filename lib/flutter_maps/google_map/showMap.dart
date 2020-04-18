import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

String key = "AIzaSyD2OiBYq57wAfvwboGtwwGk6xqTHNKLceY";

class ShowMap extends StatefulWidget {
  @override
  _ShowMapState createState() => _ShowMapState();
}
class _ShowMapState extends State<ShowMap> {

  StreamSubscription _locationSubscription; //Location Values as Sub
  Location _locationTracker = Location(); // Location Updater Per Seconds Variable of type location that hold Lat and Long
  Marker marker; // Marker that mark the location (car icon)
  Circle circle; // Circle Radius
  GoogleMapController _controller; // Google Map Controller for controlling the drag, zoom and unzoom.
  static double Lat=26.455234;
  static double Long=50.104569;
//  List<QuerySnapshot> _ListAllDevices;
 static LatLng _center=const LatLng(26.455234, 50.104569);
  @override
  void initState() { // First Load User Location
    getCurrentLocation();// Calling Get Location Function
    super.initState();
  }

  // This final attribute if for the initial values,
  // هذي فقط قييم البدايه عشان ما يطلع ايرور لين يجيب موقع الجهاز
  static final CameraPosition initialLocation = CameraPosition(
     target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // Getting Marker Assets (pointer).
  //عشان يجيب علامة الموقع الهي صورة السيارة حاليا
  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/images/placeholder1.png");
    return byteData.buffer.asUint8List();
  }

  // Setting the values of marker and circle with its attributes.
  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude); // latitude and longitude values
    this.setState(() { // setting values
      marker = Marker( // Marker Object
          markerId: MarkerId("Main Device"), // Marker id in case of there is multiple markers at the same time.
          position: latlng,// its position
          rotation: newLocalData.heading, // rotation if the front way of the object.
          draggable: true, // bool value to able the user to drag or move the map in case of FALSE no draggable.
          zIndex: 2,// Index of each marker in case of there is more than one at the same location.
          flat: true,
          anchor: Offset(0.5, 0.5), // ما عرفت كيف اكتبها بالانجليزي, ذي موقع السيارة في الدائرة انا حاطيها في نص الدائرة
          icon: BitmapDescriptor.fromBytes(imageData));// getting car icon

      circle = Circle(// Circle Object
          circleId: CircleId("Device"), // Circle id in case of there is multiple Circle at the same time.
          radius: 25, // Radius of the circle (how big is it)
          zIndex: 1,// Index of each Circle in case of there is more than one at the same location.
          visible: true, // Bool to show the Circle or not
          strokeWidth: 2, // هذي حواف الدائرة
          strokeColor: Colors.red, // لون الحواف
          center: latlng, // Value of the Circle
          fillColor: Colors.lightGreen.shade700.withOpacity(0.50));// Color inside the Circle
    });
  }

  void getCurrentLocation() async { // Getting Location
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      updateMarkerAndCircle(location, imageData);
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                  new CameraPosition(
                      bearing: 192.8334901395799,
                      target: LatLng(
                          newLocalData.latitude,
                          newLocalData.longitude
                      ),
                      tilt: 0,
                      zoom: 18.00
                  )
              ));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) { // Handle if the user deny the permission
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {// Dispose if the internet lost
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }
  MapType _defaultMapType = MapType.normal;

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal ? MapType.normal : MapType.normal;
    });
  }

  void _changeMapType2() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.satellite ? MapType.satellite : MapType.satellite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),leading:IconButton(
        icon: Icon(Icons.arrow_back),onPressed: (){
       Navigator.of(context).pop();
    },
      ),
        title: Center(child: Text('Live Location',style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 30.0,
            color: Colors.amberAccent.shade700),
           )),
      ),



      body: Stack ( children: <Widget>[GoogleMap(
        // Google Map object

        mapType: _defaultMapType,// Map type satellite or normal ....
        initialCameraPosition: initialLocation, // initial camera until getting user location
        markers: Set.of((marker != null) ? [marker,kid] : []), // marker if null hide
        circles: Set.of((circle != null) ? [circle] : []), // circles if null hide
        onMapCreated: (GoogleMapController controller) { // Map Launch
          _controller = controller; // Controller of google map to be able to drag , zoom and unZoom
        },

      ),






//        Container(
//          margin: EdgeInsets.only(top: 5,left: 100),
//          alignment: Alignment.topRight,
//          child: Column(
//              children: <Widget>[
//                FloatingActionButton(
//                    child: Icon(Icons.layers),
//                    elevation: 5,
//                    backgroundColor: Colors.blue,
//                    onPressed: () {
//                      _changeMapType();
//                      print('Changing the Map Type');
//                    }),
//              ]),
//        ),
      ]),
      floatingActionButton:SpeedDial(backgroundColor:Colors.lightGreen.shade700.withOpacity(0.50),animatedIcon:AnimatedIcons.list_view,
      children: [
        SpeedDialChild(backgroundColor:Colors.amberAccent.shade700,
            child: Icon(Icons.location_searching),
            label: "current location",
            onTap: ()=>getCurrentLocation()),
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



//      floatingActionButton: FloatingActionButton(heroTag: "btn1", // Button to get the last location or to update the location in case of loose internet
//          child: Icon(Icons.location_searching),
//          onPressed: () {
//            getCurrentLocation();// Calling Get Location Function
//          }),
    );
  }
  Marker kid=Marker(markerId: MarkerId("child"),position:_center ,infoWindow: InfoWindow(title: "Moh",snippet: ""),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta));

  List<Marker>lisiOfMarker=<Marker>[


  ];

}//.............Done ...................



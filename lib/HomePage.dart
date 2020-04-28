import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pktapp/userProfile.dart';
import 'AUTH/Auth.dart';
import 'RegistertionAccount.dart';
import 'SnackBar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; //new
import 'dart:async';
import 'models/CustomText.dart'; //new

//******************* Importing all needed packages *****************************
class HomePage extends StatefulWidget {
  HomePage({this.accountName, this.email, this.deviceName});

  @override
  State<StatefulWidget> createState() => new _HomePageState();
  String accountName;
  String email;
  String deviceName;
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();//Firebase Messaging is to make notifications and send it to the android device
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  TextEditingController forgetPasswordEmailController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var mymap = {};
  var title = '';
  var body = {};
  var mytoken = '';
  String forgetPassEmail;

  bool _obscureTextLogin = true;
  Auth auth = new Auth();
  String email;
  String password;
  String userId = "";
  FirebaseUser user;

  @override
  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    firebaseMessaging.configure(//in this method onLaunch, onResume and on message just to make sure the notification will be send in any situations.
        onLaunch: (Map<String, dynamic> msg) {
      print("onLaunch called ${(msg)}");
    }, onResume: (Map<String, dynamic> msg) {
      print("onResume called ${(msg)}");
    }, onMessage: (Map<String, dynamic> msg) {
      print("onResume called ${(msg)}");
      mymap = msg;
      showNotification(msg);
    });

    firebaseMessaging.requestNotificationPermissions(//making a  request for a permission to allow the app for notifications
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print("onIosSettingsRegistered");
    });
    firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
        "1", "channelName", "channelDescription");
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);

    msg.forEach((k, v) {
      title = k;
      body = v;
      setState(() {});
    });

    await flutterLocalNotificationsPlugin.show(
        0, "${msg.keys}", "${msg.values}", platform);
  }

  update(String token) { //just taking the token number of the user's android device and upload it to the database ,it will help in the notification method.
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/$token').set({"token": token});
    mytoken = token;
    setState(() {});
  }

  Future onLogIn() async {//ON login method
    try {//and starting with try nad catch to avoid an error and it will chick from the firebase data base if the user is registered .
      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (user.uid.length > 0 && user.uid != null) {
        if (user.uid == null) {

        } else {
          setState(() {
            userId = user.uid;
          });
          //Main Secreen
        }
      }
    } catch (e) {
      snackError('Email or Password Invalid', context);//when there is an error the catch will notify the user there is an error with your email ro password.
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {//starting with the widget of the page
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor of the page : Color.fromARGB(255, 255, 10, 10),
        title: Text(
          "Parental Kids Tracker", //choosing the name of the App and the styling it .
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Colors.amberAccent.shade700),
        ),
        centerTitle: true,

        backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
      ),


      body: SingleChildScrollView(//starting of the body
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/images/family.png'),//calling an image from an assets file
              ),
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-z 0-9 -_. @]")),
                ],
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    hintText: "Enter Your sEmail ",
                    prefixIcon: Icon(Icons.email)),
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: TextField(
                textAlign: TextAlign.start,
                // vTextAlignment,
                obscureText: _obscureTextLogin,
                style: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 16.0,
                    color: Colors.black),
                //Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 10, color: Colors.green),
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                      borderSide: BorderSide(width: 0.5, color: Colors.green)),
                  hintText: "Password",
                  hintStyle:
                      TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                  suffixIcon: GestureDetector(
                    onTap: _toggleLogin,
                    child: Icon(
                      _obscureTextLogin
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 20.0,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      onLogIn().whenComplete(() {
                        if (user == null) {
                          return null;
                        } else {}
                        if (user.uid != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => UserPof(
                                    uID: userId,
                                  )));
                        } else {
                          return null;
                        }
                        print(userId);
                      });
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RegistertionAccount()));
                      // Calling SnackBar with Error Text
                    },
                    child: Text(
                      'Register',
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
            SizedBox(
              height: 35,
            ),
            InkWell(
              onTap: () {
                showForgetPassBottomSheet(context);
              },
              child: Text('Forgot Password ?'),
            )
          ],
        ),
      ),
    );
  }

  showForgetPassBottomSheet(BuildContext pnContext) {//Here is the function of forgetting password that will ask the user for the email that the user
    //wants to create a new password and send to the user an email has a link to change the password with a new one .
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(//The container which will hold the widget inside it
        height: 375,
        decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.7),
            border: Border.all(color: Colors.white54, width: 1),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      Icons.vpn_key,
                      color: Colors.amber,
                      size: 100,
                    )
                ),
              ),
              flex: 5,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Please enter Your Email',
                      style: CustomTextStyle.textFormFieldMedium
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1,
                      ),
                      controller: forgetPasswordEmailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        labelText: '********@Provider.com',
                        labelStyle: TextStyle(color: Colors.white),
                        focusColor: Colors.green,
                        hoverColor: Colors.green,
                        isDense: true,
                        counterStyle: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      onChanged: (value) {
                        if (value == null) {
                          snackError('Please Enter Valid Email', context);
                        } else {
                          setState(() {
                            forgetPassEmail = value;
                          });
                        }//else
                      },//on changed
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (forgetPassEmail == null) {
                          snackError('Please Enter Valid Email', context);
                          showForgetPassBottomSheet(pnContext);
                        } else {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: forgetPassEmail);
                          Navigator.of(pnContext).pop();
                        }
                      },//on Pressed
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Send Reset Email",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(color: Colors.white),
                      ),
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2);
  }//The end of the forgetting password function

} //********************************The End of the Class  ********************************

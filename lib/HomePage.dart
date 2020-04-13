import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pktapp/DeviceInfo.dart';
import 'package:pktapp/userProfile.dart';
import 'AUTH/Auth.dart';
import 'SnackBar.dart';

class HomePage extends StatefulWidget {
  HomePage({this.accountName, this.email, this.deviceName});

  @override
  State<StatefulWidget> createState() => new _HomePageState();
  String accountName;
  String email;
  String deviceName;
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey(); // Scaffold Key

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
  }

  Future onLogIn() async {
    try {
      user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (user.uid.length > 0 && user.uid != null) {
        if (user.uid == null) {
          print('1');
        } else {
          setState(() {
            userId = user.uid;
          });
          //Main Secreen
        }
      }
    } catch (e) {
      snackError('Email or Password Invalid',context);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 255, 10, 10),
        title: Text(
          "Parental Kids Tracker",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.amberAccent.shade700),
        ),
        centerTitle: true,

        backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/images/family.png'),
              ),
              height: 200,
            ),
//           InkWell(
//             child: Text("Add A Device", style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontSize: 30.0,
//                 color: Colors.indigo)), onTap: () => debugPrint("Well Done"),
//           ),
            //CustomButton(),

//            Center(
//              child: Padding(
//                padding: const EdgeInsets.all(30.0),
//                child: Text(
//                  "Welcome To PKT APP",
//                  // textDirection: TextDirection.ltr,
//                  style: TextStyle(
//                      color: Colors.blue.withOpacity(0.90),
//                      fontWeight: FontWeight.bold,
//                      fontSize: 25.5,
//                      fontStyle: FontStyle.italic),
//                ),
//              ),
//            ),

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
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(2), borderSide: BorderSide(width: 2, color: Colors.green)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(width: 2, color: Colors.green)), hintText: "Enter Your sEmail ", prefixIcon: Icon(Icons.email)),
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
            ),
//          Padding(
//            padding: const EdgeInsets.all(20.0),
//            child: TextField(keyboardType: TextInputType.visiblePassword,decoration: InputDecoration(hintText: "Input password",prefixIcon: Icon(Icons.lock)),),
//          ),
            //Password Field
            Padding(
              padding: EdgeInsets.all(30),
              child: TextField(
                textAlign: TextAlign.start, // vTextAlignment,
                obscureText: _obscureTextLogin,
                style: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 16.0, color: Colors.black), //Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 10, color: Colors.green),
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(1.0), borderSide: BorderSide(width: 0.5, color: Colors.green)),
                  hintText: "Password",
                  hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                  suffixIcon: GestureDetector(
                    onTap: _toggleLogin,
                    child: Icon(
                      _obscureTextLogin ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
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
                      print("Test Button");
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DeviceInfo()));
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
          ],
        ),
      ),
    );
  }
}

//
//class CustomButton extends StatelessWidget{
//@override
//  Widget build(BuildContext context) {
//
//    return GestureDetector(
//      onTap: (){
//        final snackBar=SnackBar(content: Text("Device Has been Added"),);
//        Scaffold.of(context).showSnackBar(snackBar);
//
//      },
//child: Container(
//
//  padding: EdgeInsets.all(20),
//  decoration: BoxDecoration(
//    color:Colors.black,
//    borderRadius: BorderRadius.circular(15)
//  ),
//  child: Text("Add New Device"),
//),
//    );
//  }
//
//}

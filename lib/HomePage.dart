import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pktapp/DeviceInfo.dart';
import 'package:pktapp/userProfile.dart';
import 'AUTH/Auth.dart';
import 'SnackBar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'BillSpliter.dart';
import 'RegistertionAccount.dart';
import 'package:flutter/cupertino.dart';


import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  HomePage({this.accountName,this.email,this.deviceName});
  @override
  State<StatefulWidget> createState() => new _HomePageState();
  final String accountName;
  final String email;
  final String deviceName;
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey(); // Scaffold Key

  Auth auth = new Auth();
  String email;
  String password;
  String userId = "";
  FirebaseUser user;
  @override
  void initState() {
    super.initState();
  }

  Future onLogIn() async {
    try {
       user=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,password: password);
      if (user.uid.length > 0 && user.uid != null) {
        if(user.uid==null){
          print('1');
        }else{
          setState(() {
            userId=user.uid;
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

      // Key For calling Scaffold to show SnackBar
//      drawer: Drawer(
//        child: ListView(
//          children: <Widget>[
//            UserAccountsDrawerHeader(
//              accountName: Text("Mohammad Salah "),
//              accountEmail: Text("mohammad93arnous@gmail.com"),
//              currentAccountPicture: CircleAvatar(
//                backgroundColor:
//                    Theme.of(context).platform == TargetPlatform.iOS
//                        ? Colors.blue
//                        : Colors.white,
//                child: Text(
//                  "M",
//                  style: TextStyle(fontSize: 40.0),
//                ),
//              ),
//            ),
//            ListTile(
//                title: Text(
//                  "Profile",
//                ),
//                onTap: () {
//                  Navigator.of(context).pop();
//                  Navigator.of(context).push(MaterialPageRoute(
//                      builder: (BuildContext context) => BillSpliter()));
//                  Navigator.of(context).pop();
//                  Navigator.of(context).push(MaterialPageRoute(
//                      builder: (BuildContext context) => BillSpliter()));
//                },
//                trailing: Icon(Icons.account_box)),
//            ListTile(
//              title: Text("Live Location"),
//              trailing: Icon(Icons.location_on),
//            ),
//            ListTile(
//              title: Text("History"),
//              trailing: Icon(Icons.history),
//            ),
//
//          ],
//        ),
//      ),
backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 255, 10, 10),
        title: Text(
          "Parental Kids Tracker",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Colors.amberAccent.shade700),
        ),
        centerTitle: true,

        backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.add_to_home_screen),
//              onPressed: () => debugPrint("hello")),
//          IconButton(
//              icon: Icon(Icons.person_add),
//              onPressed: () => debugPrint("Added")),
//          IconButton(
//              icon: Icon(Icons.calendar_today),
//              onPressed: () => debugPrint("16/2/2020"))
//        ],
      ),

//      floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.indigoAccent,
//        child: Icon(Icons.person),
//        onPressed: () => debugPrint("Add A Kid"),
//      ),
//      bottomNavigationBar: BottomNavigationBar(items: [
//        BottomNavigationBarItem(
//            icon: Icon(Icons.account_box), title: Text("Account")),
//        BottomNavigationBarItem(
//            icon: Icon(Icons.gps_fixed), title: Text("GPS")),
//        BottomNavigationBarItem(
//            icon: Icon(Icons.add_box), title: Text("New Device"))
//      ]),

      body: SingleChildScrollView(
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.end,
//        crossAxisAlignment: CrossAxisAlignment.start,
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
                onChanged: (val){
                  setState(() {
                    email=val;
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

                style: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 16.0,
                    color: Colors.black), //Colors.black),
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

                ),
                onChanged: (val){
                  setState(() {
                    password=val;
                  });
                },
              ),
            ),

            RaisedButton(
              onPressed: () {
                print("Test Button");
                onLogIn().whenComplete((){
                  if(user==null){
                    return null;
                  }else{}
                  if (user.uid!=null){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            UserPof(
                              accountName: widget.accountName,
                              email: widget.email,
                              deviceName:widget.deviceName,

                            )
                    ));
                  }else{
                    return null;
                  }                  print(userId);
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
                    builder: (BuildContext context) => DeviceInfo()));
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

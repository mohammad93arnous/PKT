import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'LinkWithEmail.dart';
import 'SnackBar.dart';
import 'HomePage.dart';
//******************* Importing all needed packages for this class *****************************

class RegistertionAccount extends StatefulWidget {
  RegistertionAccount({this.deviceName, this.deviceSerial, this.result});

  @override
  State<StatefulWidget> createState() => new _RegistertionAccountState();
  String deviceName;
  String deviceSerial;
  String result;
}

class _RegistertionAccountState extends State<RegistertionAccount> {
  final _scaffoldKey = GlobalKey(); // Scaffold Key
  bool _obscureTextLogin = true;
  bool _obscureTextRePassLogin = true;
  TextEditingController loginPasswordController = new TextEditingController();//creating a controller for the password
  TextEditingController loginRePasswordController = new TextEditingController();//creating a controller for the re password
  TextEditingController loginAccountName = new TextEditingController();//creating a controller for the name

  bool passValidated = false;
  bool userNameValidated = false;

  String accountName;
  String _loginPassword;
  String loginRePassword;

  FirebaseAuth auth; //calling the firebase authentication

  @override
  void initState() {
    super.initState();
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleRePassLogin() {
    setState(() {
      _obscureTextRePassLogin = !_obscureTextRePassLogin;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  accountNameValidation() {//function that has some  rules to choose the name
    if (loginAccountName.text == null || accountName.length <= 3) {
      snackError('Name Must Contain Text Only', context);
      userNameValidated = false;
    } else if (loginAccountName.text.contains('-,*,/,+,=,(,),%,@,!', 0) ==
        true) {
      snackError('Name Must Contain Text Only', context);
      userNameValidated = false;
    } else {
      setState(() {
        userNameValidated = true;
      });
    }
  }

  passwordValidation() {//function that has some  rules to choose the password and chick between the password and re password if they match or not
    if (loginPasswordController.text != null &&
        loginPasswordController.text.length < 4) {
      snackError('Password must be more than 4', context);
    } else if (loginRePasswordController.text != null &&
        loginRePasswordController.text.length < 4) {
      snackError('Password must be more than 4', context);
    } else if (loginPasswordController.text != loginRePasswordController.text &&
        loginRePasswordController.text != loginPasswordController.text) {
      snackError('Password is not matched', context);
    } else {
      setState(() {
        passValidated = true;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreen.shade700.withOpacity(0.50),
        title: Text(
          "Account",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Colors.amberAccent.shade700),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView( //body
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z 0-9 _-]"))
                ],
                controller: loginAccountName,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    hintText: "Enter Account Name",
                    prefixIcon: Icon(Icons.account_circle)),
                onChanged: (val) {
                  setState(() {
                    accountName = val;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: TextField(
                textAlign: TextAlign.start,
                // vTextAlignment,
                controller: loginPasswordController,
                obscureText: _obscureTextLogin,
                style: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 16.0,
                    color: Colors.black),
                //Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 10, color: Colors.green),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
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
                    _loginPassword = val;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: TextField(
                textAlign: TextAlign.start,
                // vTextAlignment,
                controller: loginRePasswordController,
                obscureText: _obscureTextRePassLogin,
                style: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 16.0,
                    color: Colors.black),
                //Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 10, color: Colors.green),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(width: 0.5, color: Colors.green)),
                  hintText: "Re-Password",
                  hintStyle:
                      TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                  suffixIcon: GestureDetector(
                    onTap: _toggleRePassLogin,
                    child: Icon(
                      _obscureTextRePassLogin
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 20.0,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    loginRePassword = val;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.white70,
                  ),
                  RaisedButton(
                    onPressed: () {
                      validatingBeforeNavigate();
                    },
                    child: Text(
                      'Next',
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

  // ignore: missing_return
  Future validatingBeforeNavigate() {//is a function that chick the information that the user input and if the information are true it will continue to the next page.
    print(userNameValidated.toString());
    print(passValidated.toString());
    if (accountName == null) {
      return snackError('Account Name cannot be empty', context);
    } else if (loginAccountName.text.contains('- * / + = ( ) % @ !', 0) ==
        true) {
      return snackError('Name Must Contain Text Only', context);
    } else if (_loginPassword == null) {
      snackError('Password cannot be empty', context);
      passValidated = false; //new
    } else if (loginRePassword == null) {
      snackError('Re-Password cannot be empty', context);
      passValidated = false; //new
    } else if (loginPasswordController.text != loginRePasswordController.text &&
        loginRePasswordController.text != loginPasswordController.text) {
      snackError('Password is not matched', context);
    } else {
      accountNameValidation();
      passwordValidation();
      if (userNameValidated == false && passValidated == false) {
        setState(() {
          userNameValidated = false;
          passValidated = false;
        });
      } else {
        print(userNameValidated.toString());
        print(passValidated.toString());
        if (userNameValidated == false && passValidated == false) {
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LinkWithEmail(
                    accountName: accountName,
                    password: _loginPassword,
                  )));
        }
      }
    }
  }
} //********************************The End of the Class  ********************************


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flushbar/flushbar.dart';

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

snackError(String text,BuildContext context){
  return Flushbar(
    title:'Error',
    message:'$text',
    borderColor: Colors.white,//Snack Border Color
    duration:Duration(seconds: 5),// Time To Close
    flushbarPosition: FlushbarPosition.TOP,// Postion Of the snackbar
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.easeOut,
    forwardAnimationCurve: Curves.easeIn,
    margin: EdgeInsets.all(8),
    borderRadius: 8,// حواف المربع
    backgroundColor: Colors.red, //Snack Color,
    boxShadows: [BoxShadow(
        color: Color(0xFFec2e2e), //Color(0xFFec2e2e),
        offset: Offset(0.0, 2.0),
        blurRadius: 3.0)],
    backgroundGradient: LinearGradient(
        colors: [Color(0xFFec2e2e), //, Color(0xFFec2e2e)
          Color(0xFFec2e2e)]),
    isDismissible: false,
    icon: Icon(
      Icons.center_focus_weak,// Icon Type
      color: Colors.white, // Icon Color
    ),
  )..show(context);
}

snackWarning(String text,BuildContext context){
  return Flushbar(
    borderColor: colorPallet('vSnackWarningborderColor'),
    titleText: Text('   $SnackBarTitleWarning',style: TextStyle(color: colorPallet('vSnackWarningtitleTextColor'),fontSize: 18)),
    messageText:Text('   '+ '$text',style: TextStyle(color: colorPallet('vSnackWarningmessageTextColor')),),
    duration:Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.easeOut,
    forwardAnimationCurve: Curves.easeIn,
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    backgroundColor: colorPallet('vSnackWarningbackgroundColor'), //Color(0xFFbf6e0b),
    boxShadows: [BoxShadow(
        color: colorPallet('vSnackWarningboxShadowsColor'), //Color(0xFFbf6e0b),
        offset: Offset(0.0, 2.0),
        blurRadius: 3.0)],
    backgroundGradient: LinearGradient(
        colors: [colorPallet('vSnackWarningbackgroundGradient'),
          colorPallet('vSnackWarningbackgroundGradient')]),
    isDismissible: false,
    icon: Icon(
      Icons.warning,
      color: colorPallet('vSnackWarningIcon'),size: 35,
    ),
  )..show(context);
}

class SnackBarTitleWarning {
}

snackRemarks(String text,BuildContext context){
  // ignore: non_constant_identifier_names
  var SnackBarTitleMessagePop;
  return Flushbar(
    borderColor: colorPallet('vSnackWarningbackgroundColor'),
    titleText: Text('   $SnackBarTitleMessagePop' ,textAlign: TextAlign.center, style: TextStyle(color: colorPallet('vSnackWarningtitleTextColor'),fontSize: 20)),
    messageText:Text('$text', textAlign: TextAlign.center, style: TextStyle(fontSize:25, color: colorPallet('vSnackOKmessageTextColor')),),
    duration:Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.easeOut,
    forwardAnimationCurve: Curves.easeIn,
    margin: EdgeInsets.all(2),
    borderRadius: 12,
    backgroundColor: colorPallet('vSnackWarningbackgroundColor'), //Color(0xFFbf6e0b),
    boxShadows: [BoxShadow(
        color: colorPallet('vSnackWarningbackgroundColor'), //Color(0xFFbf6e0b),
        offset: Offset(0.0, 2.0),
        blurRadius: 3.0)],
    backgroundGradient: LinearGradient(
        colors: [ colorPallet('vScaffoldbackground'),
          colorPallet('vSnackWarningbackgroundGradient')]),
    isDismissible: false,
    icon: Icon(
      Icons.thumb_up,
      color: colorPallet('vIcon'),size: 40,
    ),
  )..show(context);
}

colorPallet(String s) {
}
snackOK(String title,String text,BuildContext context){
  return Flushbar(
    borderColor: colorPallet('vSnackOKborderColor'),
    //title:'$title',
    //message:'$text',
    titleText: Text('$title',style: TextStyle(color: colorPallet('vSnackOKtitleTextColor'),fontSize: 18)),
    messageText:Text('$text',style: TextStyle(color: colorPallet('vSnackOKmessageTextColor')),),
    duration:Duration(seconds: 10),
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.easeOut,
    forwardAnimationCurve: Curves.easeIn,
    margin: EdgeInsets.all(8),
    borderRadius: 15,
    backgroundColor: colorPallet('vSnackOKbackgroundColor'), //Color(0xFFbf6e0b), Colors.amber,
    boxShadows: [BoxShadow(
        color:  colorPallet('vSnackOKboxShadowsColor'), //Color(0xFFbf6e0b), Colors.amber,
        offset: Offset(0.0, 2.0),
        blurRadius: 3.0)],
    backgroundGradient: LinearGradient(
        colors: [colorPallet('vSnackOLbackgroundGradient'), // amber
          colorPallet('vSnackOKbackgroundGradient')]),
    isDismissible: true,
    icon: Icon(
      Icons.center_focus_weak,
      color: colorPallet('vSnackOKIcon'), //Colors.white,
    ),
    mainButton:FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "OK",
        style: TextStyle(color: colorPallet('vSnackOKIcon'),fontSize: 25),
      ),
    ),
  )..show(context);
}

snackMessage(String text,BuildContext context){
  // ignore: non_constant_identifier_names
  var SnackBarTitleMessage;
  return Flushbar(
    borderColor: colorPallet('vSnackMessageborderColor'),
    titleText: Text('   $SnackBarTitleMessage ',style: TextStyle(color: colorPallet('vSnackMessagetitleTextColor'),fontSize: 18)),  //white
    messageText:Text('$text'+ '$text',style: TextStyle(color: colorPallet('vSnackMessagemessageTextColor')),),
    duration:Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.easeOut,
    forwardAnimationCurve: Curves.easeIn,
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    backgroundColor: colorPallet('vSnackMessagebackgroundColor'), //Color(0xFFbf6e0b),
    boxShadows: [BoxShadow(
        color: colorPallet('vSnackMessageboxShadowsColor'), //Color(0xFFbf6e0b),
        offset: Offset(0.0, 2.0),
        blurRadius: 3.0)],
    backgroundGradient: LinearGradient(
        colors: [colorPallet('vSnackMessagebackgroundGradient'), // Color(0xFFbf6e0b)
          colorPallet('vSnackMessagebackgroundGradient')]),
    isDismissible: false,
    icon: Icon(
      Icons.message,
      color: colorPallet('vSnackMessageIcon'),size: 35,  // amber
    ),
  )..show(context);
}
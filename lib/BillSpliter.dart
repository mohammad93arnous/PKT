//import 'package:flushbar/flushbar.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/services.dart';
//import 'package:passwordfield/passwordfield.dart';
//import 'package:email_validator/email_validator.dart';
//import 'HomePage.dart';
//import 'SnackBar.dart';
//import 'package:flushbar/flushbar_route.dart';
//
//
//class BillSpliter extends StatefulWidget {
//  @override
//  _BillSpliterState createState() => _BillSpliterState();
//}
//class _BillSpliterState extends State<BillSpliter> {
//  @override
//  int _tipPercentage = 0;
//  int _personCounter = 1;
//  double _billAmount = 0.0;
//
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
//        alignment: Alignment.center,
//        color: Colors.white10,
//        child: ListView(
//          scrollDirection: Axis.vertical,
//          padding: EdgeInsets.all(20.5),
//          children: <Widget>[
//            Container(
//                width: 150,
//                height: 150,
//                decoration: BoxDecoration(
//                    color: Colors.purpleAccent.shade100.withOpacity(0.1),
//                    borderRadius: BorderRadius.circular(15.0)),
//                child: Center(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Text(
//                        "Total Per Person",
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            fontSize: 15.0,
//                            color: Colors.purple),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(
//                          "\$ ${calculateTotalPerPerson(_billAmount, _personCounter, _tipPercentage)}",
//                          style: TextStyle(
//                              fontSize: 35.0,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.purple),
//                        ),
//                      )
//                    ],
//                  ),
//                )),
//            Container(
//              margin: EdgeInsets.only(top: 20.0),
//              padding: EdgeInsets.all(12.0),
//              decoration: BoxDecoration(
//                  color: Colors.transparent,
//                  border: Border.all(
//                      color: Colors.blueGrey.shade100,
//                      style: BorderStyle.solid),
//                  borderRadius: BorderRadius.circular(15.0)),
//              child: Column(
//                children: <Widget>[
//                  TextField(
//                    keyboardType:
//                    TextInputType.numberWithOptions(decimal: true),
//                    style: TextStyle(color: Colors.purple),
//                    decoration: InputDecoration(
//                        hintText: "Bill Amount",
//                        prefixIcon: Icon(Icons.attach_money)),
//                    onChanged: (String value) {
//                      try {
//                        _billAmount = double.parse(value);
//                      } catch (exception) {
//                        _billAmount = 0.0;
//                      }
//                    },
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text(
//                        "Split",
//                        style: TextStyle(color: Colors.grey.shade700),
//                      ),
//                      Row(
//                        children: <Widget>[
//                          InkWell(
//                            onTap: () {
//                              setState(() {
//                                if (_personCounter > 1) {
//                                  _personCounter--;
//                                } else {
//                                  //do nothing
//                                }
//                              });
//                            },
//                            child: Container(
//                              width: 40.0,
//                              height: 40.0,
//                              margin: EdgeInsets.all(10.0),
//                              decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(7.0),
//                                  color: Colors.purple.withOpacity(0.1)),
//                              child: Center(
//                                  child: Text(
//                                    "-",
//                                    style: TextStyle(
//                                        color: Colors.purple,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 17.0),
//                                  )),
//                            ),
//                          ),
//                          Text(
//                            "$_personCounter",
//                            style: TextStyle(
//                                color: Colors.purple,
//                                fontWeight: FontWeight.bold,
//                                fontSize: 17.0),
//                          ),
//                          InkWell(
//                            onTap: () {
//                              setState(() {
//                                _personCounter++;
//                              });
//                            },
//                            child: Container(
//                              width: 40,
//                              height: 40,
//                              margin: EdgeInsets.all(10.0),
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(7.0),
//                                color: Colors.purple.withOpacity(0.1),
//                              ),
//                              child: Center(
//                                child: Text(
//                                  "+",
//                                  style: TextStyle(
//                                      color: Colors.purple,
//                                      fontWeight: FontWeight.bold,
//                                      fontSize: 17.0),
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text(
//                        "Tip",
//                        style: TextStyle(color: Colors.grey.shade700),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(18.0),
//                        child: Text(
//                          " \$ ${(calculateTotalTip(_billAmount, _personCounter, _tipPercentage)).toStringAsFixed(2)}",
//                          style: TextStyle(
//                              color: Colors.purple,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 17.0),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Column(
//                    children: <Widget>[
//                      Text(
//                        "$_tipPercentage%",
//                        style: TextStyle(
//                            color: Colors.purple,
//                            fontWeight: FontWeight.bold,
//                            fontSize: 17.0),
//                      ),
//                      Slider(
//                          divisions: 10,
//                          min: 0,
//                          max: 100,
//                          activeColor: Colors.purple,
//                          inactiveColor: Colors.grey,
//                          value: _tipPercentage.toDouble(),
//                          onChanged: (double value) {
//                            setState(() {
//                              _tipPercentage = value.round();
//                            });
//                          })
//
//                    ],
//
//                  )
//                ],
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(50.0),
//              child: RaisedButton(
//                onPressed: () {
//                  Navigator.of(context).pop();
//                  Navigator.of(context).push(MaterialPageRoute(
//                      builder: (BuildContext context) => HomePage()));
//                  Navigator.of(context).pop();
//                  Navigator.of(context).push(MaterialPageRoute(
//                      builder: (BuildContext context) => HomePage()));
//                },
//                child: Text(
//                  "Home Page",
//                  style: TextStyle(color: Colors.purple, fontSize: 18),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  calculateTotalPerPerson(double billAmount, int splitBy, int tipPercentage) {
//    var totalPerPerson =
//        (calculateTotalTip(billAmount, splitBy, tipPercentage) + billAmount) /
//            splitBy;
//    return totalPerPerson.toStringAsFixed(2);
//  }
//
//  calculateTotalTip(double billAmount, int splitBy, int tipPercentage) {
//    double totalTip = 0.0;
//    if (billAmount < 0 || billAmount.toString().isEmpty || billAmount == null) {
//    } else {
//      totalTip = (billAmount * tipPercentage) / 100;
//    }
//    return totalTip;
//  }
//}
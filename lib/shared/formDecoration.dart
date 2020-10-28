import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const textInputDecoration = InputDecoration(
    hintText: 'Phone Number',
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepOrange,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepOrange,
        width: 1.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.0,
        )),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
    ),
    prefixIcon: Icon(Icons.phone,)
);


const productInputDecoration = InputDecoration(
    hintText: 'Phone Number',
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepOrange,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepOrange,
        width: 1.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.0,
        )),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
    ),
);


dualRing(){
  return Container(
    alignment: Alignment.center,
    child: SpinKitDualRing(
      color: Colors.deepOrange,
      size: 30.0,
    ),
  );
}

const modalDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10.0),
    topRight: Radius.circular(10.0),
    bottomLeft: Radius.circular(10.0),
    bottomRight: Radius.circular(10.0),
  ),
);
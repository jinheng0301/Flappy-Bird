import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

showAlert(context) {
  Alert(
    context: context,
    content: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.only(top: 20),
          child: Text(
            'G A M E  O V E R !',
          ),
        ),
      ],
    ),
    buttons: [
      DialogButton(
        color: Colors.lightBlueAccent,
        child: Text(
          'Sure!',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  ).show();
}

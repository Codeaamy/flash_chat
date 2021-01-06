

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HelperFunctions{
  showAlert(BuildContext context, AlertType alertType,  String title, String desc, String btnText, Function onpressed){
    Alert(
      context: context,
      type: alertType,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            btnText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: onpressed,
          width: 120,
        )
      ],
    ).show();
  }


  String getTimeStamp(String timeStamp){
    var stamp = int.parse(timeStamp);
    var date = DateTime.fromMillisecondsSinceEpoch(stamp).toString();
    var time = date.substring(11, 16);
    return time;
  }
}


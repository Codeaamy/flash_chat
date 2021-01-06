import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/constant.dart';
import 'package:flutter/material.dart';

Widget sendMessageCell(BuildContext context, List messageList, int index, String time){



  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.only(left:100.0, ),
    child: Bubble(
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      margin: BubbleEdges.only(top: 10),
      color: Color.fromRGBO(225, 255, 199, 1.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(messageList[index]['messageBody'].toString(), style: messageBody,),
            ),



//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [
//          Row(
//            children: [
////              Spacer(),
//              Text(messageList[index]['senderName'].toString(),style: messageName, ),
//            ],
//          ),
//          Padding(
//            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//            child: Text(messageList[index]['messageBody'].toString(), style: messageBody,),
//          ),
//          Row(
//            children: [
////              Spacer(),
////                    Text('${DateTime.fromMillisecondsSinceEpoch(messageList[index]['timeStamp'])}'),
//              Text('${time}'),
//
//            ],
//          ),
//        ],
//      ),
    ),
  );


}
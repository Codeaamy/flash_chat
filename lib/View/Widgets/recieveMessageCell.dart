import 'package:flutter/material.dart';

Widget recieveMessageCell(BuildContext context, List messageList, int index, String time){
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Container(
//          width: width * 0.7,

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(

                    children: [

                      Text(messageList[index]['senderName'].toString()),
                    ],
                  ),
                ),
                Text(messageList[index]['messageBody'].toString()),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$time'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,


            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),

              )
            ]
          ),
        ),
//        Spacer(),
//        SizedBox(width: width * 0.2,),

      ],
    ),
  );
}
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashchat/View/Widgets/recieveMessageCell.dart';
import 'package:flashchat/View/Widgets/sendMessageCell.dart';
import 'package:flashchat/View/login_view.dart';
import 'package:flashchat/constant.dart';
import 'package:flashchat/helper_functions.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String toId;
  final String toName;
  final String toIsOnline;

  ChatScreen({this.currentUserId, this.toId, this.toName, this.toIsOnline});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController =  TextEditingController();
  List<QueryDocumentSnapshot> userList = List();
  var currentUser;
  var toUser;
  final _controller = ScrollController();



  HelperFunctions _helperFunctions = HelperFunctions();

  List<QueryDocumentSnapshot> messageList = List();
  List sortedMessageList = List();


  StreamSubscription _streamSubscription ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Current user Id ${widget.currentUserId}");
    WidgetsBinding.instance.addPostFrameCallback((_){

      // Add Your Code here.
      getMessages();
      getCurrentUser();

    });

    getMessages();
    getCurrentUser();


  }

  void getCurrentUser(){
    print('Getting Current User');
    FirebaseFirestore.instance.collection('user').snapshots().listen((dataSnapshot) {
      userList = dataSnapshot.docs;
      for(var i = 0; i < userList.length; i++){
        if( userList[i]['uid'] == widget.currentUserId){
          currentUser = userList[i];
          print(currentUser['name']);

        }

        if(userList[i]['uid'] == widget.toId){
          toUser = userList[i];
          setState(() {

          });
        }
      }
    });
  }






  @override
  Widget build(BuildContext context) {

    Timer(
      Duration(milliseconds: 500),
          () => _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          )
    );
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.toName),
            toUser == null ? Text(widget.toIsOnline, style: subtitleTextStyle,) : Text(toUser['isOnline'].toString(), style: subtitleTextStyle,)
          ],
        ),
        
        actions: [
          IconButton(
            icon: Icon(Icons.logout, size: 30, color: Colors.white,),
            onPressed: (){
              FirebaseAuth.instance.signOut().whenComplete((){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView()));
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: width,
            height: height - 150,
//            color: Colors.blue,
            child: sortedMessageList.length > 0 ? ListView.builder(
              controller: _controller,
              itemCount: sortedMessageList.length,
              itemBuilder: (BuildContext context, int index){
                return sortedMessageList[index]['senderId']==widget.currentUserId ?
                    sendMessageCell(context, sortedMessageList, index,  _helperFunctions.getTimeStamp(sortedMessageList[index]['timeStamp'].toString())) :
                    recieveMessageCell(context, sortedMessageList, index, _helperFunctions.getTimeStamp(sortedMessageList[index]['timeStamp'].toString()));
              },
            ) : Center(
              child: Text("Send Hi to start a Conversation"),
            )
          ),
          Container(
            width: width,
            height:70,
            child: Row(
              children: [
                Container(
                  width: width * 0.80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 8.0, bottom: 8.0),
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter Message',

                      ),
                      onChanged: (value){
                        if(value.length > 0) {
                        FirebaseFirestore.instance.collection('user').doc(widget.currentUserId).update({'isOnline' : "typing..."}).catchError((e) => print("Error ${e}"));
                        }else{
                          FirebaseFirestore.instance.collection('user').doc(widget.currentUserId).update({'isOnline' : "Online"}).catchError((e) => print("Error ${e}"));
                        }
                      },
                    ),
                  ),
                ),
//                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.blue, size: 40,),
                    onPressed: (){
                      print('Send Button Pressed');
                      sendMessage();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  void sendMessage(){
    var timeStap = DateTime.now().millisecondsSinceEpoch;
    if(messageController. text!= "" && currentUser != null){
    var messageBody = messageController.text;
    var senderName = currentUser['name'];
    var senderId = currentUser['uid'];
    var toId = "";

    Map<String, dynamic> messageData = {
      'senderName':senderName,
      'senderId': senderId,
      'toId':widget.toId,
      'messageBody': messageBody,
      'timeStamp': timeStap,
    };

    FirebaseFirestore.instance.collection('messages').add(messageData).whenComplete((){
      messageController.text = "";
      setState(() {

      });
    });
  }else{

    }
  }

  void getMessages(){
    _streamSubscription = FirebaseFirestore.instance.collection('messages').orderBy('timeStamp', descending: false).snapshots().listen((dataSnapshot) {
      if(dataSnapshot != null){
        messageList = dataSnapshot.docs;
        sortedMessageList = [];
        var ids = [widget.toId, widget.currentUserId];
        for(var i = 0; i<messageList.length; i++){
          if(ids.contains(messageList[i]['toId']) && ids.contains(messageList[i]['senderId'])){
            if(!sortedMessageList.contains(messageList[i]['messageBody'])){
                sortedMessageList.add(messageList[i]);
            }
          }
        }

        setState(() {

        });

      }
    });

  }
}

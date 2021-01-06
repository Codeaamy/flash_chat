import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/View/chat_screen.dart';
import 'package:flashchat/View/login_view.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<QueryDocumentSnapshot> userList = List();

  var uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;

    uid = currentUser.uid;

    FirebaseFirestore.instance.collection('user').get().then((value) {
      setState(() {


      userList = value.docs;
      if (userList != null) {
        print(userList.length);
       for(var i=0; i<userList.length;i++){
         if(userList[i]['uid'] == currentUser.uid){
           setState(() {
             userList.removeAt(i);

           });
         }
       }
      }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userList[index]['name'].toString(),
                        style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold
                        ),),
                      Text(userList[index]['email'].toString(),
                        style: TextStyle(
                            fontSize: 16,
                        ),)
                    ],
                  ),
                ),
              ),
            ),
            onTap: (){
              var toId = userList[index]['uid'].toString();
              var toName = userList[index]['name'].toString();
              var toIsOnline = userList[index]['isOnline'].toString();
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(currentUserId: uid, toId: toId, toName: toName, toIsOnline: toIsOnline,)));
            },
          );
        },

      )
    );
  }
}

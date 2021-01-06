import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/View/login_view.dart';
import 'package:flashchat/View/main_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.red[50],
      body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Sign up Page", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
        SizedBox(height: 50),
        Container(
          width: MediaQuery.of(context).size.width - 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(

              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, size: 25,),
                hintText: "Name",
                fillColor: Colors.white,
                filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.red, width: 2)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )

              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(

              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, size: 25,),
                hintText: "Email",
                fillColor: Colors.white,
                filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.red, width: 2)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )

              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 40,

            child: TextFormField(
              controller: passwordController,
              obscureText: true,

              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),

                hintText: "Password",
                fillColor: Colors.white,
                filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.red, width: 2)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )

              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            child: Container(
              width: 250,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Center(child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
            ),
            onTap: (){
              print(" Sign Up Button Pressed");
              createNewUser();
            },
          ),
        ),
        GestureDetector(
          child: Text("Already Have an Account! Log In"),
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
          },
        )
      ],
      ),
    );
  }
  void createNewUser()async{
    print("Create New User Function Running");

    String email = emailController.text;
    String password = passwordController.text;
    String name = nameController.text;

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).catchError((error){
      print(error);
    }).then((value){
      var user = value.user;
      var uid = user.uid;
      addUserToDatabase(email, password, name, uid);
    });

  }

  void addUserToDatabase(String email, String password, String name, String uid){
    Map<String, dynamic> data = {
      "name": name,
      "password": password,
      "email": email,
      "uid": uid,
      "isOnline" : "Online",
    };


    FirebaseFirestore.instance.collection('user').doc(uid).set(data).whenComplete((){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainScreen()));
    }).catchError((error){
      print(error);
    });
  }


}

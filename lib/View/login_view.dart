import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/View/main_screen.dart';
import 'package:flashchat/View/signup_screen.dart';
import 'package:flashchat/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool spinner = false;

  HelperFunctions _helperFunctions = HelperFunctions();

  @override
  void initState() {
    // TODO: implement initState
    checkIfUserLoggedIn();
    super.initState();


  }

  void checkIfUserLoggedIn(){
    WidgetsBinding.instance.addPostFrameCallback((_){

      // Add Your Code here.
      var currentUser = FirebaseAuth.instance.currentUser;
      if(currentUser != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      }

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(

          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,

                  child: Image.asset('images/main_top.png', width: 200, height: 220, fit: BoxFit.cover,)),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset('images/login_bottom.png', width: 270, height: 200, fit: BoxFit.cover,)),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('images/codeaamy_logo.png', width: 200, height: 200, fit: BoxFit.fitWidth,),
                    Text("Welcome To Flash Chat", style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),),
                    SizedBox(height: 50),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          child: TextFormField(

                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email, size: 25,),
                              hintText: "Email",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.all(5),
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
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,

                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,

                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, size: 25,),

                              hintText: "Password",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.all(5),
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
                          child: Center(child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
                        ),
                        onTap: (){
                          print(" Login Button Pressed");
                          LoginIntoData();
                        },
                      ),
                    ),

                    GestureDetector(
                      child: Text("New User! Create an Account"),
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                      },
                    ),
//                SizedBox(height: 30,)

                  ],
                ),
              ),

            ],
          ),
        ),
      ),


    );
  }

  void LoginIntoData() {
    setState(() {
      spinner = true;
    });
    var email = emailController.text;
    var password = passwordController.text;
    if (email != "" && password != "") {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password).then((value) {
            setState(() {
              spinner = false;
            });
        var user = value.user;
        if (user != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        }
      }).catchError((error) {
        setState(() {
          spinner = false;
          _helperFunctions.showAlert(context, AlertType.error, "Error Login", '${error}', "ok", (){Navigator.pop(context);});
        });
        print("Error Login user into Server ${error}");
      });

  }else{
    print("All Fields are compulsary");
  }
  }
}

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';
import 'package:visitor/googlemap/gmap.dart';
import 'package:visitor/phoneAuth/loginotp.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //fb login
  final fbLogin = FacebookLogin();
  Future signInFB() async {
    final FacebookLoginResult result = await fbLogin.logIn(["email"]);
    final String token = result.accessToken.token;

    final response = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = jsonDecode(response.body);
    print(token);
    print(profile);
    Constants.prefs.setBool("loggedIn", true);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Gmapp()));
    return profile;
  }

//firebase database
  void readData(String number) async {
    var dbRef = await FirebaseDatabase.instance.reference().child("Cust");
    dbRef
        .orderByChild("number")
        .equalTo(number)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        Toast.show("User not registerd", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        final formState = _formKey.currentState;
        if (formState.validate()) {
          formState.save();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginOtp(number: number)));
        }
      }
    });
  }

//Google login
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _user;

  void signInwithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await _auth.signInWithCredential(credential);
    _user = await _auth.currentUser();
    Constants.prefs.setBool("loggedIn", true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Gmapp()),
    );
  }

  // bool isLoggedIn = false;
  // var profileData;

  // var facebookLogin = FacebookLogin();

  // void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
  //   setState(() {
  //     this.isLoggedIn = isLoggedIn;
  //     this.profileData = profileData;
  //   });
  // }

  // void initiateFacebookLogin() async {
  //   var facebookLoginResult =
  //       await facebookLogin.logInWithReadPermissions(['email']);

  //   switch (facebookLoginResult.status) {
  //     case FacebookLoginStatus.error:
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       var graphResponse = await http.get(
  //           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

  //       var profile = json.decode(graphResponse.body);
  //       print(profile.toString());

  //       onLoginStatusChanged(true, profileData: profile);
  //       break;
  //   }
  // }

  @override
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Image(
        //   image: AssetImage("ASSETS/logo.png"),
        // ),
        // backgroundColor: Hexcolor("#f9692d"),
        backgroundColor: Colors.grey,
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50, right: 210),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Phone number',
                        prefixIcon: Icon(Icons.phone),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      controller: numberController,
                      validator: (input) {
                        if (input.length < 10)
                          return 'Please enter proper number';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 160,
                    ),
                    MaterialButton(
                      height: 52,
                      minWidth: 323,
                      color: Colors.blue[900],
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Text(
                        "facebook",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () {
                        signInFB();
                      },
                      splashColor: Colors.redAccent,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      height: 52,
                      minWidth: 323,
                      color: Colors.blue[900],
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Text(
                        "Google",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () {
                        signInwithGoogle();
                      },
                      splashColor: Colors.redAccent,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      height: 52,
                      minWidth: 323,
                      color: Colors.blue[900],
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () {
                        var number_entered =
                            "+91" + numberController.text.trim();
                        readData(number_entered);
                      },
                      splashColor: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

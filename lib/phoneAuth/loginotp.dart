import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visitor/googlemap/gmap.dart';

import '../constant.dart';

class LoginOtp extends StatefulWidget {
  final number;
  LoginOtp({@required this.number});
  @override
  _LoginOtpState createState() => _LoginOtpState(number);
}

class _LoginOtpState extends State<LoginOtp> {
  String otp, number;
  _LoginOtpState(this.number);
  String verificationId;
  String authStatus = "";
  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
        });
      },
      verificationFailed: (AuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
        });
        // otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  }

  SHaredPRef() {
    Constants.prefs.setBool("loggedIn", true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Gmapp()),
    );
  }

  signIn() {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: otp);
    FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((user) => SHaredPRef())
        .catchError((e) => print(e));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.verifyPhoneNumber(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            // child: Image(
            //   image: AssetImage("ASSETS/logo.png"),
            // ),
            ),
        // backgroundColor: Hexcolor("#f9692d"),
        backgroundColor: Colors.grey,
        elevation: 0.0,
      ),
      body: Form(
          child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 210),
                    child: Text(
                      "Enter OTP ",
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
                      hintText: 'Enter OTP',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Enter OTP';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      otp = value;
                    },
                  ),
                  SizedBox(
                    height: 310,
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
                      "verify",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: () {
                      signIn();
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => OTpSc()));
                    },
                    splashColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

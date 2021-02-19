import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:visitor/phoneAuth/login.dart';
import 'package:visitor/phoneAuth/regOtp.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void readData(String name, String number) async {
    var dbRef = await FirebaseDatabase.instance.reference().child("Cust");

    dbRef
        .orderByChild("number")
        .equalTo(number)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        final formState = _formKey.currentState;
        if (formState.validate()) {
          formState.save();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTpSc(username: name, number: number)));
        }
      } else {
        Toast.show("User already registerd", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
    // final db = FirebaseDatabase.instance.reference().child("Cust");
    // db.once().then((DataSnapshot snapshot) {
    //   Map<dynamic, dynamic> values = snapshot.value;
    //   values.forEach((key, values) {
    //     String num = values["number"];
    //     print(values["number"]);
    //     if (num == number) {

    //     } else {
    //       Toast.show("Data is not presernt", context,
    //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    //     }
    //   });
    //   // if (snapshot.value != null) {
    //   //   Toast.show("Data is not presernt", context,
    //   //       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    //   // } else {
    //   //   Toast.show("Data is presernt", context,
    //   //       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    //   // }
    // });
  }

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
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 12),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ))),
        ],
        elevation: 0.0,
      ),
      body: Form(
          key: _formKey,
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
                          "Sign up",
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
                          hintText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter Your Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                        controller: phoneController,
                        validator: (input) {
                          if (input.length < 10)
                            return 'Please enter proper number';
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // TextFormField(
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //   ),
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.white,
                      //     hintText: 'Password',
                      //     prefixIcon: Icon(Icons.lock),
                      //     contentPadding: const EdgeInsets.only(
                      //         left: 14.0, bottom: 8.0, top: 8.0),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.all(
                      //         Radius.circular(25.0),
                      //       ),
                      //     ),
                      //   ),
                      //   obscureText: true,
                      //   keyboardType: TextInputType.text,
                      //   onSaved: (String val) {
                      //     _password = val;
                      //   },
                      // ),
                      SizedBox(
                        height: 200,
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
                          "Sent OTP",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: () {
                          var name_entered = nameController.text.trim();
                          var number_entered =
                              "+91" + phoneController.text.trim();
                          readData(name_entered, number_entered);
                        },
                        splashColor: Colors.redAccent,
                      ),
                      FlatButton(
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have account?',
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Go here',
                                  style: TextStyle(color: Colors.orange)),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
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

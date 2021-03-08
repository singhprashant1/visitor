import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitor/bloc.dart';
import 'package:visitor/googlemap/gmap.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  changeThePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Gmapp()));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<Bloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bloc Pattern"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<String>(
                stream: bloc.email,
                builder: (context, snapshot) => TextField(
                  onChanged: bloc.emailChanged,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter email",
                      labelText: "Email",
                      errorText: snapshot.error),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              StreamBuilder<String>(
                stream: bloc.password,
                builder: (context, snapshot) => TextField(
                  onChanged: bloc.passwordChanged,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter password",
                      labelText: "Password",
                      errorText: snapshot.error),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // StreamBuilder<bool>(
              //   stream: bloc.submitValidForm,
              //   builder: (context, snapshot) => RaisedButton(
              //     color: snapshot.hasError || !snapshot.hasData
              //         ? Colors.grey
              //         : Colors.blue,
              //     onPressed: snapshot.hasError || !snapshot.hasData
              //         ? null
              //         : () {
              //             print("data");
              //           },
              //     child: Text("Submit"),
              //   ),
              // ),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    final bloc = Provider.of<Bloc>(context, listen: false);

    return StreamBuilder<Object>(
        stream: bloc.submitValidForm,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: snapshot.hasError || !snapshot.hasData
                ? null
                : () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Gmapp()));
                  },
            child: Container(
              height: 40,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: snapshot.hasError || !snapshot.hasData
                    ? Colors.grey
                    : Color(0xffff69b4),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ),
          );
        });
  }
}

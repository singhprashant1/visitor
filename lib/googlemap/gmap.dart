import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:visitor/audio/audiop.dart';
import 'package:visitor/phoneAuth/login.dart';
import 'package:visitor/video/videop.dart';

import '../constant.dart';

class Gmapp extends StatefulWidget {
  @override
  _GmappState createState() => _GmappState();
}

class _GmappState extends State<Gmapp> {
  bool _visible = false;
  Set<Marker> _marker = {};
  double bottampaddingofMap = 0;
  Completer<GoogleMapController> _controllergooglemap = Completer();
  GoogleMapController newGoogleMapcontroller;
  GlobalKey<ScaffoldState> scaffolkey = new GlobalKey<ScaffoldState>();
  Position currentlocation;
  var geoLocator = Geolocator();
  LatLng latLatPosition;
  BitmapDescriptor mapMaker; //for icon in bitmap

  @override
  void initState() {
    super.initState();
    setCustomeMarker();
  }

  void setCustomeMarker() async {
    mapMaker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'ASSETS/india3.png',
    );
  }

  final fbLogin = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> _logout() async {
    try {
      Constants.prefs.setBool("loggedIn", false);
      await FirebaseAuth.instance.signOut();
      await fbLogin.logOut();
      await _googleSignIn.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print(e.toString());
    }
  }

  void locatePostion() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentlocation = position;
    latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapcontroller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // print(latLatPosition);
  }

  static final CameraPosition _kGoogleplex =
      CameraPosition(target: LatLng(19.3064218, 72.9371035), zoom: 12);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 12),
              child: GestureDetector(
                  onTap: () {
                    _logout();
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ))),
        ],
        elevation: 0.0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottampaddingofMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGoogleplex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            markers: _marker,
            onMapCreated: (GoogleMapController controller) {
              _controllergooglemap.complete(controller);
              newGoogleMapcontroller = controller;
              locatePostion();
              setState(() {
                print(latLatPosition);
                bottampaddingofMap = 300;
                _marker.add(Marker(
                  markerId: MarkerId('id-1'),
                  position: LatLng(19.3064218, 72.9371035),
                  infoWindow: InfoWindow(
                      title: 'Demo',
                      snippet: 'Demo data',
                      onTap: () {
                        setState(() {
                          _visible = !_visible;
                        });
                      }),
                ));
                _marker.add(Marker(
                  markerId: MarkerId('id-2'),
                  position: LatLng(19.3719936, 72.8754067),
                  icon: mapMaker,
                  infoWindow: InfoWindow(
                      title: 'Demo2',
                      snippet: 'Demo data',
                      onTap: () {
                        setState(() {
                          _visible = !_visible;
                        });
                      }),
                ));
              });
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                child: MaterialButton(
                  height: 52,
                  minWidth: 323,
                  color: Colors.blue[900],
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Text(
                    "Audio",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AudioPlayerUrl()));
                    // signInwithGoogle();
                  },
                  splashColor: Colors.redAccent,
                ),
                visible: _visible,
              ),
              Visibility(
                child: MaterialButton(
                  height: 52,
                  minWidth: 323,
                  color: Colors.blue[900],
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Text(
                    "Video",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoPlayerr()));
                    // signInwithGoogle();
                  },
                  splashColor: Colors.redAccent,
                ),
                visible: _visible,
              ),
            ],
          )
        ],
      ),
    );
  }
}

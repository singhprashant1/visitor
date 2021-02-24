import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/gLoginPageoogle_maps_flutter.dart';
// import 'package:ikss/gmap.dart';

// import 'package:ikss/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor/googlemap/gmap.dart';
import 'package:visitor/loginwithbloc.dart';
import 'package:visitor/phoneAuth/register.dart';

import 'constant.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Constants.prefs = await SharedPreferences.getInstance();

  runApp(MaterialApp(
    title: "Ikss",
    // home: Constants.prefs.getBool("loggedIn") == true ? Gmapp() : FirstPage(),
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    routes: {
      "/logout": (context) => FirstPage(),
      "/home": (context) => Gmapp(),
    },
  ));
}

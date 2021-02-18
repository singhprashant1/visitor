import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/gLoginPageoogle_maps_flutter.dart';
// import 'package:ikss/gmap.dart';
import 'package:ikss/googlemap/gmap.dart';
// import 'package:ikss/login.dart';
import 'package:ikss/phoneAuth/login.dart';
import 'package:ikss/phoneAuth/register.dart';
// import 'package:ikss/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Constants.prefs = await SharedPreferences.getInstance();

  runApp(MaterialApp(
    title: "Bookspot",
    home: FirstPage(),
    debugShowCheckedModeBanner: false,
    routes: {
      "/logout": (context) => FirstPage(),
      "/home": (context) => Gmapp(),
    },
  ));
}

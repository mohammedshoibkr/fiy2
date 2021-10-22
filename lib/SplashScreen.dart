import 'dart:async';

import 'package:Fiy/DashBoard.dart';
import 'package:Fiy/proflie.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Fiy/main.dart';

import 'ProflieModel.dart';
import 'main.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
String _versionName = 'V1.0';
final splashDelay = 5;


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()  {
    SharedPreferences sharedPreferences;
    String ph;
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) async {
      sharedPreferences = sp;
      if (sp.containsKey(ProflieModel.ph_key) && sp.getString(ProflieModel.ph_key)!.length >0) {
        //in this case the app is already installed, so we need to redirect to landing screen
        ph = sp.getString(ProflieModel.ph_key)!;
        phoneNumberVerified = ph;
        ph = sp.getString(ProflieModel.ph_key)!;
        Timer(Duration(seconds: 2),() => Get.to(ph!=null ? DashBoard(): MyHomePage()));
      } else {
        //in this case the app is installed newly or user signed out, so we need to redirect to signup page
        Get.to(MyHomePage());
      }
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xFF083142)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Image.asset(
                        'assets/images/loading-1.gif',
                        height: 250,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "FIY",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0),
                      ),

                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/Simpfo_Logo-removebg-preview.png',width: 120,height: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),

                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
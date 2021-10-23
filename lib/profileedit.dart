import 'package:Fiy/DashBoard.dart';
import 'package:Fiy/proflie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddLocation.dart';
import 'ProflieModel.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIY',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfileEdit(),
    );
  }
}

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  var len = (register?.imgurl ?? 0).toString();
  var nam = (register?.name ?? 0).toString();


  void initState() {
    SharedPreferences sharedPreferences;
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      ph = sp.getString(ProflieModel.ph_key);
      FirebaseFirestore.instance
          .collection('users')
          .where(ProflieModel.ph_key, isEqualTo: ph)
          .get().then((value)  {
        userDocId = value.docs[0].id;
        register = ProflieModel(phno: value.docs[0].data()[ProflieModel.ph_key],name: value.docs[0].data()[ProflieModel.ph_name], gender:  value.docs[0].data()[ProflieModel.ph_gender], age: value.docs[0].data()[ProflieModel.ph_age],imgurl:  value.docs[0].data()[ProflieModel.ph_img]);
        /*Timer(Duration(seconds: 2), () =>
          Get.to(ph != null ? Proflie() : MyHomePage()));*/
        setState(() {});
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 50,
                    shadowColor: Colors.black,
                    color: Colors.white,
                    child: SizedBox(
                      width: 380,
                      height: 660,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.arrowLeft,
                                      ),
                                      iconSize: 25,
                                      color: Colors.black,
                                      onPressed: () {
                                        Navigator.push(
                                            context, new MaterialPageRoute(builder: (context) => new DashBoard()));
                                      },
                                    ), SizedBox(
                                      width: 70,
                                    ),
                                      Container(
                                        width: 100.0,
                                        height: 130.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover, image: NetworkImage(register!.imgurl/*"assets/images/background.jpg"*/)),
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          color: Colors.redAccent,
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.userEdit,
                                      ),
                                      iconSize: 25,
                                      color: Colors.black,
                                      onPressed: () {
                                        Navigator.push(
                                            context, new MaterialPageRoute(builder: (context) => new Proflie()));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Text(
                                      register!.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ),
                               SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesomeIcons.phone),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ph!,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 340,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                      width: 165,
                                      child: ElevatedButton(
                                        onPressed: ()  {
                                          Navigator.push(
                                              context, new MaterialPageRoute(builder: (context) => new  AddLocation()));
                                        },

                                        style: ButtonStyle(

                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(Colors.white),
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(Colors.blue),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),

                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  'Add New Location',
                                                  style: TextStyle(fontSize: 12)
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(FontAwesomeIcons.plusCircle),

                                            ],
                                          ),

                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 115,
                                    child: ElevatedButton(
                                      onPressed: ()  {},

                                      style: ButtonStyle(

                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(Colors.lightGreen),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),

                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Row(
                                          children: [
                                            Icon(FontAwesomeIcons.qrcode),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                'Scan QR\nCode ',
                                                style: TextStyle(fontSize: 12)
                                            ),



                                          ],
                                        ),

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                ),
                  ),
            ]),
          ),
        ),

    );
  }
}

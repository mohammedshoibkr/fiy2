// @dart=2.11
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:Fiy/DashBoard.dart';
import 'package:Fiy/proflie.dart';
import 'package:Fiy/push_notifications_manager.dart';
import 'ProflieModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'SplashScreen.dart';

//Global Varibales
String baseUrl="https://testapi.slrorganicfarms.com";
String phoneNumberVerified;
String phoneNumEntered;
String apiToken;
String _verificationId;
String  UserFullName;
int userId;
FirebaseMessaging messaging;
bool newSignin=false;
String cloudMsgToken;
int branchId = 1;
/*String userPwd="123456"*/






const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(GetMaterialApp(home: MyApp()));
}

class ListItem {
  int value;
  String name;
  ListItem(this.value, this.name);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final _scaffoldKey = GlobalKey<ScaffoldState>();
final TextEditingController _phoneNumberController = TextEditingController();
final TextEditingController _smsController = TextEditingController();

final SmsAutoFill _autoFill = SmsAutoFill();

void showSnackBar(String message) {
  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
}

void verifyPhoneNumber(ListItem _selectedItem, context) async {
  PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential phoneAuthCredential) async {
    await _auth.signInWithCredential(phoneAuthCredential);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Phone number automatically verified and user signed in: ${_auth.currentUser.uid}"),
        backgroundColor: Colors.indigoAccent,
        padding: EdgeInsets.all(20),
        shape: StadiumBorder()));
  };
  PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}'),
        backgroundColor: Colors.indigoAccent,
        padding: EdgeInsets.all(20),
        shape: StadiumBorder()));
  };
  PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please check your phone for the verification code.'),
        backgroundColor: Colors.indigoAccent,
        padding: EdgeInsets.all(20),
        shape: StadiumBorder()));
    _verificationId = verificationId;
  };
  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("verification code: " + verificationId),
        backgroundColor: Colors.indigoAccent,
        padding: EdgeInsets.all(20),
        shape: StadiumBorder()));*/
    _verificationId = verificationId;
  };
  try {
    phoneNumEntered =
        '+' + _selectedItem.value.toString() + _phoneNumberController.text;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumEntered,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to Verify Phone Number: $e"),
        backgroundColor: Colors.indigoAccent,
        padding: EdgeInsets.all(20),
      ),
    );
  }
}

void signInWithPhoneNumber(BuildContext context) async {
  try {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final User user = (await _auth.signInWithCredential(credential)).user;
    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully signed in UID: ${user.uid}"),
        backgroundColor: Colors.indigoAccent,
        padding: EdgeInsets.all(20),
        shape: StadiumBorder()));*/
    SharedPreferences sharedPreferences;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sp.setString(ProflieModel.ph_key, phoneNumEntered);
    });
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new Proflie()));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in: " + e.toString()),
        backgroundColor: Colors.indigoAccent,
        padding: EdgeInsets.all(20),
        shape: StadiumBorder()));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  FirebaseMessaging messaging;
  String finalphone;
  String ph;
  @override
  void initState() {
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    SharedPreferences sharedPreferences;
    PushNotificationsManager().init();
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(

                  channel.id, channel.name, channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                  visibility: NotificationVisibility.public),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });


    SharedPreferences.getInstance().then((SharedPreferences sp) async{
      sharedPreferences = sp;
      if (sp.containsKey(ProflieModel.ph_key)) {
        //in this case the app is already installed, so we need to redirect to landing screen
        ph = sp.getString(ProflieModel.ph_key);
        Timer(Duration(seconds: 2),() => Get.to(ph!=null ? DashBoard(): MyHomePage()));
      } else {
        //in this case the app is installed newly or user signed out, so we need to redirect to signup page
        Get.to(MyHomePage());
      }
      setState(() {});
    });
  }

  /*void intiState(){
    getValidationData().whenComplete(() async{
      Timer(Duration(seconds: 2),() => Get.to(finalphone==null ? MyHomePage(): Proflie()));
      Timer(Duration(seconds: 2),() => Get.to(finalphone==null ? MyHomePage(): Proflie()));
    });
  }
  Future getValidationData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedphone = sharedPreferences.getString('phone');
    setState(() {
      finalphone=obtainedphone;
    });
    print(finalphone);
  }
*/

  List<ListItem> _dropdownItems = [
    ListItem(91, "(+91) India"),
    ListItem(1, "(+1) USA"),
    ListItem(81, "(+81) Japan"),
    ListItem(964, "(+964) Iraq"),
  ];
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems as Iterable<ListItem>) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  /*void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "welcome to FIY ",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f6fb),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/Simpfo_Logo-removebg-preview.png',
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: DropdownButton<ListItem>(
                          value: _selectedItem,
                          items: _dropdownMenuItems,
                          iconSize: 24,
                          elevation: 16,
                          icon: const Icon(Icons.arrow_drop_down_circle_sharp),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              _selectedItem = value;
                            });
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Valid Phone Number';
                              }
                              return null;
                            },
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                                labelText: 'Phone Number',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon: Icon(Icons.check_circle,
                                    color: Colors.green)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: Text("Verify Number"),
                        onPressed: () {
                          verifyPhoneNumber(_selectedItem, context);
                        },
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.purple),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Valid Name';
                        }
                        return null;
                      },
                      controller: _smsController,
                      decoration: const InputDecoration(
                        labelText: 'Verification code',
                      ),
                      onTap: () async {
                        await SmsAutoFill().listenForCode;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                          final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          sharedPreferences.setString(
                              ProflieModel.ph_key, _phoneNumberController.text);
                          signInWithPhoneNumber(context);
                          /* showNotification();*/
                        },
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.purple),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: Text("Sign in"),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
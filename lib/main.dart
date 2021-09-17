// @dart=2.9
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:untitled/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Auth Demo'),
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
String _verificationId;
final SmsAutoFill _autoFill = SmsAutoFill();

void showSnackBar(String message) {
  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
}

void verifyPhoneNumber() async {
  PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential phoneAuthCredential) async {
    await _auth.signInWithCredential(phoneAuthCredential);
    showSnackBar("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
  };
  PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
    showSnackBar('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
  };
  PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    showSnackBar('Please check your phone for the verification code.');
    _verificationId = verificationId;
  };
  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    showSnackBar("verification code: " + verificationId);
    _verificationId = verificationId;
  };
  try {
    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  } catch (e) {
    showSnackBar("Failed to Verify Phone Number: ${e}");
  }
}


void signInWithPhoneNumber(BuildContext context) async {
  try {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final User user = (await _auth.signInWithCredential(credential)).user;
    showSnackBar("Successfully signed in UID: ${user.uid}");
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new Register()));
    
  } catch (e) {
    showSnackBar("Failed to sign in: " + e.toString());
  }
}




class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff7f6fb),
        body: SafeArea(
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
                width: 200,
                height: 200,
                 decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                 shape: BoxShape.circle,
                 ),
                 child: Image.asset(
                 'assets/images/illustration-2.png',
                 ),
                ),
                SizedBox(
                 height: 18,
               ),
                 TextFormField(
                   controller: _phoneNumberController,
                   style: TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ),
                   decoration: InputDecoration(
                     enabledBorder: OutlineInputBorder(
                         borderSide: BorderSide(color: Colors.black12),
                         borderRadius: BorderRadius.circular(10)),
                     focusedBorder: OutlineInputBorder(
                         borderSide: BorderSide(color: Colors.black12),
                         borderRadius: BorderRadius.circular(10)),
                     prefix: Padding(
                       padding: EdgeInsets.symmetric(horizontal: 8),
                       child: Text(
                         '(+91)',
                         style: TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                     suffixIcon: Icon(
                       Icons.check_circle,
                       color: Colors.green,
                       size: 32,
                     ),
                   ),
                 ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: ElevatedButton(child: Text("Get current number"),
                        onPressed: () async  {
                        await SmsAutoFill().listenForCode;
                        },
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text("Verify Number"),
                      onPressed: () async {
                        verifyPhoneNumber();
                      },
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _smsController,
                    decoration: const InputDecoration(labelText: 'Verification code',
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
                          signInWithPhoneNumber(context);

                        },
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.purple),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: Text("Sign in"),
                    ),
                  ),
                ],

              )
          ),
        )
    );
  }
}



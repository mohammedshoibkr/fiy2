import 'dart:async';
import 'dart:core';
import 'dart:io' as io;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ProflieModel.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'main.dart';
import 'package:untitled/NavBar.dart';


final usersRef= FirebaseFirestore.instance.collection('users');
class Proflie extends StatefulWidget {
  const Proflie({Key? key}) : super(key: key);

  @override

  _ProflieState createState() => _ProflieState();


}

class _ProflieState extends State<Proflie> {
  String? ph;
  ProflieModel? register = ProflieModel(name: '', gender: '', age: '', imgurl: 'file:///assets/images/proflie.png', phno: '');

  @override
  void initState() {
    SharedPreferences sharedPreferences;
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      if( sp.containsKey(ProflieModel.ph_key) )
      {
        //in this case the app is already installed, so we need to get details of user
        ph = sp.getString(ProflieModel.ph_key);
        FirebaseFirestore.instance
            .collection('users')
            .where(ProflieModel.ph_key, isEqualTo: ph)
            .get().then((value)  {
          register = ProflieModel(phno: value.docs[0].data()[ProflieModel.ph_key],name: value.docs[0].data()['name'], gender:  value.docs[0].data()['gender'], age: value.docs[0].data()['age'],imgurl:  value.docs[0].data()['image']);
          name.text=register!.name;
          age.text=register!.age;
        });
       /* Timer(Duration(seconds: 2),() => Get.to(ph!=null ?Proflie(): MyHomePage()));*/
      }else{

      }
      setState(() {});
    });

  }


  String? _downloadurl;
   final name = TextEditingController();
  final age = TextEditingController();
  final gender = TextEditingController();
  final imgurl= TextEditingController();
  final phno=TextEditingController();

  String? fliename;
  String? tname;
  Future<void> insertData(final register) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("users").add(register)
        .then((DocumentReference document) {
      print(document.id);
    }).catchError((e) {
      print(e);

    });
  }
   File? _image;
  ImagePicker imagePicker = ImagePicker();

  Future getImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image!.path);
    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance
        .ref().child('uploads').child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_image!.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);

    await Future.value(uploadTask);
    String url = (await ref.getDownloadURL()).toString();
    print(url);
    _downloadurl=url;
/*        .then((value) =>
    {

      print("Upload file path ${value.ref.fullPath}")

    }).onError((error, stackTrace) =>
    {
      print("Upload file path error ${error.toString()} ")
    });*/
  }



    @override

    Widget build(BuildContext context) {
      return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text('FIY'),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      elevation: 4.0,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: (_image != null) ? Image.file(
                        _image!, fit: BoxFit.fill,) : Ink.image(
                      /*  image: AssetImage("assets/images/proflie.png"),*/
                        image: NetworkImage('https://avatars.githubusercontent.com/u/86800136?s=20&v=4'),
                        fit: BoxFit.cover,
                        width: 120.0,
                        height: 120.0,
                        child: InkWell(
                          onTap: () {
                            getImage();
                          },
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 50,
                    ),
                    TextField(
                      controller: name,
                      keyboardType: TextInputType.text,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _genderWidget(true, true),

                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: age,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: 'Age',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                         await uploadPic(context);
                          final String pname = name.text;
                          final String pgender = gender.text;
                          final String page = age.text;
                          final String pimgurl=imgurl.text;
                          register = ProflieModel(phno:ph,name: pname, gender: pgender, age: page,imgurl: _downloadurl!);
                          insertData(register!.toMap());
                        },

                        style: ButtonStyle(

                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lime
                              .shade800),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),

                        ),
                        child: Padding(
                          padding: EdgeInsets.all(14),
                          child: Text(
                              'SAVE',
                              style: TextStyle(fontSize: 16)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                         /* Get.to(DashboardScreen());*/

                        },
                        style: ButtonStyle(

                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue
                              .shade800),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),

                        ),
                        child: Padding(
                          padding: EdgeInsets.all(14),
                          child: Text(
                              'Next',
                              style: TextStyle(fontSize: 16)
                          ),
                        ),
                      ),
                    ),

                  ]
              ),
            ),
          ),
        ),

      );

    }
  }

  Widget _genderWidget(bool _showOthers, bool _alignment) {
    return Container(
      alignment: Alignment.center,
      child: GenderPickerWithImage(
        showOtherGender: _showOthers,
        verticalAlignedText: _alignment,
        onChanged: (Gender? _gender) {},
        selectedGender: Gender.Male,
        selectedGenderTextStyle: TextStyle(fontWeight: FontWeight.bold),
        unSelectedGenderTextStyle: TextStyle(fontWeight: FontWeight.normal),
        equallyAligned: true,
        size: 64,
        animationDuration: Duration(seconds: 1),
        isCircular: true,
        opacityOfGradient: 0.7,
        padding: EdgeInsets.all(10.0),
      ),
    );
  }


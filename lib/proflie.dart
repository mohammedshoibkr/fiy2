import 'dart:async';
import 'dart:core';
import 'dart:io' as io;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Fiy/ProflieModel.dart';
import 'DashBoard.dart';
import 'main.dart';
import 'package:Fiy/NavBar.dart';


String? _downloadurl;
ProflieModel? register;
String? userDocId;
String? ph;

final usersRef= FirebaseFirestore.instance.collection('users');
class Proflie extends StatefulWidget {
  const Proflie({Key? key}) : super(key: key);

  @override

  _ProflieState createState() => _ProflieState();


}

class _ProflieState extends State<Proflie> {
  final _formKey = GlobalKey<FormState>();



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
          userDocId = value.docs[0].id;
          register = ProflieModel(phno: value.docs[0].data()[ProflieModel.ph_key],name: value.docs[0].data()[ProflieModel.ph_name], gender:  value.docs[0].data()[ProflieModel.ph_gender], age: value.docs[0].data()[ProflieModel.ph_age],imgurl:  value.docs[0].data()[ProflieModel.ph_img]);
          name.text=register!.name;
          age.text=register!.age;
        });
       /* Timer(Duration(seconds: 2),() => Get.to(ph!=null ?Proflie(): MyHomePage()));*/
      }
      else{
      }
      setState(() {});
    });

  }



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
    var image = await imagePicker.pickImage(source: ImageSource.gallery,maxHeight: 200, maxWidth: 200, imageQuality: 25);

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
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        elevation: 4.0,
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: (_image != null) ? Image.file(
                          _image!, fit: BoxFit.cover) :CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage("assets/images/proflie.png"),
                         /* image: NetworkImage('https://avatars.githubusercontent.com/u/86800136?s=20&v=4'),*/
                          /*fit: BoxFit.none,
                          width: 80.0,
                          height: 80.0,*/
                          child: InkWell(
                            onTap: () {
                             /* getImage();*/
                            },
                            child: RawMaterialButton(
                              elevation: 9,
                              child: Icon(Icons.add_a_photo),
                              padding: EdgeInsets.all(9.0),
                              shape: CircleBorder(),
                              onPressed: () {
                                getImage();
                              }

                          ),

                        ),

                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: name,
                        keyboardType: TextInputType.text,
                           validator: (value) {
                     if(value == null || value.isEmpty){
                         return 'Enter Valid Name';
                     }
                     return null;
                        },
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
                        validator: (value) {
                       if (value == null || value.isEmpty) {
                        return 'Enter Valid Age';
                        }
                       return null;
                       },
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
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data')),
                              );
                            }
                            if(_image!=null && _image!.path!=null)
                            {
                              await uploadPic(context);
                            }


                           if(register==null)
                             {
                               register = ProflieModel(phno:ph,name:name.text, gender: selectedGender.toString(), age: age.text,imgurl: _downloadurl!);
                             }
                           else{
                             register!.name=name.text;
                             register!.age=age.text;
                             register!.gender=selectedGender.toString();
                             register!.imgurl=(_downloadurl==null?register!.imgurl:_downloadurl)!;
                           }

                            if(userDocId!= null)
                              {
                                FirebaseFirestore.instance.collection('users').doc(userDocId).update({ProflieModel.ph_key: register!.phno,ProflieModel.ph_name: register!.name,ProflieModel.ph_gender: register!.gender,ProflieModel.ph_age: register!.age,ProflieModel.ph_img: register!.imgurl});
                              }
                            else{
                              insertData(register!.toMap());
                           }

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
                            Get.to(DashBoard());

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
        onChanged: (Gender? _gender) {
          selectedGender=_gender;
        },
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


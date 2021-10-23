
import 'package:Fiy/profileedit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListItem {
  int value;
  String name;
  ListItem(this.value, this.name);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIY',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddLocation(),
    );
  }
}

class AddLocation extends StatefulWidget {

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final property = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final address3 = TextEditingController();
  final city = TextEditingController();
  final pin = TextEditingController();
  final landmark = TextEditingController();

  String? _dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 32),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: property,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter Property Name';
                        }
                        return null;
                      },
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Property Name',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(10)),

                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Address Line 1';
                        }
                        return null;
                      },
                      controller: address1,
                      keyboardType: TextInputType.text,
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: ' Address line 1',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Address Line 2';
                        }
                        return null;
                      },
                      controller: address2,
                      keyboardType:TextInputType.text,
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Address line 2',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Address Line 3';
                        }
                        return null;
                      },
                      controller: address3,
                      keyboardType:TextInputType.text,
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Address line 3',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter City';
                        }
                        return null;
                      },
                      controller: city,
                      keyboardType:TextInputType.text,
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'City',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Pin code';
                        }
                        return null;
                      },
                      controller: pin,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Pin code',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Landmark';
                        }
                        return null;
                      },
                      controller: landmark,
                      keyboardType: TextInputType.text,
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: ' Nearest Landmark',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
               DropdownButtonFormField(
                 decoration: InputDecoration(
                   labelText: 'Property type ',
                   enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.lightGreen),
                       borderRadius: BorderRadius.circular(10)
                   ),
                 ),
                isExpanded: true,
                iconSize: 30.0,

                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.black),
                items: ['Personal', 'Two', 'Three'].map(
                      (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                        () {
                      _dropDownValue = val.toString();
                    },
                  );
                },
              ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.mapMarked,
                          ),
                          iconSize: 40,
                          color: Colors.blue,
                          onPressed: () {

                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.photoVideo,
                          ),
                          iconSize: 40,
                          color: Colors.blue,
                          onPressed: () {

                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.solidAddressBook,
                          ),
                          iconSize: 40,
                          color: Colors.orange,
                          onPressed: () {

                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.solidBell,
                          ),
                          iconSize: 40,
                          color: Colors.orangeAccent,
                          onPressed: () {

                          },
                        ),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.chevronCircleLeft,
                          ),
                          iconSize: 40,
                          color: Colors.black54,
                          onPressed: () {
                            Navigator.push(
                                context, new MaterialPageRoute(builder: (context) => new ProfileEdit()));
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: 50,
                            width: 100,
                            child: ElevatedButton(
                              onPressed: ()  {
                                Navigator.push(
                                    context, new MaterialPageRoute(builder: (context) => new  AddLocation()));
                              },
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
                                    Icon(FontAwesomeIcons.solidSave,),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        'Save',
                                        style: TextStyle(fontSize: 12)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: ()  {},

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
                                  Icon(FontAwesomeIcons.solidWindowClose,),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      'Close ',
                                      style: TextStyle(fontSize: 12)
                                  ),



                                ],
                              ),

                            ),
                          ),
                        ),
                      ],
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

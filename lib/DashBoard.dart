import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'NavBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:clipboard/clipboard.dart';

Gender? selectedGender;
DateTime? backbuttonpressedTime;


void main() {
  runApp(MyApp());
}

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
      home: DashBoard(),
    );
  }
}

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
 final Stream<QuerySnapshot> data= FirebaseFirestore.instance.collection('data').snapshots();
   var rating = 2.0;
  @override
  void initState() {
    super.initState();
      setState(() {

      });

  }

  int currentIndex = 0;
  Widget appBarTitle = new Text("FIY");
  Icon actionIcon = new Icon(Icons.search);

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }
 Future<bool> onWillPop() async {
   DateTime currentTime = DateTime.now();

   //Statement 1 Or statement2
   bool DashBoard = backbuttonpressedTime == null ||
       currentTime.difference(backbuttonpressedTime!) > Duration(seconds: 3);

   if (DashBoard) {
     backbuttonpressedTime = currentTime;
     Fluttertoast.showToast(
         msg: "Double Click to exit app",
         backgroundColor: Colors.white,
         textColor: Colors.black);
     return false;
   }
   exit(0);
 }
  List<dynamic> newDataList = [];
  List<dynamic> mainDataList = [];

  onItemChanged(String value) {
    setState(() {
      newDataList = mainDataList
          .where((dynamic) => (dynamic.Id.toLowerCase().contains(value.toLowerCase())) || (dynamic.FullName.toLowerCase().contains(value.toLowerCase())) || (dynamic.Phone.toLowerCase().contains(value.toLowerCase())))
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavBar(),
      appBar:
      new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)),
                  onChanged: onItemChanged,
                );
              } else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("FIY");
              }
            });
          },
        ),
        ]),
      backgroundColor: Colors.grey,
      body: Stack(
        children:<Widget> [
          Column(
            children: [
              WillPopScope(
                onWillPop: onWillPop,
                child: Expanded(
                  child: Container(
                    height: size.height,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: data,
                      builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                        if(snapshot.hasError){
                          return Text('something went wrong');
                        }
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return Text('loading');
                        }
                        final dataitem=snapshot.requireData;

                        return ListView.builder(
                            itemCount: dataitem.size,
                            itemBuilder: (context,index){
                              return SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                ),
                                  elevation: 50,
                                   shadowColor: Colors.black,
                                   color: Colors.white,
                                   child: SizedBox(
                                    width: 300,
                                     height: 190,
                                   child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text('${dataitem.docs[index]['name']}',style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 34,
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.file,
                                              ),
                                              iconSize: 25,
                                              color: Colors.blue,
                                              onPressed: () {
                                                FlutterClipboard.copy(dataitem.docs[index]['name']).then(( value ) =>
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text("copy to clipboard",textAlign: TextAlign.center),
                                                        backgroundColor: Colors.indigoAccent,
                                                        padding: EdgeInsets.all(20),
                                                        shape: StadiumBorder())));

                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.shareSquare,
                                              ),
                                              iconSize: 25,
                                              color: Colors.blue,
                                              onPressed: () {

                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(dataitem.docs[index]['rating'],style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            ),
                                            SmoothStarRating(
                                            rating: rating,
                                              isReadOnly: true,
                                            size: 25,
                                              filledIconData: Icons.star,
                                              halfFilledIconData: Icons.star_half,
                                              defaultIconData: Icons.star_border,
                                            color: Colors.orange,
                                            borderColor: Colors.grey,
                                            starCount: 5,
                                            onRated: (value) {
                                              setState(() {
                                                rating = dataitem.docs[index]['rating'];
                                                rating=value;
                                              });
                                            }
                                      ),
                                            Text('(2)',style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            ),
                                          ],
                                        ),
                                      Expanded(
                                        child: Text('${dataitem.docs[index]['address']}',style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400
                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ),
                                ),
                              );
                            },
                        );
                      }
                    ),
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 60,
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.people_alt_sharp),
                        elevation: 0.1,
                        onPressed: () {
                          DashBoard();
                        }),
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.home,
                            color: currentIndex == 0
                                ? Colors.orange
                                : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              FontAwesomeIcons.locationArrow,
                              color: currentIndex == 1
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(1);
                            }),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                            icon: Icon(
                              FontAwesomeIcons.solidCompass,
                              color: currentIndex == 2
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),
                        IconButton(
                            icon: Icon(
                              FontAwesomeIcons.rocketchat,
                              color: currentIndex == 3
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(3);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 25);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

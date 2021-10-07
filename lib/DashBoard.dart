import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'DataModel.dart';
import 'NavBar.dart';
import 'Screen.dart';
import 'ScreenDetail.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:Fiy/apiServices.dart';

String selectedOrderId = "-1";
OrderModel selectedDataModel = OrderModel('','','','','','','','');

GetOrders(String token) async {
  http.Response response = await http.post(
    Uri.parse(baseUrl+'/cart/getOrdersOnStatus'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token,
    },
    body: jsonEncode(<String, String>{
      'branchid': '1',
      'Status': '1',
    }),
  );
  print(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    //success, message
    bool res = map["success"];
    String msg = map["message"];
    if (res) {
      List<dynamic> data = map["data"];
      if (data != null) {
        List<dynamic> orders = data;
        List<OrderModel> ordrList = List.generate(
            orders.length,
            (index) => OrderModel(
                '${orders[index]["Id"]}',
                '${orders[index]["Phone"]}',
                '${orders[index]["FullName"]}',
                '${orders[index]["OrderDateAndTime"]}',
                '${orders[index]["OrderCost"]}',
                '${orders[index]["OrderAddress"]}',
                '${orders[index]["Email"]}',
                '${orders[index]["EstAmt"]}'));
        return ordrList;
      }
    }
  }
  return null;
}

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

  TextEditingController _textController = TextEditingController();
  String? ph;
  String? phn;
 /* static List<String> mainDataList = [
    "Apple",
    "Apricot",
    "Banana",
    "Blackberry",
    "Coconut",
    "Date",
    "Fig",
    "Gooseberry",
    "Grapes",
    "Lemon",
    "Litchi",
    "Mango",
    "Orange",
    "Papaya",
    "Peach",
    "Pineapple",
    "Pomegranate",
    "Starfruit"
  ];*/
  @override
  void initState() {
    super.initState();
    getPostsData();

    setState(() {});
  }
 getPostsData() async {
   newDataList = await GetOrders(apiToken);
   setState(()  {
     mainDataList = newDataList;
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

  intl.DateFormat dateFormat = new intl.DateFormat("dd-MM-yyyy");
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
      backgroundColor: Colors.white.withAlpha(55),
      body: Stack(
        children:<Widget> [

         /* Padding(
      // Even Padding On All Sides

        // Symetric Padding
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        // Different Padding For All Sides
        child: const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Hello World!'),
              ),
            )

       ),*/

          /*Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              elevation: 10,
              child: Row(
                children: [
                  Text("fiy",style: TextStyle(color: Colors.black,fontSize: 30),),
                ],
              ),
            ),
          ),*/

          Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(12.0),
                  children: newDataList.map((data) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "OrderId- " +
                                data.Id +
                                "  " +
                                "Date: " +
                                dateFormat.format(new intl.DateFormat(
                                    "yyyy-MM-dd")
                                    .parse(data
                                    .OrderDateAndTime)), //new intl.DateFormat("yyyy/MM/dd", "en_US").parse(project[index].OrderDateAndTime)) ,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                          ),
                          subtitle: Text(
                            data.Phone +
                                " - " +
                                data.FullName,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontStyle: FontStyle.normal),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderDetail(
                                  dataModel: data,
                                )));
                          }),
                      );


                  }).toList(),
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
                          MyScreen();
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

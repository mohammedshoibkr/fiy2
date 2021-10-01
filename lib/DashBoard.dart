import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'DataModel.dart';
import 'NavBar.dart';
import 'Screen.dart';
import 'ScreenDetail.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

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
  String? ph;
  String? phn;
  @override
  void initState() {
    super.initState();
    GetOrders(token);
    setState(() {});
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
  final Future<dynamic> _calculation = GetOrders(token);
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
        children: [
          FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(children: [Text('Error')]),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      List<OrderModel> project = snapshot.data!;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "OrderId- " +
                                  project[index].Id +
                                  "  " +
                                  "Date: " +
                                  dateFormat.format(new intl.DateFormat(
                                          "yyyy-MM-dd")
                                      .parse(project[index]
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
                              project[index].Phone +
                                  " - " +
                                  project[index].FullName,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OrderDetail(
                                        dataModel: project[index],
                                      )));
                            }),
                      );
                    }
                    //itemCount: projectSnap.data.
                    );
              } else {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            'Awaiting result...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        )
                      ]),
                );
              }
            },
            future: _calculation,
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

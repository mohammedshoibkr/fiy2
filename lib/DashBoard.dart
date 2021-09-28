import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataModel.dart';
import 'NavBar.dart';
import 'ProflieModel.dart';
import 'Screen.dart';
import 'ScreenDetail.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

Future<bool> Login(String mobilenumber,String logintype,String device_token, bool createNewCustomerLogin,String branchId,String password) async {
  http.Response response = await http.post(
    Uri.parse('https://testapi.slrorganicfarms.com/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'mobilenumber': mobilenumber,
      'logintype': logintype,
      'device_token': device_token,
      'createNewCustomerLogin': createNewCustomerLogin.toString(),
      'branchId': branchId,
      'password': password,

    }),
  );
print(response.body );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Map<String, dynamic> map = json.decode(response.body);
    //success, message
    bool res = map["success"];
    String msg= map["message"];
    String token=map["token"];
    if(res){
      List<dynamic> data =map["data"];
      if(data != null){
        Map<String, dynamic> dataArr = data[0];
        if(dataArr["UserType"]==1) {
          print("you are not autheroized use this app");
          /*SharedPreferences sharedPreferences;
          SharedPreferences.getInstance().then((SharedPreferences sp) {
            sp.remove(ProflieModel.ph_key);
          });
          Get.to(MyHomePage());*/
        }
        else{
          GetOrders(token);
        }
      }
    }
        return res;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return false;
   /* throw Exception('Failed to create album.');*/
  }
}
GetOrders(String token) async{
  http.Response response = await http.post(
    Uri.parse('https://testapi.slrorganicfarms.com/cart/getOrdersOnStatus'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token,
    },
    body: jsonEncode(<String, String>{
      'branchid': '1',
      'Status': '1',
    }),
  );
  print(response.body );
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    //success, message
    bool res = map["success"];
    String msg= map["message"];
    if(res){
      List<dynamic> data =map["data"];
      if(data != null){
        List<dynamic> orders=data;

        }

    }
  }
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
        home:DashBoard(),
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
    SharedPreferences sharedPreferences;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      if( sp.containsKey(ProflieModel.ph_key) )
      {
        //in this case the app is already installed, so we need to redirect to landing screen
        ph = sp.getString(ProflieModel.ph_key)!;
        phn=ph!.substring(3);
        Login(phn!,'social','',false,'1','').then((value) => print(value));
      }
      else{
        //in this case the app is installed newly or user signed out, so we need to redirect to signup page
        Get.to(MyHomePage());
      }
      setState(() {});
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

  static List<String> name= ['Raju','Ramu','Shoib','Mohammed','Manu'];
  static List<String> phone_number=['9480652086','9480652086','9480652086','9480652086','9480652086'];
  static List<String> orderid=['1','2','3','4','5'];
  static List<String> orderdate=['21','12','3','13','19'];

  final List<DataModel> UserData= List.generate(name.length, (index) => DataModel('${name[index]}', '${phone_number[index]}', '${orderid[index]}', '${orderdate[index]}'));
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavBar(),
      appBar: new AppBar(
          centerTitle: true,
          title:appBarTitle,
          actions: <Widget>[
            new IconButton(icon: actionIcon,onPressed:(){
              setState(() {
                if ( this.actionIcon.icon == Icons.search){
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    style: new TextStyle(
                      color: Colors.white,

                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search,color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)
                    ),
                  );}
                else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text("FIY");
                }


              });
            } ,),]
      ),

      backgroundColor: Colors.white.withAlpha(55),
      body: Stack(
        children: [
          Padding(
              padding: EdgeInsets.all(10),
            child:  ListView.builder(
                itemCount: UserData.length,
                itemBuilder: (context,index){
                  return Card(
                    child: ListTile(
                        title: Text(
                          UserData[index].name,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                        ),
                        subtitle:Text(
                          UserData[index].phone_number,
                          textAlign: TextAlign.center,
                        ),
                        onTap:(){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScreenDetail(dataModel: UserData[index],)));
                        }

                    ),
                  );
                }
            ),

            ),

          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(backgroundColor:  Colors.orange , child: Icon(Icons.people_alt_sharp), elevation: 0.1, onPressed: () {MyScreen();}),
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
                            color: currentIndex == 0 ? Colors.orange : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              FontAwesomeIcons.locationArrow,
                              color: currentIndex == 1 ? Colors.orange : Colors.grey.shade400,
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
                              color: currentIndex == 2 ? Colors.orange : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),
                        IconButton(
                            icon: Icon(
                              FontAwesomeIcons.rocketchat,
                              color: currentIndex == 3 ? Colors.orange : Colors.grey.shade400,
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
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(
        Offset(size.width * 0.60, 20), radius: Radius.circular(20.0),
        clockwise: false);
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







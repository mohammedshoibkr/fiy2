import 'package:flutter/material.dart';
import 'package:untitled/DataModel.dart';
import 'package:untitled/ScreenDetail.dart';



class MyScreen extends StatelessWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIY',
      home:Screen(),
    );
  }
}


class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}


class _ScreenState extends State<Screen> {


  static List<String> name= ['Raju','Ramu','Shoib','Mohammed','Manu'];
  static List<String> phone_number=['9480652086','9480652086','9480652086','9480652086','9480652086'];
  static List<String> orderid=['1','2','3','4','5'];
  static List<String> orderdate=['21','12','3','13','19'];

  final List<DataModel> UserData= List.generate(name.length, (index) => DataModel('${name[index]}', '${phone_number[index]}', '${orderid[index]}', '${orderdate[index]}'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FIY'),
      ),
      body: ListView.builder(
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



                  /*leading: SizedBox(
                   width: 50,
                   height: 50,
                 ),*/
                  onTap:(){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScreenDetail(dataModel: UserData[index],)));
                  }

              ),
            );
          }
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'DataModel.dart';
import 'ScreenDetail.dart';
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Loading(),
    );
  }
}
class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void initState() {
    int currentIndex = 0;
    super.initState();
    setState(() {
    });
  }
  static List<String> name= ['Raju','Ramu','Shoib','Mohammed','Manu','Raju','Ramu','Shoib','Mohammed','Manu','Raju','Ramu','Shoib','Mohammed','Manu'];
  static List<String> phone_number=['9480652086','9480652086','9480652086','9480652086','9480652086','9480652086','9480652086','9480652086','9480652086','9480652086','9480652086','9480652086','9480652086','9480652086','9480652086'];
  static List<String> orderid=['1','2','3','4','5','1','2','3','4','5','1','2','3','4','5'];
  static List<String> orderdate=['21','12','3','13','19','21','12','3','13','19','21','12','3','13','19'];

  final List<DataModel> UserData= List.generate(name.length, (index) => DataModel('${name[index]}', '${phone_number[index]}', '${orderid[index]}', '${orderdate[index]}'));


  final Future<List<DataModel>> _calculation = Future<List<DataModel>>.delayed(
    const Duration(seconds: 5),
        () => List.generate(name.length, (index) => DataModel('${name[index]}', '${phone_number[index]}', '${orderid[index]}', '${orderdate[index]}')),

  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<DataModel>> snapshot) {
        if (snapshot.hasError) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Center(
            child: Column(
                children: [Text('Error')]
            ),
          );
        }
        else if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context,index){
                List<DataModel> project = snapshot.data!;
                return Card(
                  child: ListTile(
                      title: Text(
                        project[index].name,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                      ),
                      subtitle:Text(
                        project[index].phone_number,
                        textAlign: TextAlign.center,
                      ),
                      onTap:(){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScreenDetail(dataModel: project[index],)));
                      }
                  ),
                );
              }
            //itemCount: projectSnap.data.

          );
        }
        else {
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
                  child: Text('Awaiting result...'),
                )
              ]
            ),
          );
        }

      },
      future: _calculation,
    );
  }
}

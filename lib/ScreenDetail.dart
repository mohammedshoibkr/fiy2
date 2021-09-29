import 'package:flutter/material.dart';
import 'package:untitled/DataModel.dart';

class ScreenDetail extends StatelessWidget {
  final DataModel dataModel;
  const ScreenDetail({Key? key,required this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('FIY')),
      body: Column(
        children: [
          Text(dataModel.phone_number,),
          Text(dataModel.orderid),
          Text(dataModel.orderdate),


        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:Fiy/DataModel.dart';
import 'package:intl/intl.dart' as intl;

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
intl.DateFormat dateFormat= new intl.DateFormat("dd-MM-yyyy");
class OrderDetail extends StatelessWidget {
  final OrderModel dataModel;
  const OrderDetail({Key? key,required this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('FIY')),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
         elevation: 50,
         shadowColor: Colors.black,
         color: Colors.greenAccent[100],
         child: SizedBox(
          width: 300,
          height: 500,
           child: Padding(
          padding: const EdgeInsets.all(30.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               "Order Details:",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Order Id: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataModel.Id,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  Text(
                    "Full Name: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataModel.FullName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ],

              ),

              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "PhoneNo: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataModel.Phone,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Email: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataModel.Email,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "OrderDate: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dateFormat.format(new intl.DateFormat("yyyy-MM-dd").parse(dataModel.OrderDateAndTime)),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OrderAddress: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataModel.OrderAddress,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "OrderCost: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataModel.OrderCost+"₹",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "EstAmt: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataModel.EstAmt+"₹",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

                 ],
          ),
        ),
        ),
        ),
      ),
    );
  }
}
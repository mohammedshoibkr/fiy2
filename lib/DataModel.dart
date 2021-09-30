class DataModel{
   late final String name, phone_number,orderid,orderdate;

   DataModel(this.name,this.phone_number,this.orderid,this.orderdate);
}

class OrderModel{
 final String Id,Phone,FullName,OrderDateAndTime,OrderCost,OrderAddress,Email,EstAmt;

OrderModel(this.Id,this.Phone,this.FullName,this.OrderDateAndTime,this.OrderCost,this.OrderAddress,this.Email,this.EstAmt);
}
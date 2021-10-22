class Address{
  late String name;
  late String address;
  late String rating;
  static const String ph_name="name";
  static const String ph_address="address";
  static const String ph_rating="rating";

  Address({ required this.name, required this.address, required this.rating});

  Map<String,dynamic> toMap(){
    return{
      "name":this.name,
      "address":this.address,
      "rating":this.rating,
    };

  }

}
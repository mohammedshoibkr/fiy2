class ProflieModle{
final String? phno;
final String name;
final String gender;
final String age;
final String? imgurl;

ProflieModle({ required this.name, required this.gender, required this.age,required this.imgurl,required this.phno});

Map<String,dynamic> toMap(){
  return{
    "name":this.name,
    "gender":this.gender,
    "age":this.age,
    "image":this.imgurl,
    "phone_number":this.phno,
  };

}

}
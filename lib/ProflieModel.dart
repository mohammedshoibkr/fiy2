class ProflieModel{
final String? phno;
late String name;
late String gender;
late String age;
late String imgurl;
static const String ph_key="phone_number";
static const String ph_name="name";
static const String ph_gender="gender";
static const String ph_age="age";
static const String ph_img="image";

ProflieModel({ required this.name, required this.gender, required this.age,required this.imgurl,required this.phno});

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
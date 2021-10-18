import 'package:Fiy/proflie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Fiy/DashBoard.dart';
import 'ProflieModel.dart';
import 'main.dart';


class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}
class Nav extends StatelessWidget {
  const Nav({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NavBar(),
    );
  }
}

class _NavBarState extends State<NavBar> {
  @override

  void initState() {
    SharedPreferences sharedPreferences;
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      ph = sp.getString(ProflieModel.ph_key);
      FirebaseFirestore.instance
          .collection('users')
          .where(ProflieModel.ph_key, isEqualTo: ph)
          .get().then((value)  {
        userDocId = value.docs[0].id;
      register = ProflieModel(phno: value.docs[0].data()[ProflieModel.ph_key],name: value.docs[0].data()[ProflieModel.ph_name], gender:  value.docs[0].data()[ProflieModel.ph_gender], age: value.docs[0].data()[ProflieModel.ph_age],imgurl:  value.docs[0].data()[ProflieModel.ph_img]);
      /*Timer(Duration(seconds: 2), () =>
          Get.to(ph != null ? Proflie() : MyHomePage()));*/
      setState(() {});
    });
  });
        }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(accountName: Text(register!.name),
            accountEmail: Text(ph!),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home '),
            onTap: () => {},
          ),

          ListTile(
            leading: Icon(Icons.people_alt_sharp),
            title: Text('Profile'),
            onTap: () => {
              Get.to(Proflie()),
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => {
              Get.to(DashBoard()),
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              SharedPreferences sharedPreferences;
              SharedPreferences.getInstance().then((SharedPreferences sp) {
                sp.remove(ProflieModel.ph_key);
                Get.to(MyHomePage());
              });
            },
          ),
        ],
      ),
    );
  }
}


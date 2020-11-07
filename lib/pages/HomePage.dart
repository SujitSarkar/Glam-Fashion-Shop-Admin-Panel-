import 'package:admin_panel_gs/pages/AddAdminPage.dart';
import 'package:admin_panel_gs/pages/LoginPage.dart';
import 'package:admin_panel_gs/pages/MaintainPointPage.dart';
import 'package:admin_panel_gs/pages/MaintainProductPage.dart';
import 'package:admin_panel_gs/pages/AddNewProduct.dart';
import 'package:admin_panel_gs/pages/NewOrderPage.dart';
import 'package:admin_panel_gs/pages/ShippedOrderPage.dart';
import 'package:admin_panel_gs/pages/UserDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text("Glam Shop"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.grey[200],
              ),
              onPressed: () async{
                SharedPreferences preferences = await SharedPreferences.getInstance();
                preferences.clear().then((value){
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LogIn()), (route) => false);
                });

              })
        ],
      ),
      body: homeUI(context),
    );
  }

  Widget homeUI(BuildContext context) {
    return Center(
      child: GridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: [

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct()));
            },
            child: Container(
              color: Colors.orange[100],
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.post_add, size: 50.0, color: Colors.deepOrange),
                  Text(
                    "Add New Product",
                    style: TextStyle(fontSize: 18.0, color: Colors.deepOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MaintainProduct()));
            },
            child: Container(
              color: Colors.orange[100],
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.update_outlined, size: 50.0, color: Colors.deepOrange),
                  Text(
                    "Maintain Product",
                    style: TextStyle(fontSize: 18.0, color: Colors.deepOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewOrder()));
            },
            child: Container(
              color: Colors.orange[100],
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_rounded,
                      size: 50.0, color: Colors.deepOrange),
                  Text(
                    "New Order List",
                    style: TextStyle(fontSize: 18.0, color: Colors.deepOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ShippedOrder()));
            },
            child: Container(
              color: Colors.orange[100],
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 50.0, color: Colors.deepOrange),
                  Text(
                    "Shipped Order",
                    style: TextStyle(fontSize: 18.0, color: Colors.deepOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserDetails()));
            },
            child: Container(
              color: Colors.orange[100],
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle_outlined,
                      size: 50.0, color: Colors.deepOrange),
                  Text(
                    "User Details",
                    style: TextStyle(fontSize: 18.0, color: Colors.deepOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MaintainPoint()));
            },
            child: Container(
              color: Colors.orange[100],
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.widgets_rounded,
                      size: 50.0, color: Colors.deepOrange),
                  Text(
                    "Update Reward Coin",
                    style: TextStyle(fontSize: 18.0, color: Colors.deepOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAdmin()));
            },
            child: Container(
              color: Colors.orange[100],
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.security_outlined,
                      size: 50.0, color: Colors.deepOrange),
                  Text(
                    "Add Admin",
                    style: TextStyle(fontSize: 18.0, color: Colors.deepOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
            },
            child: Container(
              color: Colors.orange[100],
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.details_outlined,
                      size: 50.0, color: Colors.deepOrange),
                  Text(
                    "About Us",
                    style: TextStyle(fontSize: 18.0, color: Colors.deepOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

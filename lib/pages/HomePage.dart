import 'package:admin_panel_gs/pages/LoginPage.dart';
import 'package:admin_panel_gs/pages/MaintainProductPage.dart';
import 'package:admin_panel_gs/pages/AddNewProduct.dart';
import 'package:flutter/material.dart';

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
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LogIn()), (route) => false);
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
              color: Colors.white,
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
              color: Colors.white,
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
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewCustomer()));
            },
            child: Container(
              color: Colors.white,
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
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewCustomer()));
            },
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart_rounded,
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
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
            },
            child: Container(
              color: Colors.white,
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

import 'package:admin_panel_gs/pages/HomePage.dart';
import 'package:admin_panel_gs/shared/formDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoading = false;
  final _formKye = GlobalKey<FormState>();
  String phone, password;
  String wrongMgs="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        title: Text("Admin Panel"),
        centerTitle: true,
      ),
      body: logInBody(),
    );
  }

  Widget logInBody() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKye,
            child: Column(
              children: [
                TextFormField(
                  decoration: textInputDecoration,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() => phone = value);
                  },
                  validator: (value) =>
                      value.isEmpty ? "Enter phone number" : null,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                      prefixIcon: Icon(Icons.security_outlined),
                    hintText: "Password"
                  ),
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                  validator: (value) => value.isEmpty ? "Enter password" : null,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepOrange, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 110,
                  height: 40,
                  child: FlatButton(
                    splashColor: Colors.deepOrange[200],
                      onPressed: (){
                      if(_formKye.currentState.validate()){
                        setState(() => isLoading = true);
                        handleLogIn();
                      }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.login_outlined,
                            color: Colors.deepOrange,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Login",
                            style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 10,),
                Container(
                  child: Text(wrongMgs,style: TextStyle(color: Colors.red),),
                ),
                SizedBox(height: 10,),
                isLoading ? dualRing() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future handleLogIn() async{
    final QuerySnapshot querySnapshot = await Firestore.instance
        .collection("Admins").where('phone', isEqualTo: phone)
        .getDocuments();
    final List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;

    if(documentSnapshot.length == 0){
      setState(() {
        isLoading = false;
        wrongMgs = "Wrong phone number";
      });
    }
    else{
      if(documentSnapshot[0]['password'] == password){
        setState(() {
          isLoading = false;
          wrongMgs = "";
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      }
      else{
        setState(() {
          isLoading = false;
          wrongMgs = "Wrong password";
        });
      }
    }
  }
}

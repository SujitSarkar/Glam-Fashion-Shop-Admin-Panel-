import 'package:admin_panel_gs/shared/formDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController mainAdminPhoneController = TextEditingController();
  TextEditingController mainAdminPasswordController = TextEditingController();
  TextEditingController newAdminPhoneController = TextEditingController();
  TextEditingController newAdminPasswordController = TextEditingController();
  bool isLoading = true;
  List mainAdmin = [];
  String mainAdminPhone,mainAdminPassword,newAdminPhone,newAdminPassword;
  String errorMgs = "";
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMainAdmin();
  }
  
  Future getMainAdmin() async{
    final QuerySnapshot querySnapshot = await Firestore.instance.collection("Admins")
        .where('phone', isEqualTo: '01929444532').getDocuments();
    mainAdmin = querySnapshot.documents;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Add New Admin"),
        elevation: 0,
      ),

      body: isLoading? dualRing(): bodyUI(context),
    );
  }

  Widget bodyUI(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              SizedBox(height: size.height / 20),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Only main admin can add new admin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.deepOrange, fontSize: size.width/15,fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: size.height / 20),

              TextFormField(
                keyboardType: TextInputType.number,
                controller: mainAdminPhoneController,
                validator: (value)=> value.isEmpty ? "Enter admin phone" : null,
                decoration: productInputDecoration.copyWith(
                    hintText: 'Main admin phone number'),
                onChanged: (value) {
                  setState(() => mainAdminPhone = value);
                },
              ),
              SizedBox(height: size.height / 30),

              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.text,
                controller: mainAdminPasswordController,
                validator: (value)=> value.isEmpty ? "Enter admin password" : null,
                decoration: productInputDecoration.copyWith(
                    hintText: 'Main admin password'),
                onChanged: (value) {
                  setState(() => mainAdminPassword = value);
                },
              ),
              SizedBox(height: size.height / 30),

              TextFormField(
                keyboardType: TextInputType.number,
                controller: newAdminPhoneController,
                validator: (value)=> value.isEmpty ? "Enter new admin phone" : null,
                decoration: productInputDecoration.copyWith(
                    hintText: 'New admin phone'),
                onChanged: (value) {
                  setState(() => newAdminPhone = value);
                },
              ),
              SizedBox(height: size.height / 30),

              TextFormField(
                keyboardType: TextInputType.text,
                controller: newAdminPasswordController,
                validator: (value)=> value.isEmpty ? "Enter new admin password" : null,
                decoration: productInputDecoration.copyWith(
                    hintText: 'new admin password'),
                onChanged: (value) {
                  setState(() => newAdminPassword = value);
                },
              ),
              SizedBox(height: size.height / 25),

              RaisedButton(
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    if(mainAdmin[0]['phone']==mainAdminPhone && mainAdmin[0]['password']==mainAdminPassword){
                      setState(() {
                        isLoading = true;
                        errorMgs = "";
                      });
                      addNewAdmin();
                    }
                    else{
                      setState(() {
                        errorMgs = "Wrong main admin phone or password";
                      });
                    }
                  }
                },
                child: Text("Add",style: TextStyle(color: Colors.white),),
                color: Colors.deepOrange,
              ),
              SizedBox(height: size.height / 30),

              Container(
                child: Text(errorMgs, style: TextStyle(color: Colors.red),),
              ),
              SizedBox(height: size.height / 30),
            ],
          ),
        ),
      ),
    );
  }

  Future addNewAdmin() async{
    Firestore.instance.collection("Admins").document(newAdminPhone).setData({
      'phone': newAdminPhone,
      'password': newAdminPassword,
    }).then((value){
      setState(() {
        isLoading = false;
        errorMgs = "";
      });
      ///Show Alert Dialog....
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              title: Text("New admin added",textAlign: TextAlign.center),
              content: FlatButton(
                color: Colors.deepOrange,
                onPressed: ()=> Navigator.of(context).pop(),
                splashColor: Colors.deepOrange[300],
                child: Text("Close",style: TextStyle(color: Colors.white),),
              ),
            );
          }
      );
    },onError: (error){
      ///Show Alert Dialog....
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              title: Text("$error",textAlign: TextAlign.center),
              content: FlatButton(
                color: Colors.deepOrange,
                onPressed: ()=> Navigator.of(context).pop(),
                splashColor: Colors.deepOrange[300],
                child: Text("Close",style: TextStyle(color: Colors.white),),
              ),
            );
          }
      );
    });
  }
}

import 'package:admin_panel_gs/shared/formDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'AddAdminPage.dart';

class MaintainAdmin extends StatefulWidget {
  @override
  _MaintainAdminState createState() => _MaintainAdminState();
}

class _MaintainAdminState extends State<MaintainAdmin> {
  bool isLoading = true;
  List adminList = [];
  List mainAdminList = [];
  bool isDeleting = false;
  String adminPhn,adminPassword;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMainAdmin();
  }

  Future fetchMainAdmin() async {
    final QuerySnapshot resultQuery =
    await Firestore.instance
        .collection("Admins").where('phone', isEqualTo: '01929444532')
        .getDocuments();
    mainAdminList = resultQuery.documents;
    fetchAdmin();
  }

  Future fetchAdmin() async {
    final QuerySnapshot resultQuery =
    await Firestore.instance
        .collection("Admins")
        .getDocuments();
    adminList = resultQuery.documents;

    if (adminList.length != null) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Maintain Admin'),
        elevation: 0,
      ),
      body: isLoading ? dualRing() : mainList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddAdmin()));
        },
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  Widget mainList(BuildContext context) {
    fetchAdmin();
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ListView.builder(
          itemCount: adminList.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 5, top: 5),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(
                  Icons.person, color: Colors.deepOrange, size: 35,),
                title: Text("${adminList[index]['phone']}"),
                trailing: IconButton(
                  onPressed: () {
                    deleteConfirmation(context, adminList[index]['phone']);
                  },
                  icon: Icon(Icons.delete, color: Colors.redAccent,),
                ),
              ),
            );
          }),
    );
  }

  void deleteConfirmation(BuildContext context, String id) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: size.height,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Delete this product?",
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                  ),
                ),
                SizedBox(height: 20.0),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value)=> value.isEmpty ? "Enter admin phone" : null,
                        onChanged: (val){
                          setState(() {
                            adminPhn = val;
                          });
                        },
                        decoration: productInputDecoration.copyWith(
                            hintText: 'Main admin phone number'),
                      ),
                      SizedBox(height: 10.0),

                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (value)=> value.isEmpty ? "Enter admin password" : null,
                        onChanged: (val){
                          setState(() {
                            adminPassword = val;
                          });
                        },
                        decoration: productInputDecoration.copyWith(
                            hintText: 'Main admin password'),
                      ),
                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 30.0,
                              ),
                              onPressed: () {
                                if(_formKey.currentState.validate()){
                                  if(adminPhn==mainAdminList[0]['phone']&&adminPassword==mainAdminList[0]['password']){
                                    Navigator.of(context).pop();
                                    setState(() {
                                      isLoading=true;
                                    });
                                    Firestore.instance.collection('Admins').document(id).delete().then((value){
                                      setState(() {
                                        isLoading=false;
                                      });
                                    });
                                  }
                                  else{
                                    setState(() => isLoading=false);
                                    ///Show Alert Dialog....
                                    showDialog(context: context,
                                        barrierDismissible: false,
                                        builder: (context){
                                          return AlertDialog(
                                            title: Text("Wrong phone or password",textAlign: TextAlign.center, style: TextStyle(color: Colors.red),),
                                            content: FlatButton(
                                              color: Colors.deepOrange,
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              splashColor: Colors.green[300],
                                              child: Text("Close",style: TextStyle(color: Colors.white),),
                                            ),
                                          );
                                        }
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 40.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 30.0,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ),

              ],
            ),
          );
        });
  }
}

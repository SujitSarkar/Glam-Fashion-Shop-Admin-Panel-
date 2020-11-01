import 'package:admin_panel_gs/shared/formDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaintainPoint extends StatefulWidget {
  @override
  _MaintainPointState createState() => _MaintainPointState();
}

class _MaintainPointState extends State<MaintainPoint> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController pointController = TextEditingController();
  bool isLoading = true;
  List points = [];
  String changedPoint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreviousPoint();
  }

  Future getPreviousPoint() async {
    final QuerySnapshot querySnapshot =
        await Firestore.instance.collection("Point per video").getDocuments();
    points = querySnapshot.documents;
    retrieveData();
  }

  void retrieveData() {
    pointController = TextEditingController(text: "${points[0]['point']}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Update User Point Limit"),
        elevation: 0,
      ),
      body: isLoading? dualRing(): bodyUI(context),
    );
  }

  Widget bodyUI(BuildContext context) {
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
                  "Set reward point per video",
                  style: TextStyle(
                      color: Colors.deepOrange, fontSize: size.width/15,fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: size.height / 20),

              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Reward point:",
                  style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: pointController,
                validator: (value)=> value.isEmpty ? "Enter point" : null,
                decoration: productInputDecoration.copyWith(
                    hintText: 'Reward point'),
                onChanged: (value) {
                  setState(() => changedPoint = value);
                },
              ),
              SizedBox(height: size.height / 25),
              
              RaisedButton(
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    setState(() {
                      isLoading = true;
                    });
                    updatePoint();
                  }
                },
                child: Text("Update",style: TextStyle(color: Colors.white),),
                color: Colors.deepOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future updatePoint() async{

    dynamic pnt;
    if(changedPoint==null){
      pnt = points[0]['point'];
    }
    else{pnt= double.parse(changedPoint);}

    Firestore.instance.collection("Point per video").document("point").setData({
      'point': pnt,
    }).then((value){
      ///Show Alert Dialog....
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              title: Text("Point updated"),
              content: FlatButton(
                color: Colors.deepOrange,
                onPressed: ()=> Navigator.of(context).pop(),
                splashColor: Colors.deepOrange[300],
                child: Text("Close",style: TextStyle(color: Colors.white),),
              ),
            );
          }
      );
      setState(() {
        isLoading = false;
      });
    },onError: (errMgs){
      ///Show Alert Dialog....
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              title: Text("$errMgs"),
              content: FlatButton(
                color: Colors.deepOrange,
                onPressed: ()=> Navigator.of(context).pop(),
                splashColor: Colors.deepOrange[300],
                child: Text("Close",style: TextStyle(color: Colors.white),),
              ),
            );
          }
      );
      setState(() {
        isLoading = false;
      });
    });
  }
}

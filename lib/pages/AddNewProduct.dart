import 'dart:io';
//import 'dart:async';
import 'package:admin_panel_gs/shared/formDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool isSearch = false, isLoading = false;
  final _formKey = GlobalKey<FormState>();

  File _productImage;
  String _productName;
  String _productPrice;
  String _productDesc;
  String _category;
  String _availableSize;
  String _availableStock;

  String noImage = "";
  List<String> _categoryItems = ['Electronics', 'Food', 'Cloth', 'Shoes', 'Watch', 'Car', 'Cosmetics', 'Glass', 'Lock', 'Soap', 'Brush', 'Belt', 'Light', 'Furniture', 'Fuel', 'Headphone', 'Mobile', 'Cable'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        title: Text("Add New Product"),
        centerTitle: true,
      ),
      body: bodyUI(),
    );
  }

  Widget bodyUI() {
    return isLoading
        ? Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dualRing(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Saving Information, Please Wait....",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            color: Colors.transparent,
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    (_productImage == null)
                        ? Material(
                            child: Icon(
                              Icons.image,
                              size: MediaQuery.of(context).size.width*.9,
                              color: Colors.deepOrangeAccent[100]
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.0)),
                          )
                        : ClipRRect(
                            child: Image.file(
                              _productImage,
                              width: MediaQuery.of(context).size.width*.9,
                              height: 300,
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.0)),
                          ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      noImage,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    OutlineButton(
                        onPressed: takePhotoFromGallery,
                        highlightedBorderColor: Colors.deepOrange,
                        focusColor: Colors.deepOrange,
                        splashColor: Colors.deepOrange[200],
                        borderSide:
                            BorderSide(color: Colors.deepOrange, width: 2.0),
                        child: Container(
                          width: 113,
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Take Photo",
                                style: TextStyle(
                                  color: Colors.deepOrange[700],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: productInputDecoration.copyWith(
                          hintText: 'Product Name'),
                      validator: (value) =>
                          value.isEmpty ? "Enter Product Name" : null,
                      onChanged: (value) {
                        setState(() => _productName = value);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    TextFormField(
                      //textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.number,
                      decoration: productInputDecoration.copyWith(
                          hintText: 'Product Price'),
                      validator: (value) =>
                      value.isEmpty ? "Enter Product Price" : null,
                      onChanged: (value) {
                        setState(() => _productPrice = value);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    TextFormField(
                      //textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: productInputDecoration.copyWith(
                          hintText: 'Product Description'),
                      validator: (value) =>
                          value.isEmpty ? "Enter Product Description" : null,
                      onChanged: (value) {
                        setState(() => _productDesc = value);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      decoration: productInputDecoration.copyWith(
                          hintText: 'Product Category (eg. Cloth)'),
                      validator: (value) =>
                          value.isEmpty ? "Enter Category" : null,
                      onChanged: (value) {
                        setState(() => _category = value);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    TextFormField(
                      //textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.number,
                      decoration: productInputDecoration.copyWith(
                          hintText: 'Available Stock'),
                      validator: (value) =>
                          value.isEmpty ? "Enter Available Stock" : null,
                      onChanged: (value) {
                        setState(() => _availableStock = value);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      keyboardType: TextInputType.text,
                      decoration: productInputDecoration.copyWith(
                          hintText: 'Available Size'),
                      onChanged: (value) {
                        setState(() => _availableSize = value);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      noImage,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepOrange, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 110,
                      height: 40,
                      child: FlatButton(
                          splashColor: Colors.deepOrange[300],
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if (_productImage != null) {
                                setState(() {
                                  isLoading = true;
                                  noImage = "";
                                });
                                saveDataToDatabase(context);
                              } else {
                                setState(() {
                                  noImage = "Select an Image";
                                });
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.save_outlined,
                                color: Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.deepOrange),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> takePhotoFromGallery() async {
    // ignore: deprecated_member_use
    File newImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImage != null) {
      setState(() {
        this._productImage = newImage;
        noImage="";
      });
    }
  }

  Future<void> saveDataToDatabase(BuildContext context) async{

    double point = double.parse(_productPrice.trim());

    String date = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child("Product Image").child(_category+date);
    StorageUploadTask storageUploadTask = storageReference.putFile(_productImage);
    StorageTaskSnapshot storageTaskSnapshot;

    storageUploadTask.onComplete.then((value) {
      if(value.error == null){
        storageTaskSnapshot = value;

        storageTaskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
          Firestore.instance.collection("Products").document(_category+date).setData({
            'id':_category+date,
            'name': _productName.trim(),
            'price': point,
            'description': _productDesc.trim(),
            'image': newImageDownloadUrl.toString(),
            'category': _category.trim(),
            'available stock': _availableStock.trim(),
            'size': _availableSize,
            'created date': date,
          }).then((value) {
            setState(() => isLoading = false);
            ///Show Alert Dialog....
            showDialog(context: context,
                barrierDismissible: false,
                builder: (context){
                  return AlertDialog(
                    title: Text("Product Added successfully"),
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
        },onError: (errorMgs){
          setState(() => isLoading = false);
          ///Show Alert Dialog....
          showDialog(context: context,
              barrierDismissible: false,
              builder: (context){
                return AlertDialog(
                  title: Text(errorMgs.toString()),
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
    });
  }

}

import 'dart:ffi';
import 'dart:io';

import 'package:admin_panel_gs/shared/formDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProduct extends StatefulWidget {
  final String id;
  final String productImage;
  final String productName;
  final dynamic productPrice;
  final String productDesc;
  final String availableSize;
  final String availableStock;

  UpdateProduct(
      {this.id,
        this.productImage,
      this.productName,
      this.productPrice,
      this.productDesc,
      this.availableSize,
      this.availableStock});

  @override
  _UpdateProductState createState() => _UpdateProductState(
      this.id,
      this.productImage,
      this.productName,
      this.productPrice,
      this.productDesc,
      this.availableSize,
      this.availableStock);
}

class _UpdateProductState extends State<UpdateProduct> {
  String _id;
  String _productImage;
  String _productName;
  dynamic _productPrice;
  String _productDesc;
  String _availableSize;
  String _availableStock;

  _UpdateProductState(this._id,this._productImage, this._productName, this._productPrice,
      this._productDesc, this._availableSize, this._availableStock);

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  File imageFile;
  String loadingMgs;
  String changedProductPoint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrivePreviousData();
  }

  void retrivePreviousData() {
    nameController = TextEditingController(text: _productName);
    priceController = TextEditingController(text: "$_productPrice");
    descController = TextEditingController(text: _productDesc);
    sizeController = TextEditingController(text: _availableSize);
    stockController = TextEditingController(text: _availableStock);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Update Product"),
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
                  SizedBox(height: 10,),
                  Text(
                    "$loadingMgs, please wait",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            color: Colors.transparent,
          )
        : Container(
            margin: EdgeInsets.all(10),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        (imageFile == null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Image.network(
                                  _productImage,
                                  width: MediaQuery.of(context).size.width*.9,
                                  height: 300,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Image.file(
                                  imageFile,
                                  width: MediaQuery.of(context).size.width*.9,
                                  height: 300,
                                  fit: BoxFit.fitHeight,
                                ),
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
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("Product Name : ",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600])),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: nameController,
                          validator: (value)=> value.isEmpty? "Enter product name":null,
                          decoration: productInputDecoration.copyWith(
                              hintText: 'Product Name'),
                          onChanged: (value) {
                            setState(() => _productName = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("Product Point : ",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600])),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: priceController,
                          validator: (value)=> value.isEmpty? "Enter product Point":null,
                          decoration: productInputDecoration.copyWith(
                              hintText: 'Product Point'),
                          onChanged: (value) {
                            setState(() => changedProductPoint = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("Product Description : ",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600])),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          controller: descController,
                          validator: (value)=> value.isEmpty? "Enter product description":null,
                          decoration: productInputDecoration.copyWith(
                              hintText: 'Product Description'),
                          onChanged: (value) {
                            setState(() => _productDesc = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("Available Stock : ",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600])),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: stockController,
                          validator: (value)=> value.isEmpty? "Enter stock":null,
                          decoration: productInputDecoration.copyWith(
                              hintText: 'Available Stock'),
                          onChanged: (value) {
                            setState(() => _availableStock = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("Available Size : ",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600])),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.text,
                          controller: sizeController,
                          decoration: productInputDecoration.copyWith(
                              hintText: 'Available Size'),
                          onChanged: (value) {
                            setState(() => _availableSize = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: OutlineButton(
                                  onPressed: () {
                                    if(_formKey.currentState.validate()){
                                      if(imageFile == null){
                                        setState((){ isLoading = true;loadingMgs="Updating";});
                                        updateWithoutImage();
                                      }
                                      else{
                                        setState(() { isLoading = true;loadingMgs="Updating";});
                                        updateWithImage();
                                      }
                                    }
                                  },
                                  highlightedBorderColor: Colors.green,
                                  focusColor: Colors.green,
                                  splashColor: Colors.green[200],
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 2.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.update_outlined,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Update",
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: OutlineButton(
                                  onPressed: () {
                                    deleteConfirmation(context);
                                  },
                                  highlightedBorderColor: Colors.red,
                                  focusColor: Colors.red,
                                  splashColor: Colors.red[200],
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.deepOrange[700],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Future<void> takePhotoFromGallery() async {
    // ignore: deprecated_member_use
    File newImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImage != null) {
      setState(() {
        this.imageFile = newImage;
      });
    }
  }

  Future<void> updateWithoutImage() async {

    dynamic point;
    if(changedProductPoint==null){
      point = _productPrice;
    }
    else{point= double.parse(changedProductPoint);}

    Firestore.instance.collection("Products").document(_id).updateData({
      "name": _productName,
      "description": _productDesc,
      "price": point,
      "available stock": _availableStock,
      "size": _availableSize,
    }).then((data) async{
      setState(() => isLoading=false);
      ///Show Alert Dialog....
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              title: Text("Product updated"),
              content: FlatButton(
                color: Colors.deepOrange,
                onPressed: ()=> Navigator.of(context).pop(),
                splashColor: Colors.deepOrange[300],
                child: Text("Close",style: TextStyle(color: Colors.white),),
              ),
            );
          }
      );

    },onError: (errorMgs){
      print(errorMgs.toString());
      setState(() => isLoading=false);
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

  Future<void> updateWithImage() async {
    dynamic point;
    if(changedProductPoint== null){
      point = _productPrice;
    }
    else{point= double.parse(changedProductPoint);}

    StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Product Image").child(_id);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot;

    storageUploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;

        storageTaskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
          Firestore.instance.collection("Products").document(_id).updateData({
            "name": _productName,
            "description": _productDesc,
            "price": point,
            "available stock": _availableStock,
            "size": _availableSize,
            "image": newImageDownloadUrl,
          }).then((data) async {
            setState(() => isLoading = false);
            ///Show Alert Dialog....
            showDialog(context: context,
                barrierDismissible: false,
                builder: (context){
                  return AlertDialog(
                    title: Text("Product updated"),
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
        }, onError: (errorMsg) {
          setState(() => isLoading = false);
          ///Show Alert Dialog....
          showDialog(context: context,
              barrierDismissible: false,
              builder: (context){
                return AlertDialog(
                  title: Text(errorMsg.toString()),
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

  Future<void> deleteProduct() async{
    FirebaseStorage.instance
        .ref()
        .child("Product Image")
        .child(_id)
        .delete()
        .then((value) {
      Firestore.instance
          .collection("Products")
          .document(_id)
          .delete();
      setState(() => isLoading = false);
      Navigator.of(context).pop();
    }, onError: (errorMgs) {
      print(errorMgs.toString());
      setState(() => isLoading = false);
    });
  }

  void deleteConfirmation(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 110,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
            decoration: modalDecoration,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Delete this product?",
                    style:
                    TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
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
                          setState((){isLoading=true;loadingMgs="Deleting";});
                          Navigator.of(context).pop();
                          deleteProduct();
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
            ),
          );
        });
  }
}

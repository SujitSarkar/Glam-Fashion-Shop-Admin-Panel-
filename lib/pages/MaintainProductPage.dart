import 'package:admin_panel_gs/pages/UpdateProductPage.dart';
import 'package:admin_panel_gs/shared/DatabaseManager.dart';
import 'package:admin_panel_gs/shared/formDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MaintainProduct extends StatefulWidget {
  @override
  _MaintainProductState createState() => _MaintainProductState();
}

class _MaintainProductState extends State<MaintainProduct> {
  TextEditingController searchEditingController = TextEditingController();
  bool isSearch = false, isLoading = true;
  String searchQuery;

  List productList=[];
  List searchedProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProducts();
  }

  getAllProducts() async {
    final QuerySnapshot resultQuery =
        await Firestore.instance.collection("Products").getDocuments();
    productList = resultQuery.documents;

    if (productList.length != null) {
      setState(() {
        isLoading = false;
      });
    } else {
      print("Product List is Empty");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: customAppBar(),
      body: isLoading
          ? dualRing()
          : isSearch
              ? customSearch(context)
              : productList.length == 0
                  ? noDataFoundMgs()
                  : mainList(context),
    );
  }

  customAppBar() {
    return AppBar(
      elevation: 0,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.text,
          cursorColor: Colors.white,
          style: TextStyle(fontSize: 17, color: Colors.white),
          controller: searchEditingController,
          decoration: InputDecoration(
            hintText: 'Search By Name...',
            hintStyle: TextStyle(color: Colors.grey[300]),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5),
            ),
            filled: false,
            suffixIcon: IconButton(
              splashRadius: 25,
              icon: Icon(
                Icons.clear,
                color: Colors.grey[300],
              ),
              onPressed: () {
                searchEditingController.clear();
                setState(() {
                  isSearch = false;
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              if (searchQuery == "") {
                isSearch = false;
              } else {
                isSearch = true;
              }
            });
          },
        ),
      ),
    );
  }

  Widget noDataFoundMgs() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
            size: 70.0,
          ),
          Text(
            "No Products",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget mainList(BuildContext context) {
    getAllProducts();
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey[200],
      child: GridView.builder(
        itemCount: productList.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.6),
        itemBuilder: (context, index) => Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProduct(
                            id: productList[index]['id'],
                            productImage: productList[index]['image'],
                            productName: productList[index]['name'],
                            productDesc: productList[index]['description'],
                            productPrice: productList[index]['price'],
                            availableStock: productList[index]
                                ['available stock'],
                            availableSize: productList[index]['size'],
                          )));
            },
            onLongPress: () {
              deleteConfirmation(context, productList[index]['id']);
            },
            splashColor: Colors.deepOrange[200],
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.network(
                    productList[index]['image'],
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    child: ListTile(
                  contentPadding: EdgeInsets.all(5),
                  title: Text(
                    productList[index]['name'],
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Point:  ${productList[index]['price']}",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Stock: " + productList[index]['available stock'],
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
        //reverse: true,
        //scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget customSearch(BuildContext context) {
    fetchSearchProducts();
    return searchedProducts.length == 0
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 70.0,
                ),
                Text(
                  "No Products",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[200],
            child: GridView.builder(
              itemCount: searchedProducts.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6),
              //reverse: true,
              //scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProduct(
                                  id: searchedProducts[index]['id'],
                                  productImage: searchedProducts[index]
                                      ['image'],
                                  productName: searchedProducts[index]['name'],
                                  productDesc: searchedProducts[index]
                                      ['description'],
                                  productPrice: searchedProducts[index]
                                      ['price'],
                                  availableStock: searchedProducts[index]
                                      ['available stock'],
                                  availableSize: searchedProducts[index]
                                      ['size'],
                                )));
                  },
                  onLongPress: () {
                    deleteConfirmation(context, searchedProducts[index]['id']);
                  },
                  splashColor: Colors.deepOrange[200],
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Image.network(
                          searchedProducts[index]['image'],
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          child: ListTile(
                        contentPadding: EdgeInsets.all(5),
                        title: Text(
                          searchedProducts[index]['name'],
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Point:  ${searchedProducts[index]['price']}",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Stock: " +
                                      searchedProducts[index]
                                          ['available stock'],
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void deleteConfirmation(BuildContext context, String id) {
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
                          setState((){isLoading=true;});
                          Navigator.of(context).pop();
                          FirebaseStorage.instance
                              .ref()
                              .child("Product Image")
                              .child(id)
                              .delete()
                              .then((value) {
                            Firestore.instance
                                .collection("Products")
                                .document(id)
                                .delete();
                            getAllProducts();
                            fetchSearchProducts();
                            Navigator.of(context).pop();
                          }, onError: (errorMgs) {
                            print(errorMgs.toString());
                          });
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

  Future fetchSearchProducts() async {
    dynamic results = await DatabaseManager().getProducts(searchQuery);
    setState(() {
      searchedProducts = results;
    });
  }
}

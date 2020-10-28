import 'package:admin_panel_gs/shared/DatabaseManager.dart';
import 'package:admin_panel_gs/shared/formDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewOrder extends StatefulWidget {
  @override
  _NewOrderState createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  TextEditingController searchEditingController = TextEditingController();
  bool isSearch = false, isLoading = true;
  String searchQuery;
  List newOrderList = [];
  List searchedOrder = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNewOrder();
  }

  Future fetchNewOrder() async{
    dynamic result = await DatabaseManager().getNewOrder();
    if(result != null){
      setState(() {
        newOrderList = result;
        isLoading = false;
      });
    }
  }
  Future fetchSearchProducts() async {
    searchedOrder.clear();
    for(int i=0; i<newOrderList.length; i++){
      if(newOrderList[i]['ordered phone']==searchQuery){
        searchedOrder.add(newOrderList[i]);
      }
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
              : newOrderList.length==0
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
          //textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.number,
          cursorColor: Colors.white,
          style: TextStyle(fontSize: 17, color: Colors.white),
          controller: searchEditingController,
          decoration: InputDecoration(
            hintText: 'Search by phone number',
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
                Icons.search_rounded,
                color: Colors.grey[300],
              ),
              onPressed: () {
                setState(() {
                  isSearch = true;
                });
              },
            ),
          ),
          onFieldSubmitted: (value){
            setState(() {
              searchQuery = value;
              isSearch = true;
            });
          },
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              if (searchQuery == "") {
                isSearch = false;
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
            "No new order",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget mainList(BuildContext context) {
    fetchNewOrder();
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ListView.builder(
          itemCount: newOrderList.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 20, top: 10),
              child: Column(
                children: [
                  ///Product Image....
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      newOrderList[index]['product image'],
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitHeight,
                    ),
                  ),

                  ///Product Name....
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      newOrderList[index]['product name'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[800]),
                    ),
                  ),

                  ///Product Quantity....
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Quantity: ${newOrderList[index]['product quantity']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Product Unit Point....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Unit Point: ${newOrderList[index]['unit point']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Total Point....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Total Point: ${newOrderList[index]['total point']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Product Size
                  newOrderList[index]['product size'] == null
                      ? Container()
                      : Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Ordered size: ${newOrderList[index]['product size']}",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Ordered Time....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Order date: ${DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(newOrderList[index]['ordered date'])))}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Customer Phone....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Customer phone: ${newOrderList[index]['ordered phone']}",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Customer Name....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Customer name: ${newOrderList[index]['customer name']}",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Customer Address....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Address: ${newOrderList[index]['customer address']}",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  OutlineButton(
                      onPressed: () {
                        ///Show Alert Dialog....
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context){
                              return AlertDialog(
                                title: Text("Shipped this product?"),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FlatButton(
                                      color: Colors.green,
                                      onPressed: (){
                                        Firestore.instance
                                            .collection(newOrderList[index]['customer phone'])
                                            .document(newOrderList[index]['customer cartList id']).updateData({
                                        'delivery report': "shipped",
                                        }).then((value) {
                                          Firestore.instance
                                              .collection("Customer Order")
                                              .document(newOrderList[index]['id'])
                                              .updateData({
                                            'delivery report': "shipped",
                                          });
                                          Navigator.of(context).pop();
                                        },onError: (errorMgs){print(errorMgs.toString());});
                                      },
                                      splashColor: Colors.green[300],
                                      child: Text("Yes",style: TextStyle(color: Colors.white),),
                                    ),
                                    SizedBox(width: 10,),
                                    FlatButton(
                                      color: Colors.deepOrange,
                                      onPressed: ()=> Navigator.of(context).pop(),
                                      splashColor: Colors.deepOrange[300],
                                      child: Text("No",style: TextStyle(color: Colors.white),),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      },
                      highlightedBorderColor: Colors.green,
                      focusColor: Colors.green,
                      splashColor: Colors.green[200],
                      borderSide: BorderSide(
                          color: Colors.green, width: 2.0),
                      child: Container(
                        child: Text(
                          "Product Shipped",
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 16,
                          ),
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }

  Widget customSearch(BuildContext context) {
    fetchSearchProducts();
    return searchedOrder.length == 0
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
                  "No order found by this number",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
              ],
            ),
          )
        : Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ListView.builder(
          itemCount: searchedOrder.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 20, top: 10),
              child: Column(
                children: [
                  ///Product Image....
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      searchedOrder[index]['product image'],
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitHeight,
                    ),
                  ),

                  ///Product Name....
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      searchedOrder[index]['product name'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[800]),
                    ),
                  ),

                  ///Product Quantity....
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Quantity: ${searchedOrder[index]['product quantity']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Product Unit Point....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Unit Point: ${searchedOrder[index]['unit point']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Total Point....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Total Point: ${searchedOrder[index]['total point']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Product Size
                  searchedOrder[index]['product size'] == null
                      ? Container()
                      : Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Ordered size: ${searchedOrder[index]['product size']}",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Ordered Time....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Order date: ${DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(searchedOrder[index]['ordered date'])))}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Customer Phone....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Customer phone: ${searchedOrder[index]['ordered phone']}",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Customer Name....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Customer name: ${searchedOrder[index]['customer name']}",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Customer Address....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Address: ${searchedOrder[index]['customer address']}",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  OutlineButton(
                      onPressed: () {
                        ///Show Alert Dialog....
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context){
                              return AlertDialog(
                                title: Text("Shipped this product?"),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FlatButton(
                                      color: Colors.green,
                                      onPressed: (){
                                        Firestore.instance
                                            .collection(searchedOrder[index]['customer phone'])
                                            .document(searchedOrder[index]['customer cartList id']).updateData({
                                          'delivery report': "shipped",
                                        }).then((value) {
                                          Firestore.instance
                                              .collection("Customer Order")
                                              .document(searchedOrder[index]['id'])
                                              .updateData({
                                            'delivery report': "shipped",
                                          });
                                          Navigator.of(context).pop();
                                        },onError: (errorMgs){print(errorMgs.toString());});
                                      },
                                      splashColor: Colors.green[300],
                                      child: Text("Yes",style: TextStyle(color: Colors.white),),
                                    ),
                                    SizedBox(width: 10,),
                                    FlatButton(
                                      color: Colors.deepOrange,
                                      onPressed: ()=> Navigator.of(context).pop(),
                                      splashColor: Colors.deepOrange[300],
                                      child: Text("No",style: TextStyle(color: Colors.white),),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      },
                      highlightedBorderColor: Colors.green,
                      focusColor: Colors.green,
                      splashColor: Colors.green[200],
                      borderSide: BorderSide(
                          color: Colors.green, width: 2.0),
                      child: Container(
                        child: Text(
                          "Product Shipped",
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 16,
                          ),
                        ),
                      )),

                ],
              ),
            );
          }),
    );
  }


}

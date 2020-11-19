import 'package:admin_panel_gs/shared/formDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  TextEditingController searchEditingController = TextEditingController();
  bool isSearch = false, isLoading = true;
  String searchQuery;
  List userList = [];
  List searchedUser = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    final QuerySnapshot resultQuery =
        await Firestore.instance.collection("Users")
            .orderBy('created date', descending: true).getDocuments();
    userList = resultQuery.documents;

    if (userList.length != null) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future fetchSearchUser() async {
    searchedUser.clear();
    for (int i = 0; i < userList.length; i++) {
      if (userList[i]['phone'] == searchQuery) {
        searchedUser.add(userList[i]);
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
              : userList.length == 0
                  ? noDataFoundMgs()
                  : mainList(context),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            ///Show Alert Dialog....
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Center(
                        child: Text(
                      "${userList.length} Active Users",textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                    )),
                    content: FlatButton(
                      color: Colors.deepOrange,
                      onPressed: () => Navigator.of(context).pop(),
                      splashColor: Colors.deepOrange[300],
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                });
          },
          tooltip: "Total Active User",
          backgroundColor: Colors.deepOrange,
          splashColor: Colors.white,
          isExtended: true,
          child: Icon(Icons.supervised_user_circle,size: 40,),
    ));
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
          onFieldSubmitted: (value) {
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
    fetchUser();
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 5, top: 5),
              child: Column(
                children: [
                  ///User Name....
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${userList[index]['name']}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[800]),
                    ),
                  ),

                  ///User Phone....
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${userList[index]['phone']}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  ///User Point....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Coin: ${userList[index]['point']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Total referred....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Total referred: ${userList[index]['total referred']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Video watched....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Video watched: ${userList[index]['video watched']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///User Address....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Address: ${userList[index]['address']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  ///Join Date....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Join Date: ${DateFormat("dd/MMM/yy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(userList[index]['created date'])))}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget customSearch(BuildContext context) {
    fetchSearchUser();
    return searchedUser.length == 0
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
                itemCount: searchedUser.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 5, top: 5),
                    child: Column(
                      children: [
                        ///User Name....
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${searchedUser[index]['name']}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.grey[800]),
                          ),
                        ),

                        ///User Phone....
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${searchedUser[index]['phone']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        ///User Point....
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Point: ${searchedUser[index]['point']}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),

                        ///Total referred....
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Total referred: ${searchedUser[index]['total referred']}",
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),

                        ///Video watched....
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Video watched: ${searchedUser[index]['video watched']}",
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),

                        ///User Address....
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Address: ${searchedUser[index]['address']}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),

                        ///Join Date....
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Join Date: ${DateFormat("dd/MMM/yy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(searchedUser[index]['created date'])))}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                }),
          );
  }
}

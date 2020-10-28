import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {

  final CollectionReference customerList =
  Firestore.instance.collection("Products");

  final CollectionReference customerOrder =
  Firestore.instance.collection("Customer Order");

  Future getProducts(String searchQuery) async {
    List searchList = [];
    try {
      await customerList
          .where("name", isGreaterThanOrEqualTo: searchQuery)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          searchList.add(element.data);
        });
      });
      return searchList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getNewOrder() async {
    List newOrderList = [];
    try {
      await customerOrder
          .where("delivery report", isEqualTo: "processing")
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          newOrderList.add(element.data);
        });
      });
      return newOrderList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getShippedOrder() async {
    List newOrderList = [];
    try {
      await customerOrder
          .where("delivery report", isEqualTo: "shipped")
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          newOrderList.add(element.data);
        });
      });
      return newOrderList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
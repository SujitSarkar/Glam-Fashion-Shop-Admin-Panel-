import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {

  final CollectionReference customerList =
  Firestore.instance.collection("Products");

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
}
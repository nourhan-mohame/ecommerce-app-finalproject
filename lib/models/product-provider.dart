// product_provider.dart

import 'package:finalproject/models/product-model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void fetchProducts() async {
    // Fetch products from Firestore (replace 'products' with your collection name)
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('product').get();

    _products = querySnapshot.docs.map((doc) {
      return Product(
        productName: doc['productName'],
        imageAsset: doc['imageAsset'],
        productPrice: doc['productPrice'].toDouble(),
      );
    }).toList();

    notifyListeners(); // Notify listeners when data changes
  }

}


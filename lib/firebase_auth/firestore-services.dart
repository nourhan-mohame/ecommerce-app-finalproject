import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(String userId, String productName, String price, String color, int size, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(userId).collection('products').add({
        'productName': productName,
        'price': price,
        'color': color,
        'size': size,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Error adding product: $e');
    }
  }
}

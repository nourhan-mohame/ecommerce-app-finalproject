import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/screens/checkout-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users-cart-item")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Something is wrong"));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No data available"));
            }

            // Calculate and update the total amount
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage("${_documentSnapshot['image']}"),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _documentSnapshot['name'],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              Text(
                                " ${_documentSnapshot['price']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Text("Color: ${_documentSnapshot['color']}"),
                              Text("Size: ${_documentSnapshot['size']}"),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  decreaseQuantity(_documentSnapshot.id);
                                },
                              ),
                              Text("Quantity: ${_documentSnapshot['quantity']}"),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  increaseQuantity(_documentSnapshot.id);
                                },
                              ),
                              GestureDetector(
                                child: CircleAvatar(
                                  child: Icon(Icons.delete),
                                ),
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection("users-cart-item")
                                      .doc(FirebaseAuth.instance.currentUser!.email)
                                      .collection("items")
                                      .doc(_documentSnapshot.id)
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: \$${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder:(context)=>CheckoutPage()));
                            },
                            child: Text('Checkout'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double calculateTotal(List<QueryDocumentSnapshot<Map<String, dynamic>>> items) {
    double total = 0.0;
    for (var item in items) {
      // Debug print to check the data
      print('Item data: ${item.data()}');

      // Check if the 'price' and 'quantity' fields are present and have valid numeric values
      if (item['price'] is num && item['quantity'] is num) {
        total += item['price'] * item['quantity'];
      } else {
        print('Invalid data in Firestore document: $item');
      }
    }
    return total;
  }



  void increaseQuantity(String documentId) {
    CollectionReference cartItemsCollection = FirebaseFirestore.instance
        .collection("users-cart-item")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items");

    // Retrieve the DocumentSnapshot using the documentId
    cartItemsCollection.doc(documentId).get().then((documentSnapshot) {
      // Get the current quantity from Firestore
      int currentQuantity = documentSnapshot['quantity'];

      // Update the quantity in Firestore
      cartItemsCollection.doc(documentId).update({
        'quantity': currentQuantity + 1,
      });
    });
  }

  void decreaseQuantity(String documentId) {
    CollectionReference cartItemsCollection = FirebaseFirestore.instance
        .collection("users-cart-item")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items");

    // Retrieve the DocumentSnapshot using the documentId
    cartItemsCollection.doc(documentId).get().then((documentSnapshot) {
      // Get the current quantity from Firestore
      int currentQuantity = documentSnapshot['quantity'];

      // Ensure the quantity doesn't go below 1
      if (currentQuantity > 1) {
        // Update the quantity in Firestore
        cartItemsCollection.doc(documentId).update({
          'quantity': currentQuantity - 1,
        });
      } else {
        // If the quantity is 1 or less, delete the item from the cart
        cartItemsCollection.doc(documentId).delete();
      }
    });
  }
}

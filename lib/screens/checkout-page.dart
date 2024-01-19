import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/screens/order-placed.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address Section
            SectionTitle(title: 'Shipping Address'),
            AddressWidget(
              name: 'John Doe',
              street: 'No 123, Sub Street',
              city: 'City Name',
              province: 'Province',
              country: 'Country',
            ),

            SizedBox(height: 16),

            // Payment Method Section
            SectionTitle(title: 'Payment Method'),
            PaymentMethodWidget(cardNumber: 'Master Card ending **00'),

            SizedBox(height: 16),

            // Items from Firestore
            SectionTitle(title: 'Order Items'),
            FutureBuilder<List<String>>(
              // Replace 'items' with your Firestore collection name
              future: getFirestoreItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No items available.');
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!.map((item) {
                      return Text('- $item');
                    }).toList(),
                  );
                }
              },
            ),

            SizedBox(height: 16),

            // Total Section
            TotalWidget(total: 100.00),

            SizedBox(height: 16),

            // Place Order Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPlacementPage()),
                );
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getFirestoreItems() async {
    // Replace 'items' with your Firestore collection name
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('items').get();

    return querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AddressWidget extends StatelessWidget {
  final String name;
  final String street;
  final String city;
  final String province;
  final String country;

  AddressWidget({
    required this.name,
    required this.street,
    required this.city,
    required this.province,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(street, style: TextStyle(fontSize: 14)),
            Text('$city, $province', style: TextStyle(fontSize: 14)),
            Text(country, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  final String cardNumber;

  PaymentMethodWidget({required this.cardNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          cardNumber,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class TotalWidget extends StatelessWidget {
  final double total;

  TotalWidget({required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

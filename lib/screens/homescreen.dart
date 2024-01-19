import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/product-provider.dart';
import 'package:finalproject/screens/CarouselWidget.dart';
import 'package:finalproject/screens/CategoryWidget.dart';
import 'package:finalproject/screens/ProductDetails.dart';
import 'package:finalproject/screens/cartscreen.dart';
import 'package:finalproject/screens/notificationscreen.dart';
import 'package:finalproject/screens/productcard.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomePge extends StatefulWidget {
  const HomePge({Key? key}) : super(key: key);


  @override
  State<HomePge> createState() => _HomePgeState();
}

class _HomePgeState extends State<HomePge> {
  int _selectedIndex = 0;

  Future<List<ProductCard>> fetchFirestoreData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('product').get();

    return querySnapshot.docs.map((DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ProductCard(
        imageAsset: data['imageAsset'],
        productName: data['productName'],
        productPrice: data['productPrice'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=>NotificationScreen()));
            },
            icon: const Icon(Icons.notifications, color: Colors.grey),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=>CartPage()));

            },
            icon: const Icon(Icons.shopping_cart, color: Colors.grey),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Category",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryWidget(
                    imageUrl: 'assets/image/clothes-icon.png',
                    categoryName: 'Category 1'),
                CategoryWidget(
                    imageUrl: 'assets/image/beauty-icon.png',
                    categoryName: 'Category 2'),
                CategoryWidget(
                    imageUrl: 'assets/image/shoes-icon.png',
                    categoryName: 'Category 3'),
                CategoryWidget(
                    imageUrl: 'assets/image/right-arrow.png',
                    categoryName: 'More'),
              ],
            ),
          ),
          const CarouselWidget(),
          SingleChildScrollView(
            child: FutureBuilder(
              future: fetchFirestoreData(),
              builder: (context, data) {
                if (data.hasError) {
                  return Center(
                    child: Text("${data.error}"),
                  );
                } else if (data.hasData) {
                  var gridItems = data.data as List<ProductCard>;
                  return Container(
                     padding: const EdgeInsets.only(top: 50),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 9.0,
                        mainAxisSpacing: 12.0,
                        mainAxisExtent:180,

                      ),
                      itemCount: gridItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ProductProvider(),
                                  child:ProductDetails(imageAsset:gridItems[index].imageAsset, productName:gridItems[index].productName, productPrice:gridItems[index].productPrice,

                                  ),
                                ),
                              ),
                            );
                          },
                          child: ProductCard(
                            imageAsset: gridItems[index].imageAsset,
                            productName: gridItems[index].productName,
                            productPrice: gridItems[index].productPrice,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
            // Home
              break;
            case 1:
            // Search
            // Implement search functionality or navigate to a search page
              break;
            case 2:
            // Cart
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
              break;
            case 3:
            // Profile
            // Navigate to the profile page
            // Example:
            // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              break;
            case 4:
            // More
            // Navigate to the more page
            // Example:
            // Navigator.push(context, MaterialPageRoute(builder: (context) => MorePage()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.black26,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black26,
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(

            backgroundColor: Colors.black26,
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',

          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black26,
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black26,
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

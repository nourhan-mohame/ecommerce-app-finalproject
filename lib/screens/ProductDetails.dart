import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/firebase_auth/firestore-services.dart';
import 'package:finalproject/models/cartitem-model.dart';
import 'package:finalproject/screens/cartscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.imageAsset,
    required this.productName,
    required this.productPrice,
  }) : super(key: key);

  final String imageAsset;
  final String productName;
  final String productPrice;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool showDetails = false;
  int selectedTabIndex = 0;
  int selectedColorIndex = -1;
  int selectedSizeIndex = -1;
  int selectedQuantity = 1;

  List<Product_cart> cartItems = [];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void addProductToFirestoreAndCart() async {
    FirestoreService firestoreService = FirestoreService();

    // Obtain the user credentials
    UserCredential authCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password:passwordController.text,
    );

    // Replace 'user123' with the actual user ID (you need to handle user authentication)
    String userId = authCredential.user!.uid;

    /*// Replace with the actual product details based on user selections
    String productName = widget.productName;
    String productPrice = widget.productPrice;
    String color = selectedColorIndex != -1 ? Colors.primaries[selectedColorIndex].toString() : 'N/A';
    int size = selectedSizeIndex != -1 ? selectedSizeIndex : -1;
    String imageUrl = widget.imageAsset;

    // Add the product to Firestore
    firestoreService.addProduct(userId, productName, productPrice, color, size, imageUrl);

    // Create a Product_cart instance and add it to the cartItems list
    Product_cart cartItem = Product_cart(
      name: productName,
      price: double.parse(productPrice), // Assuming productPrice is a String
      color: color,
      size: size,
      image: imageUrl,
    );
    setState(() {
     cartItems.add(cartItem);
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(cartItems: cartItems)),
    );*/

  }
  Future addtocart() async {
    String color = selectedColorIndex != -1 ? Colors.primaries[selectedColorIndex].toString() : 'N/A';
    int size = selectedSizeIndex != -1 ? selectedSizeIndex : -1;
    int selectedQuantity = 1;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentuser = _auth.currentUser;
    CollectionReference _collectionref = FirebaseFirestore.instance.collection("users-cart-item");
    return _collectionref.doc(currentuser!.email).collection("items").doc().set(
      {
        "name": widget.productName,
        "price": widget.productPrice, // Assuming productPrice is a String
        "color": color,
        "size": size,
        "image": widget.imageAsset,
        "quantity": selectedQuantity,
      },
    ).then((value) => print("Added to cart"));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffd7d5d5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xffff7e67),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.productName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Text(
            widget.productPrice,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Colors.black26,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));
              // Handle cart icon pressed
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 300,
            child: GridTile(
              child: Container(
                color: Colors.cyanAccent,
                child: Image.network(
                  widget.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          showDetails = false;
                          selectedTabIndex = 0;
                        });
                      },
                      child: Container(
                        // Wrap InkWell with Container
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 0
                              ? Colors.white // Orange color when selected
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          'Product',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                            color: selectedTabIndex == 0
                                ? const Color(0xffff7e67)// Yellow when selected
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          showDetails = true;
                          selectedTabIndex = 1;

                        });
                      },
                      child: Container(
                        // Wrap InkWell with Container
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 1
                              ? Colors.white // Orange color when selected
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child:  Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: selectedTabIndex == 1
                                ? const Color(0xffff7e67)// Yellow when selected
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle "Review" tap
                        setState(() {

                          selectedTabIndex = 2;
                          const ProductReviewsWidget();
                        });
                      },
                      child: Container(
                        // Wrap InkWell with Container
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 2
                              ? Colors.white // Orange color when selected
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          'Review',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: selectedTabIndex == 2
                                ? const Color(0xffff7e67)// Yellow when selected
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // ... (previous code)

                const SizedBox(height: 16.0),
                if (!showDetails)
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Select Color',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      // Adjust the spacing as needed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i < 5; i++)
                            GestureDetector(
                              onTap: () {
                                // Handle the color selection here
                                // You can set the selected color index or perform any other action
                                setState(() {
                                  selectedColorIndex = i;
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.primaries[i],
                                  shape: BoxShape.circle,
                                ),
                                child: selectedColorIndex == i
                                    ? InkWell(
                                  onTap: () {
                                    // Handle the icon press here
                                    // You can perform any action, e.g., show a dialog, change state, etc.
                                  },
                                  child: const Icon(
                                    Icons.check, // Replace with the desired icon
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                                    : const SizedBox(), // Empty container if not selected
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 18.0),
                    ],
                  ),


                const SizedBox(height: 18.0),
                if (!showDetails)
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Select Size',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      // Adjust the spacing as needed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int size = 1; size <= 5; size++)
                            GestureDetector(
                              onTap: () {
                                // Handle the size selection here
                                // You can set the selected size or perform any other action
                                setState(() {
                                  selectedSizeIndex = size;
                                });
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedSizeIndex == size
                                        ? Colors.blue // Border color for the selected size
                                        : Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Size $size',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: selectedSizeIndex == size
                                          ? Colors.blue // Text color for the selected size
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),

                const SizedBox(height: 16.0),
                if(selectedTabIndex==2) const ProductReviewsWidget(),
                const SizedBox(height: 16.0),
                if (showDetails) const DetailsWidget() else Container(),


                Padding(
                  padding: const EdgeInsets.all(19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      const Text('Quantity:', style: TextStyle(fontSize: 18.0)),
                      const SizedBox(width: 8.0),
                      DropdownButton<int>(
                        value: selectedQuantity,
                        onChanged: (int? value) {
                          setState(() {
                            selectedQuantity = value!;
                          });
                        },
                        items: List.generate(10, (index) => index + 1)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x51484848),
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Share This',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.share,
                            size: 30,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        addtocart();
                        Navigator.push(context,MaterialPageRoute(builder:(context)=> CartPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffff7e67),
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ADD TO CART',
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: fetchDataFromCloud(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No data available');
        } else {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BRAND', style: TextStyle(
                          fontSize: 15,
                          color: Colors.black26,
                        )),
                        Text(
                          data['BRAND Name'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20.0), // Add space
                        const Text('CONDITION', style: TextStyle(
                          fontSize: 15,
                          color: Colors.black26,
                        )),
                        Text(
                          data['CONDITION Detail'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20.0), // Add space
                        const Text('CATEGORY', style: TextStyle(
                          fontSize: 15,
                          color: Colors.black26,
                        )),
                        Text(
                          data['CATEGORY Name'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('SKU', style: TextStyle(
                          fontSize: 20,
                          color: Colors.black26,
                        )),
                        Text(
                          data['SKU Detail'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20.0), // Add space
                        const Text('MATERIAL', style: TextStyle(
                          fontSize: 15,
                          color: Colors.black26,
                        )),
                        Text(
                          data['MATERIAL Detail'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20.0), // Add space
                        const Text('FITTING', style: TextStyle(
                          fontSize: 15,
                          color: Colors.black26,
                        )),
                        Text(
                          data['FITTING Detail'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          );
        }
      },
    );
  }

  Future<DocumentSnapshot> fetchDataFromCloud() async {
    return await FirebaseFirestore.instance
        .collection('product-details')
        .doc('5VIZaPluXbOyBcEF3BNd')
        .get();
  }
}

class ProductReviewsWidget extends StatelessWidget {
  const ProductReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildReviewItem(
          userName: 'John Doe',
          rating: 4.5,
          reviewText: 'Great product! I love it.',
          date: 'Jan 15, 2023',
          images: [
            'https://example.com/image1.jpg',
            'https://example.com/image2.jpg',
          ],
        ),
        const SizedBox(height: 16.0),
        _buildReviewItem(
          userName: 'Alice Smith',
          rating: 5.0,
          reviewText: 'Excellent quality and fast delivery.',
          date: 'Feb 1, 2023',
          images: [
            'https://example.com/image3.jpg',
          ],
        ),
        // Add more review items as needed
      ],
    );
  }

  Widget _buildReviewItem({
    required String userName,
    required double rating, // Change the type to double
    required String reviewText,
    required String date,
    required List<String> images,
  }) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                RatingBar.builder(
                  initialRating: rating, // Use the double variable here
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // You can handle the rating update if needed
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              reviewText,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Posted on: $date',
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            if (images.isNotEmpty) ...[
              const Text(
                'Attached Images:',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildImageSlider(images),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider(List<String> images) {
    return SizedBox(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.network(
              images[index],
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}


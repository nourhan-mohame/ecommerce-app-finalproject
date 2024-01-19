import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageAsset;
  final String productName;
  final String productPrice;

  const ProductCard({
    Key? key,
    required this.imageAsset,
    required this.productName,
    required this.productPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [

          SizedBox(
            width: double.infinity,
            height: 100,

            child: Image.network(
              imageAsset,
              fit: BoxFit.cover,
              alignment:Alignment.center,


            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),

            child: Text(
              productName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),

            ),
          ),
          Text(productPrice,
          style: const TextStyle(
            fontSize:20,
            fontWeight:FontWeight.w600
          ),),
        ],
      ),
    );
  }
}

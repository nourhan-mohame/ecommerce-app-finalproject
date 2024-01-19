
import 'package:flutter/material.dart';
class CategoryWidget extends StatelessWidget {
  final String imageUrl;
  final String categoryName;


  const CategoryWidget({super.key, required this.imageUrl, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.all(5),
      child: Column(

        children: [

          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imageUrl),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(categoryName),
        ],
      ),
    );
  }
}

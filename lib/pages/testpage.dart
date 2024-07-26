import 'package:flutter/material.dart';

class Product {
  final String name;
  final String description;
  final List<String> imageUrls;

  Product(
      {required this.name, required this.description, required this.imageUrls});
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Details Page',
      home: ProductDetailsPage(),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Product product = Product(
    name: "Produk 1",
    description: "This is a sample product description.",
    imageUrls: [
      "https://www.pakainfo.com/wp-content/uploads/2021/09/image-url-for-testing.jpg",
      "https://www.pakainfo.com/wp-content/uploads/2021/09/sample-image-url-for-testing-300x169.jpg",
      "https://www.pakainfo.com/wp-content/uploads/2021/09/test-image-online-300x148.jpg",
      // Add more image URLs here
    ],
  );

  ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: product.imageUrls.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
              ),
              itemBuilder: (context, index) {
                return Image.network(product.imageUrls[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

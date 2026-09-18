import 'package:flutter/material.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  
  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Lọc sản phẩm theo Category
    final List<Product> categoryProducts = allProducts.where((p) => p.category == categoryName).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: Text('Danh mục: $categoryName'),
        elevation: 0,
        centerTitle: true,
      ),
      body: categoryProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Không có sản phẩm nào',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildGrid(context, categoryProducts),
            ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Product> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 600 ? 3 : 2;
        const spacing = 14.0;
        final cardWidth = (constraints.maxWidth - spacing * (cols - 1)) / cols;

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 0.75, // Adjust this ratio depending on ProductCard design
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return SizedBox(
              width: cardWidth,
              child: ProductCard(
                product: p,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

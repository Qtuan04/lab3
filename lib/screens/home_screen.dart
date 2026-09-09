import 'package:flutter/material.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';
  int _cartCount = 0;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Tất cả', 'icon': Icons.apps_rounded},
    {'label': 'Điện thoại', 'icon': Icons.smartphone_rounded},
    {'label': 'Laptop', 'icon': Icons.laptop_rounded},
    {'label': 'Tablet', 'icon': Icons.tablet_rounded},
    {'label': 'Tai nghe', 'icon': Icons.headphones_rounded},
    {'label': 'Đồng hồ', 'icon': Icons.watch_rounded},
  ];

  List<Product> get _filtered {
    List<Product> result = allProducts;
    if (_selectedCategory != 'Tất cả') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  void _goToDetail(Product p) async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
    );
    if (added == true) setState(() => _cartCount++);
  }

  void _showCartSnackBar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    ).then((_) {
      // Sync cart badge when returning from cart
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    _buildBanner(),
                    _buildCategories(),
                    _buildProductSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF0052CC),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.memory_rounded,
                  color: Color(0xFF0052CC), size: 20),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'TechShop',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(),
          // Bell
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: Colors.white, size: 24),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          // Cart — dùng IconButton để hit area chắc chắn
          SizedBox(
            width: 36,
            height: 36,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white, size: 24),
                  onPressed: _showCartSnackBar,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                if (globalCart.isNotEmpty)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: IgnorePointer(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF3B30),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${globalCart.length}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Search ─────────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
          decoration: InputDecoration(
            hintText: 'Bạn muốn tìm sản phẩm gì?',
            hintStyle:
                const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded,
                color: Color(0xFF0066FF), size: 22),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.grey, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }

  // ── Banner ─────────────────────────────────────────────────────────────────
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF003ED4), Color(0xFF7B5CE0)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0066FF).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 12, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '🔥  HOT DEAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'SALE CÔNG NGHỆ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Giảm đến 30% hôm nay!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = 'Tất cả'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Mua ngay  →',
                            style: TextStyle(
                              color: Color(0xFF003ED4),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 24),
                child: Icon(
                  Icons.devices_rounded,
                  color: Colors.white24,
                  size: 80,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Categories ─────────────────────────────────────────────────────────────
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 18, 16, 10),
          child: Text(
            'Danh mục',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (context, i) {
              final cat = _categories[i];
              final selected = _selectedCategory == cat['label'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = cat['label']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 68,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF0066FF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: selected
                              ? const Color(0xFF0066FF)
                                  .withValues(alpha: 0.35)
                              : Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF0066FF),
                          size: 24,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          cat['label'],
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF444444),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Product grid ───────────────────────────────────────────────────────────
  Widget _buildProductSection() {
    final products = _filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
          child: Row(
            children: [
              Text(
                _selectedCategory == 'Tất cả'
                    ? 'Sản phẩm nổi bật'
                    : _selectedCategory,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${products.length} sản phẩm',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0066FF),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text(
                    'Không tìm thấy sản phẩm',
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth > 600 ? 3 : 2;
                const spacing = 14.0;
                final cardWidth =
                    (constraints.maxWidth - spacing * (cols - 1)) / cols;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: products
                      .map((p) => SizedBox(
                            width: cardWidth,
                            child: ProductCard(
                              product: p,
                              onTap: () => _goToDetail(p),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ),
      ],
    );
  }
}

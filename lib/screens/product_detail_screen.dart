import 'package:flutter/material.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFav = false;
  int _qty = 1;

  String _fmt(double price) {
    final n = price.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '$nđ';
  }

  void _addToCart() {
    // Thêm vào globalCart
    final existing = globalCart.where((i) => i.product.id == widget.product.id);
    if (existing.isNotEmpty) {
      existing.first.quantity += _qty;
    } else {
      globalCart.add(CartItem(product: widget.product, quantity: _qty));
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Đã thêm $_qty "${widget.product.name}" vào giỏ hàng',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E8C45),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Xem giỏ',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
      ),
    );
    Navigator.pop(context, true);
  }

  void _buyNow() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Color(0xFF0066FF), size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Đặt hàng thành công!',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 8),
              Text(
                'Bạn đã đặt $_qty sản phẩm "${widget.product.name}".\nTechShop sẽ liên hệ trong thời gian sớm nhất!',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Về trang chủ',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(p),
                  _buildInfoCard(p),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            // Top bar overlay
            _buildTopBar(),
            // Bottom buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            _circleBtn(
              icon: Icons.arrow_back_ios_rounded,
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            _circleBtn(
              icon: _isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFav ? const Color(0xFFE53935) : const Color(0xFF444444),
              onTap: () => setState(() => _isFav = !_isFav),
            ),
            const SizedBox(width: 8),
            _circleBtn(
              icon: Icons.share_outlined,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleBtn(
      {required IconData icon, Color? color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon,
            size: 18, color: color ?? const Color(0xFF333333)),
      ),
    );
  }

  Widget _buildImageSection(Product p) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        children: [
          SizedBox(
            height: 260,
            child: Image.network(
              p.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.image_not_supported_outlined,
                    size: 80, color: Colors.grey),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0066FF)),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Dot indicators (decorative)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == 0 ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == 0
                      ? const Color(0xFF0066FF)
                      : const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Product p) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Name & category ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        p.category,
                        style: const TextStyle(
                          color: Color(0xFF0066FF),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Rating badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFB800), size: 14),
                          const SizedBox(width: 3),
                          Text(
                            p.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  p.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A2E),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ...List.generate(5, (i) {
                      return Icon(
                        i < p.rating.floor()
                            ? Icons.star_rounded
                            : (i < p.rating
                                ? Icons.star_half_rounded
                                : Icons.star_border_rounded),
                        color: const Color(0xFFFFB800),
                        size: 16,
                      );
                    }),
                    const SizedBox(width: 6),
                    Text(
                      '${p.reviewCount} đánh giá',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // ── Price ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fmt(p.price),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE53935),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _fmt(p.oldPrice),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFBBBBBB),
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Color(0xFFBBBBBB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Tiết kiệm ${p.discount}%',
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // ── Quantity ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              children: [
                const Text('Số lượng',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E))),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _qtyBtn(
                        Icons.remove_rounded,
                        () {
                          if (_qty > 1) setState(() => _qty--);
                        },
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$_qty',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E)),
                        ),
                      ),
                      _qtyBtn(Icons.add_rounded, () => setState(() => _qty++)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // ── Description ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mô tả sản phẩm',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 10),
                Text(
                  p.description,
                  style: const TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF555555),
                      height: 1.7),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // ── Specs ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thông số kỹ thuật',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: p.specs.asMap().entries.map((entry) {
                      final parts = entry.value.split(':');
                      final label =
                          parts.isNotEmpty ? parts[0].trim() : '';
                      final value = parts.length > 1
                          ? parts.sublist(1).join(':').trim()
                          : '';
                      final isLast = entry.key == p.specs.length - 1;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          color: entry.key % 2 == 0
                              ? const Color(0xFFF8F9FF)
                              : Colors.white,
                          borderRadius: isLast
                              ? const BorderRadius.vertical(
                                  bottom: Radius.circular(12))
                              : (entry.key == 0
                                  ? const BorderRadius.vertical(
                                      top: Radius.circular(12))
                                  : BorderRadius.zero),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(label,
                                  style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF777777),
                                      fontWeight: FontWeight.w500)),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(value,
                                  style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF1A1A2E),
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 38,
        height: 38,
        child: Icon(icon, size: 18, color: const Color(0xFF0066FF)),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Add to cart
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _addToCart,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0066FF),
                side:
                    const BorderSide(color: Color(0xFF0066FF), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.shopping_cart_outlined, size: 17),
              label: const Text('Thêm vào giỏ',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 10),
          // Buy now
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _buyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.bolt_rounded, size: 17),
              label: const Text('Mua ngay',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

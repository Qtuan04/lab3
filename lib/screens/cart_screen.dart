import 'package:flutter/material.dart';
import '../models/product.dart';

// ── Global cart state ────────────────────────────────────────────────────────
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

final List<CartItem> globalCart = [];

// ── Cart Screen ──────────────────────────────────────────────────────────────
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _fmt(double price) {
    final n = price.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '$nđ';
  }

  double get _subtotal =>
      globalCart.fold(0, (s, i) => s + i.product.price * i.quantity);

  double get _shipping => globalCart.isEmpty ? 0 : 30000;

  double get _total => _subtotal + _shipping;

  void _updateQty(int index, int delta) {
    setState(() {
      globalCart[index].quantity += delta;
      if (globalCart[index].quantity <= 0) globalCart.removeAt(index);
    });
  }

  void _remove(int index) {
    final name = globalCart[index].product.name;
    setState(() => globalCart.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "$name" khỏi giỏ hàng'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {}, // simple demo
        ),
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xóa toàn bộ giỏ hàng?'),
        content: const Text('Tất cả sản phẩm sẽ bị xóa khỏi giỏ hàng.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() => globalCart.clear());
              Navigator.pop(context);
            },
            child: const Text('Xóa hết',
                style: TextStyle(color: Color(0xFFE53935))),
          ),
        ],
      ),
    );
  }

  void _checkout() {
    if (globalCart.isEmpty) return;
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
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E8C45).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Color(0xFF1E8C45), size: 36),
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
              const Text(
                'TechShop sẽ liên hệ xác nhận đơn hàng trong thời gian sớm nhất.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => globalCart.clear());
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context, 0); // back to home, reset cart
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
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0052CC),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Giỏ hàng',
                style:
                    TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            if (globalCart.isNotEmpty)
              Text(
                '${globalCart.length} sản phẩm',
                style: const TextStyle(
                    fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
        actions: [
          if (globalCart.isNotEmpty)
            TextButton.icon(
              onPressed: _clearAll,
              icon: const Icon(Icons.delete_outline_rounded,
                  color: Colors.white70, size: 16),
              label: const Text('Xóa hết',
                  style:
                      TextStyle(color: Colors.white70, fontSize: 13)),
            ),
        ],
      ),
      body: globalCart.isEmpty ? _buildEmpty() : _buildCartList(),
      bottomNavigationBar:
          globalCart.isEmpty ? null : _buildCheckoutBar(),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 90, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Giỏ hàng trống',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 8),
          Text('Thêm sản phẩm vào giỏ để tiếp tục mua sắm',
              style: TextStyle(
                  fontSize: 13, color: Colors.grey[500])),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Tiếp tục mua sắm',
                style:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // ── Cart list ───────────────────────────────────────────────────────────────
  Widget _buildCartList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: globalCart.length,
      itemBuilder: (context, i) {
        final item = globalCart[i];
        return Dismissible(
          key: ValueKey('${item.product.id}_$i'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _remove(i),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_rounded, color: Colors.white, size: 26),
                SizedBox(height: 4),
                Text('Xóa',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Ảnh
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      item.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        color: const Color(0xFFF5F5F5),
                        child: const Icon(Icons.image_not_supported_outlined,
                            color: Colors.grey, size: 28),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFFF5F5F5),
                          child: const Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Thông tin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1A1A2E),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.product.category,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF888888)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            _fmt(item.product.price),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: Color(0xFFE53935),
                            ),
                          ),
                          const Spacer(),
                          // Nút số lượng
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFFE0E0E0)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _qtyBtn(Icons.remove_rounded,
                                    () => _updateQty(i, -1)),
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    '${item.quantity}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14),
                                  ),
                                ),
                                _qtyBtn(Icons.add_rounded,
                                    () => _updateQty(i, 1)),
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
          ),
        );
      },
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 30,
        height: 30,
        child: Icon(icon, size: 16, color: const Color(0xFF0066FF)),
      ),
    );
  }

  // ── Checkout bar ────────────────────────────────────────────────────────────
  Widget _buildCheckoutBar() {
    return Container(
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
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tóm tắt giá
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tạm tính (${globalCart.length} sp)',
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF888888))),
                Text(_fmt(_subtotal),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E))),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Phí vận chuyển',
                    style: TextStyle(
                        fontSize: 13, color: Color(0xFF888888))),
                Text(_fmt(_shipping),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E))),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Color(0xFFF0F0F0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng cộng',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E))),
                Text(
                  _fmt(_total),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Đặt hàng  •  ${_fmt(_total)}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

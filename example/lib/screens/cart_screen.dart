import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

/// Cart screen using Flutter SDK APIs: setCartAmount, setCartItemCount.
/// getCart/setCart (full cart payload) are not exposed in Flutter SDK;
/// use React or native SDK for full cart management.
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cartAmountController = TextEditingController();
  final _cartItemCountController = TextEditingController();

  @override
  void dispose() {
    _cartAmountController.dispose();
    _cartItemCountController.dispose();
    super.dispose();
  }

  void _setCartAmount() {
    final v = _cartAmountController.text.trim();
    if (v.isNotEmpty) {
      DengageFlutter.setCartAmount(v);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart amount set')),
      );
    }
  }

  void _setCartItemCount() {
    final v = _cartItemCountController.text.trim();
    if (v.isNotEmpty) {
      DengageFlutter.setCartItemCount(v);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart item count set')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Flutter SDK exposes setCartAmount and setCartItemCount only. '
              'For full cart (getCart/setCart with items), use React or native SDK.',
              style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _cartAmountController,
              decoration: const InputDecoration(
                hintText: 'Cart Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _setCartAmount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
              ),
              child: const Text('Set Cart Amount'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _cartItemCountController,
              decoration: const InputDecoration(
                hintText: 'Cart Item Count',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _setCartItemCount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
              ),
              child: const Text('Set Cart Item Count'),
            ),
          ],
        ),
      ),
    );
  }
}

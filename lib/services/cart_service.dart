import '../models/product_model.dart';

class CartItem {
  final ProductModel product;
  double quantity;

  CartItem({required this.product, required this.quantity});

  double get subtotal => product.price * quantity;
}

// Ella screens-layum access panna oru single, static cart list
class CartService {
  static final List<CartItem> _items = [];

  static List<CartItem> get items => _items;

  static int get itemCount => _items.length;

  static double get grandTotal =>
      _items.fold(0.0, (sum, item) => sum + item.subtotal);

  // Same product already cart-la irundha, quantity mattum update pannum
  static void addToCart(ProductModel product, double quantity) {
    final existingIndex = _items.indexWhere((i) => i.product.productId == product.productId);
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
  }

  static void updateQuantity(int productId, double newQuantity) {
    final index = _items.indexWhere((i) => i.product.productId == productId);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
    }
  }

  static void removeFromCart(int productId) {
    _items.removeWhere((i) => i.product.productId == productId);
  }

  static void clearCart() {
    _items.clear();
  }

  static bool isInCart(int productId) {
    return _items.any((i) => i.product.productId == productId);
  }
}
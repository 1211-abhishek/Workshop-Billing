import 'package:flutter/foundation.dart';
import '../models/billing_item_data.dart';

class BillingProvider with ChangeNotifier {
  final List<BillingItemData> _items = [];

  List<BillingItemData> get items => _items;

  void addItem(BillingItemData item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(BillingItemData item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal {
    return _items.fold(0, (total, current) => total + current.totalPrice);
  }
}

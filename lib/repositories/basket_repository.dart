import 'package:southsea_cinema/models/ticket_item.dart';

class BasketRepository {
  BasketRepository._internal();
  static final BasketRepository instance = BasketRepository._internal();

  final List<TicketItem> _items = [];

  List<TicketItem> getItems() {
    return List<TicketItem>.unmodifiable(_items);
  }

  void addItem(TicketItem item) {
    _items.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  void clear() {
    _items.clear();
  }

  double getSubtotal() {
    double sum = 0.0;
    for (final TicketItem item in _items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  double getServiceCharge() {
    if (_items.isEmpty) {
      return 0.0;
    }
    return 4.00;
  }

  double getTotalDue() {
    return getSubtotal() + getServiceCharge();
  }
}
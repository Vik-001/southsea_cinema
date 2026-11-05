import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
  final basket = BasketRepository.instance;

  void _removeItem(int index) {
    setState(() {
      basket.removeItem(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = basket.getItems();

    return Scaffold(
      appBar: AppBar(title: const Text('MY BASKET')),
      drawer: const NavDrawer(),
      body: items.isEmpty
          ? const Center(child: Text('YOUR BASKET IS EMPTY!', style: TextStyle(fontSize: 18)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(
                          item.movie.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          '${item.quantity} x £${item.movie.price.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white70), 
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _removeItem(index),
                        ),
                      );
                    },
                  ),
                ),
                _buildTotals(),
              ],
            ),
    );
  }

  Widget _buildTotals() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: cinemaSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SUBTOTAL:', style: TextStyle(color: Colors.white)),
              Text('£${basket.getSubtotal().toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SERVICE CHARGE:', style: TextStyle(color: Colors.white)),
              Text('£${basket.getServiceCharge().toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const Divider(height: 24, color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL DUE:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              Text(
                '£${basket.getTotalDue().toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: cinemaBrand),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'CHECKOUT',
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }
}
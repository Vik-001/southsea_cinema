import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
  final BasketRepository basket = BasketRepository.instance;

  List<Booking> _bookings = [];
  bool _loadingBookings = true;
  String _bookingsError = '';

  String _confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();
      if (!mounted) {
        return;
      }
      setState(() {
        _bookings = bookings;
        _loadingBookings = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _bookingsError = 'Could not load bookings: $error';
        _loadingBookings = false;
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      basket.removeItem(index);
    });
  }

  String _buildSummary(List<TicketItem> items) {
    final List<String> parts = [];
    for (final TicketItem item in items) {
      parts.add('${item.quantity} x ${item.movie.title}');
    }
    return parts.join(', ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/${now.year} $hour:$minute';
  }

  Future<void> _checkout(List<TicketItem> items) async {
    final String summary = _buildSummary(items);
    final double total = basket.getTotalDue();
    final String date = _formatDate(DateTime.now());

    try {
      final CinemaDatabase database = CinemaDatabase.instance;
      final int bookingNumber = await database.getNextBookingNumber();
      final Booking booking = Booking(
        bookingNumber: bookingNumber,
        summary: summary,
        total: total,
        date: date,
      );
      await database.insertBooking(booking);
      basket.clear();
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Booking #$bookingNumber saved';
      });
      await _loadBookings();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Could not save your booking: $error';
      });
    }
  }

  Widget _buildBasketSection(List<TicketItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            'YOUR BASKET IS EMPTY!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final List<Widget> rows = [];
    for (int index = 0; index < items.length; index++) {
      final TicketItem item = items[index];
      rows.add(
        ListTile(
          title: Text(
            item.movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            '${item.quantity} x £${item.movie.price.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _removeItem(index),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...rows,
        _buildTotals(items),
      ],
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      color: cinemaSurface,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.bookingNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '£${booking.total.toStringAsFixed(2)}',
                  style: const TextStyle(color: cinemaBrand),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              booking.summary,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              booking.date,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastBookingsSection() {
    if (_loadingBookings) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_bookingsError.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(_bookingsError),
        ),
      );
    }

    if (_bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'No bookings yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final List<Widget> cards = [];
    for (final Booking booking in _bookings) {
      cards.add(_buildBookingCard(booking));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TicketItem> items = basket.getItems();

    return Scaffold(
      appBar: AppBar(title: const Text('MY BASKET')),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBasketSection(items),
            const Divider(height: 32, color: Colors.white24),
            const Text(
              'PAST BOOKINGS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildPastBookingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotals(List<TicketItem> items) {
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
              Text(
                '£${basket.getSubtotal().toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SERVICE CHARGE:',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '£${basket.getServiceCharge().toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const Divider(height: 24, color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL DUE:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                '£${basket.getTotalDue().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: cinemaBrand,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'CHECKOUT',
            onPressed: () {
              _checkout(items);
            },
          ),
        ],
      ),
    );
  }
}

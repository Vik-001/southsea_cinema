import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  const MovieListing({super.key});

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int _ticketQuantity = 0;

  String _bookingMessage = '';

  void _addToOrder() {
    setState(() {
      if (_ticketQuantity == 0) {
        _bookingMessage = 'Please select at least 1 ticket.';
      } else {
        _bookingMessage =
            'Added $_ticketQuantity ticket(s) for F1 (2025) to your order!';
      }
    });
  }

  Widget _buildMovieInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'F1 (2025) (12A)',
          style: TextStyle(
            color: cinemaFontWhite,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Southsea Cinema Room',
          style: TextStyle(color: cinemaFontWhite, fontSize: 16),
        ),
        SizedBox(height: 12),
        Text(
          'Thursday 22 Oct 2026, 18:00 - ends at 20:35',
          style: TextStyle(color: cinemaFontWhite, fontSize: 16),
        ),
        SizedBox(height: 12),
        Text(
          'Runtime: 155 mins | Starring Brad Pitt & Damson Idris. '
          'Veteran Formula 1 driver Sonny Hayes returns to the grid '
          'to mentor rookie prodigy Joshua Pearce for the APXGP team.',
          style: TextStyle(color: cinemaFontMuted, fontSize: 15),
        ),
        SizedBox(height: 24),
        Text(
          'Please note that Discounts / Membership Benefits will be applied '
          'once you have selected your tickets',
          style: TextStyle(color: cinemaFontWhite, fontSize: 16),
        ),
        SizedBox(height: 16),
        Text(
          'Select Quantities (Up to 5 in total)',
          style: TextStyle(color: cinemaFontWhite, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTicketSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tickets',
          style: cinemaHeaderStyle,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            DropdownMenu<int>(
              width: 120,
              initialSelection: _ticketQuantity,
              textStyle: const TextStyle(color: Colors.black, fontSize: 16),
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: cinemaFontWhite,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onSelected: (int? value) {
                if (value != null) {
                  setState(() {
                    _ticketQuantity = value;
                  });
                }
              },
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 0, label: '0'),
                DropdownMenuEntry(value: 1, label: '1'),
                DropdownMenuEntry(value: 2, label: '2'),
                DropdownMenuEntry(value: 3, label: '3'),
                DropdownMenuEntry(value: 4, label: '4'),
                DropdownMenuEntry(value: 5, label: '5'),
              ],
            ),
            const SizedBox(width: 16),
            const Text(
              'Adult (£7.50)',
              style: TextStyle(color: cinemaFontWhite, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cinemaBrand,
            foregroundColor: cinemaFontWhite,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: _addToOrder,
          child: const Text('ADD TO ORDER'),
        ),
        const SizedBox(height: 16),
        Text(
          _bookingMessage,
          style: const TextStyle(
            color: cinemaBrandLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Wide screen: side-by-side Row
            return Container(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildMovieInfo()),
                  const SizedBox(width: 32),
                  Expanded(child: _buildTicketSection()),
                ],
              ),
            );
          } else {
            // Narrow (phone-sized) screen: stacked Column
            return Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMovieInfo(),
                  const SizedBox(height: 24),
                  _buildTicketSection(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

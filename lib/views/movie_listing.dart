import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class MovieListing extends StatefulWidget {
  final Movie movie;

  const MovieListing({super.key, required this.movie});

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int _ticketQuantity = 1;

  String _bookingMessage = '';

  void _addToOrder() {
    setState(() {
      final newTicket = TicketItem(
        movie: widget.movie,
        quantity: _ticketQuantity,
      );
      BasketRepository.instance.addItem(newTicket);
      _bookingMessage = 'Successfully added to your basket!';
    });
  }

  Widget _buildMovieInfo() {
    final ThemeData theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onSurface;
    final Color mutedColor = theme.brightness == Brightness.dark
        ? cinemaFontMuted
        : cinemaLightMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.movie.title} (${widget.movie.ageRating})',
          style: TextStyle(
            color: textColor,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Image.asset(
          widget.movie.imagePath,
          width: 200,
        ),
        Text(
          'Southsea Cinema Room',
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          widget.movie.screeningTime,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          widget.movie.synopsis,
          style: TextStyle(color: mutedColor, fontSize: 15),
        ),
        const SizedBox(height: 24),
        Text(
          'Please note that Discounts / Membership Benefits will be applied '
          'once you have selected your tickets',
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Text(
          'Select Quantities (Up to 5 in total)',
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTicketSection() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color feedbackColor = theme.brightness == Brightness.dark
        ? cinemaBrandLight
        : cinemaBrandDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tickets',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            DropdownMenu<int>(
              width: 120,
              initialSelection: _ticketQuantity,
              textStyle: TextStyle(color: colorScheme.onSurface, fontSize: 16),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: colorScheme.surface,
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            Text(
              'Adult (${widget.movie.formattedPrice})',
              style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'ADD TO ORDER',
          onPressed: _addToOrder,
        ),
        const SizedBox(height: 16),
        Text(
          _bookingMessage,
          style: TextStyle(
            color: feedbackColor,
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
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Wide screen
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
              // Narrow screen
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
      ),
    );
  }
}
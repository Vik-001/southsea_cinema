import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatelessWidget {
  const MovieListing({super.key});

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
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('F1 (2025) (12A)'),
            SizedBox(height: 12),
            Text(
              'Runtime: 155 mins | Starring Brad Pitt & Damson Idris. '
              'Veteran Formula 1 driver Sonny Hayes returns to the grid '
              'to mentor rookie prodigy Joshua Pearce for the APXGP team.',
            ),
            SizedBox(height: 24),
            Text('Southsea Cinema Room'),
            SizedBox(height: 12),
            Text('Thursday 22 Oct 2026, 18:00 - ends at 20:35'),
            SizedBox(height: 24),
            Text(
              'Please note that Discounts / Membership Benefits will be applied '
              'once you have selected your tickets',
            ),
            SizedBox(height: 16),
            Text('Select Quantities (Up to 5 in total)'),
            SizedBox(height: 24),
            Text('Tickets'),
            SizedBox(height: 12),
            Row(
              children: [
                Text('0'),
                SizedBox(width: 16),
                Text('Adult (£7.50)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

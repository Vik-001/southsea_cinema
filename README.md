# Southsea Cinema

A mobile-first Flutter application for browsing screenings, booking tickets,
and viewing saved bookings for the Southsea Cinema & Arts Centre. Built with
local SQLite persistence and persistent Light/Dark theme preferences.

## Features

- **Film Listings:** Displays current screenings with poster art, age ratings,
  synopses, and screening times loaded from local app data.
- **Responsive Ticket Booking:** Adapts between single-column (mobile) and
  two-column (wide screen) layouts using `LayoutBuilder`, with ticket quantity
  selection (0–5) and live subtotal feedback.
- **Basket and Checkout:** Tracks selected tickets, allows removing individual
  items, calculates subtotal, service charge, and total due, and saves
  completed orders to SQLite.
- **Past Bookings History:** Loads previously saved bookings from local SQLite
  storage on the basket screen with sequential booking numbers.
- **Light and Dark Mode:** Switches app-wide themes from the Settings screen
  and persists the user's preference across restarts using
  `SharedPreferencesAsync`.
- **Platform Guard:** Restricts execution to Android (where SQLite storage is
  configured) and displays an informative fallback screen on unsupported
  platforms.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (with Dart)
- Android Studio or Android SDK command-line tools with an Android Emulator
- Git and VS Code (with the Flutter and Dart extensions)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Vik-001/southsea_cinema.git
cd southsea_cinema
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run on an Android Emulator

This app persists bookings with SQLite (`sqflite`) and targets **Android
only**. Start an Android emulator first, then run the app:

```bash
flutter emulators --launch flutter_emulator
flutter devices
flutter run
```

> Note: Running on Chrome, Edge, or desktop platforms shows an unsupported
> platform notice rather than the booking interface.

## Testing and Code Quality

Run formatting, static analysis, and the full automated test suite (32 unit
and widget tests):

```bash
dart format lib test
dart analyze
flutter test
```

The test suite uses an in-memory `SharedPreferencesAsync` implementation
(`InMemorySharedPreferencesAsync`) and isolated database/repository setups so
all tests run reliably without a physical device.

## Project Structure

```text
southsea_cinema/
├── assets/
│   ├── images/                     # Film poster assets
│   └── movies.json                 # Film catalogue data
├── lib/
│   ├── constants.dart              # Brand colours, light/dark palettes, styles
│   ├── main.dart                   # Entry point, routes, theme persistence
│   ├── database/
│   │   └── cinema_db.dart          # SQLite helper for storing bookings
│   ├── models/
│   │   ├── booking.dart            # Persisted booking data model
│   │   ├── movie.dart              # Film screening data model
│   │   └── ticket_item.dart        # Basket line item model
│   ├── repositories/
│   │   ├── basket_repository.dart  # In-memory basket state and totals
│   │   └── movie_repository.dart   # Film loading logic
│   ├── views/
│   │   ├── basket_view.dart        # Basket, checkout, and past bookings
│   │   ├── home_view.dart          # Main film listing feed
│   │   ├── movie_listing.dart      # Screening details and ticket selection
│   │   └── settings_view.dart      # Light/Dark mode toggle screen
│   └── widgets/
│       ├── movie_card.dart         # Film summary card
│       ├── nav_drawer.dart         # Navigation drawer
│       └── primary_button.dart     # Reusable primary action button
├── test/
│   ├── views/
│   │   └── settings_view_test.dart # Settings screen widget tests
│   └── widget_test.dart            # End-to-end app and persistence tests
├── pubspec.yaml                    # App dependencies and asset declarations
└── README.md                       # Project documentation
```

## Key Dependencies

- `sqflite` and `path` — local SQLite database for saving and querying bookings
- `shared_preferences` — asynchronous key-value storage for theme preference
- `shared_preferences_platform_interface` (dev) — in-memory preferences for
  automated widget tests

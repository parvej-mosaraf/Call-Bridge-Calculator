# 🔸 Bridge Calculator

A simple Flutter-based Android application for entering a 13-card Bridge hand and generating an experimental call estimation based on configurable card and suit-strength weights.

Note: This application uses a heuristic scoring system for experimentation and does not guarantee the accuracy of an actual Bridge call.

Features
♦ Calculator-style interface
♠ ♥ ♦ ♣ Support for all four suits
13-card hand validation
Prevents duplicate cards within the same suit
Easy card-entry keypad
Suit-by-suit card entry
Safe, Medium, and High-risk call estimations
Hand strength calculation
Reset functionality
Android launcher icon
Optimized for mobile screens


The user enters their cards one suit at a time.

For example:

♠  A K 10 8 4
♥  Q J 9
♦  A 7 3
♣  K 6

The application verifies that the hand contains exactly 13 cards.

It then calculates an experimental strength value using weighted factors such as:

High-card values
Suit length
A-K combinations
A-Q combinations
K-Q combinations

The calculated strength is then converted into three estimated call ranges:

Safe
Medium
High
Technology
Flutter
Dart
Android
Material Design
No external database required for the basic version
Project Structure
lib/
├── main.dart
│
├── models/
│   ├── hand_data.dart
│   └── scoring_weights.dart
│
├── screens/
│   └── home_screen.dart
│
└── services/
    └── bridge_analyzer.dart
Getting Started
Requirements

Make sure you have:

Flutter SDK
Dart SDK
Android SDK
VS Code or another Flutter-compatible IDE

Check your Flutter installation with:

flutter doctor
Clone the Repository
git clone https://github.com/parvej-mosaraf/bridge-calculator.git

Then enter the project directory:

cd bridge-calculator
Install Dependencies
flutter pub get
Run the Application

For Chrome:

flutter run -d chrome

For a connected Android device:

flutter run
Building the APK

To create a release APK:

flutter build apk --release

The generated APK can be found at:

build/app/outputs/flutter-apk/app-release.apk
Download

The latest Android APK is available from the project's GitHub Releases page.

Latest Release

Bridge Calculator v1.0.0

Download:

bridge-calculator-v1.0.0.apk
Experimental Scoring System

The current scoring model is intentionally simple and configurable.

Example default weights include:

Factor	Weight
Ace	1.00
King	0.75
Queen	0.50
Jack	0.25
Ten	0.10
5-card suit bonus	0.50
6-card suit bonus	1.00
7+ card suit bonus	1.50
A-K combination	0.50
A-Q combination	0.30
K-Q combination	0.20

These values are experimental and can be adjusted as more example hands and results become available.

Future Improvements

Planned improvements include:

Adjustable scoring weights

Settings screen

More advanced Bridge hand analysis

Improved call estimation

Hand history

More detailed analysis

Improved Android adaptive icon

Additional UI improvements

Disclaimer

This project is an experimental educational application.

The call estimation is generated from a simplified heuristic scoring model. It should not be treated as an authoritative Bridge bidding system or guaranteed prediction.

License

This project is currently provided for educational and experimental purposes.

A formal open-source license may be added in a future release.

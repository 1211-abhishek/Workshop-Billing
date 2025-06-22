# Flutter Billing System

A modern, cross-platform billing and invoice management application built with Flutter. This project is primarily developed for Windows desktop and Android devices, providing a robust solution for small businesses and workshops to manage customers, products, and billing efficiently.

## Features
- Customer management (add, edit, delete)
- Product management (add, edit, delete)
- Invoice creation with itemized details
- PDF invoice generation and printing
- Billing history with search and filtering
- Data export and sharing (PDF, etc.)
- Responsive layout for desktop and mobile
- Local data storage using SQLite (with `sqflite` and `sqflite_common_ffi` for Windows)
- Clean Material 3 UI

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.7.0 or newer recommended)
- For Windows: Visual Studio with Desktop development tools
- For Android: Android Studio or compatible IDE

### Installation
1. Clone the repository:
   ```sh
   git clone <your-repo-url>
   cd flutter_billing_system
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   - **Windows:**
     ```sh
     flutter run -d windows
     ```
   - **Android:**
     ```sh
     flutter run -d android
     ```

## Project Structure
- `lib/` — Main Dart source code
  - `models/` — Data models (Customer, Product, BillingHistory, etc.)
  - `database/` — Database helper and logic
  - `screens/` — UI screens
  - `widgets/` — Reusable widgets
  - `services/` — Business logic/services
- `assets/` — Fonts and other assets
- `windows/` — Windows platform-specific code
- `android/` — Android platform-specific code

## Dependencies
- [Flutter](https://flutter.dev/)
- [sqflite](https://pub.dev/packages/sqflite)
- [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi) (for Windows)
- [pdf](https://pub.dev/packages/pdf), [printing](https://pub.dev/packages/printing)
- [share_plus](https://pub.dev/packages/share_plus)
- [permission_handler](https://pub.dev/packages/permission_handler)
- [intl](https://pub.dev/packages/intl)

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Note:** This project is under active development. Contributions and suggestions are welcome!

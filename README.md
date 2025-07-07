# Flight Search App

A Flutter application for searching and managing flight bookings with favorites functionality.

## Features

- **Flight Search**: Search for flights with various filters (direct flights, travel class, passengers)
- **Favorites**: Save and manage favorite flights locally using Hive
- **Animated UI**: Beautiful animations and smooth transitions
- **Clean Architecture**: Domain-driven design with Repository pattern
- **State Management**: Riverpod for reactive state management

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sessoun/flightSearchApp
   cd flightapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (Hive adapters and mocks)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test suites
```bash
# Run only use case tests
flutter test test/usecases_test.dart

# Run specific test file
flutter test test/features/favorites/domain/usecases/add_favorite_test.dart
```

## Project Structure

```
lib/
├── core/                     # Core utilities and configurations
│   ├── animations/           # Custom animations and transitions
│   ├── routes/              # App routing configuration
│   ├── theme/               # App theme and styling
│   └── utils/               # Utility classes and error handling
├── features/
│   ├── favorites/           # Favorites feature
│   │   ├── data/            # Data layer (repositories, data sources)
│   │   ├── domain/          # Domain layer (entities, use cases)
│   │   └── presentation/    # Presentation layer (screens, providers)
│   ├── flight_search/       # Flight search feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── onboarding/          # Onboarding feature
└── main.dart                # App entry point

test/                        # Unit tests
```

## Architecture

This app follows **Clean Architecture** principles:

- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI components and state management

## Key Dependencies

- `flutter_riverpod`: State management
- `go_router`: Navigation
- `hive`: Local database
- `dartz`: Functional programming utilities
- `mockitail`: Testing framework

## Troubleshooting

### Common Issues

1. **Build runner issues**
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Hive type registration errors**
   - Ensure `Hive.registerAdapter()` is called before opening boxes
   - Check that generated `.g.dart` files exist

3. **Test failures**
   - Run `flutter pub get` after adding new dependencies
   - Regenerate mocks with build_runner if repository interfaces change

## Development Notes

- Use `flutter analyze` to check for code issues
- Follow the existing code structure when adding new features
- Write tests for new use cases and repositories
- Use the provided animation utilities for consistent UI experience

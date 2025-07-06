# Favorites Feature - Clean Architecture Implementation

## 🏗️ Clean Architecture Structure

```
lib/features/favorites/
├── domain/                     # Business Logic Layer
│   ├── entities/
│   │   └── favorite_flight.dart       # Pure business entity
│   ├── repositories/
│   │   └── favorites_repository.dart  # Repository interface
│   └── usecases/
│       ├── get_all_favorites_usecase.dart
│       ├── add_favorite_usecase.dart
│       ├── remove_favorite_usecase.dart
│       ├── is_favorite_usecase.dart
│       ├── toggle_favorite_usecase.dart
│       └── clear_all_favorites_usecase.dart
├── data/                       # Data Access Layer
│   ├── models/
│   │   └── favorite_flight_model_clean.dart  # Hive data model
│   ├── datasources/
│   │   ├── favorites_local_data_source.dart  # Data source interface
│   │   └── favorites_hive_data_source.dart   # Hive implementation
│   └── repositories/
│       └── favorites_repository_impl.dart    # Repository implementation
└── presentation/              # Presentation Layer
    ├── providers/
    │   └── favorites_provider_clean.dart     # Riverpod state management
    └── screens/
        └── favorites_screen.dart             # UI screen
```

## 🎯 Key Principles Followed

### 1. **Dependency Inversion**
- Domain layer defines interfaces (repository)
- Data layer implements interfaces
- Presentation layer depends on domain abstractions

### 2. **Single Responsibility**
- Each use case handles one specific business operation
- Data sources handle only data access
- Models handle only data transformation

### 3. **Separation of Concerns**
- **Domain**: Pure business logic, no external dependencies
- **Data**: Handles data persistence and external APIs
- **Presentation**: UI logic and state management

### 4. **Clean Dependencies**
- Domain ← Data ← Presentation
- No circular dependencies
- Inner layers don't know about outer layers

## 🔧 Implementation Details

### Domain Layer (Business Logic)
```dart
// Pure entity with no external dependencies
class FavoriteFlight {
  final String flightNumber;
  final String airline;
  // ... other properties
}

// Repository interface defining contracts
abstract class FavoritesRepository {
  Future<List<FavoriteFlight>> getAllFavorites();
  Future<void> addFavorite(FavoriteFlight favorite);
  // ... other methods
}

// Use cases encapsulating business operations
class GetAllFavoritesUseCase {
  final FavoritesRepository repository;
  Future<List<FavoriteFlight>> call() => repository.getAllFavorites();
}
```

### Data Layer (Data Access)
```dart
// Data model with Hive annotations
@HiveType(typeId: 0)
class FavoriteFlightModel extends HiveObject {
  // Hive fields and methods
  
  // Conversion methods
  factory FavoriteFlightModel.fromEntity(FavoriteFlight entity);
  FavoriteFlight toEntity();
}

// Data source interface
abstract class FavoritesLocalDataSource {
  Future<List<FavoriteFlightModel>> getAllFavorites();
  // ... other methods
}

// Repository implementation
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;
  
  // Implements business contracts using data sources
}
```

### Presentation Layer (UI & State)
```dart
// Riverpod providers following dependency injection
final favoritesRepositoryProvider = Provider<FavoritesRepository>(...);
final getAllFavoritesUseCaseProvider = Provider<GetAllFavoritesUseCase>(...);

// State notifier using use cases
class FavoritesNotifier extends StateNotifier<AsyncValue<List<FavoriteFlight>>> {
  final GetAllFavoritesUseCase _getAllFavoritesUseCase;
  // ... other use cases
  
  // State management methods
}
```

## ✅ Benefits Achieved

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Changes in one layer don't affect others
3. **Scalability**: Easy to add new features or change data sources
4. **Flexibility**: Can swap Hive for any other storage solution
5. **Code Reusability**: Use cases can be reused across different UIs

## 🚀 Usage Example

```dart
// In the presentation layer
final favoritesNotifier = ref.read(favoritesProvider.notifier);

// Add favorite (goes through: UI → Use Case → Repository → Data Source → Hive)
await favoritesNotifier.toggleFavorite(favoriteFlight);

// Get all favorites (reverse flow)
final favorites = ref.watch(favoritesProvider);
```

## 📱 Features Implemented

- ✅ **Clean Architecture** with proper layer separation
- ✅ **Dependency Injection** using Riverpod
- ✅ **Use Cases** for business operations
- ✅ **Repository Pattern** for data access abstraction
- ✅ **Hive Integration** for local storage
- ✅ **Error Handling** with AsyncValue
- ✅ **State Management** with proper loading states

This implementation follows Uncle Bob's Clean Architecture principles and provides a solid foundation for the favorites feature that's maintainable, testable, and scalable.

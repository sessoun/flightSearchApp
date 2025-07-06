import 'package:flutter_test/flutter_test.dart';

// Import only the use case tests
import 'features/favorites/domain/usecases/add_favorite_test.dart' as add_favorite_test;
import 'features/favorites/domain/usecases/get_favorites_test.dart' as get_favorites_test;
import 'features/favorites/domain/usecases/remove_favorite_test.dart' as remove_favorite_test;

void main() {
  group('Favorites Use Cases Tests', () {
    group('Add Favorite Use Case', () {
      add_favorite_test.main();
    });

    group('Get All Favorites Use Case', () {
      get_favorites_test.main();
    });

    group('Remove Favorite Use Case', () {
      remove_favorite_test.main();
    });
  });
}

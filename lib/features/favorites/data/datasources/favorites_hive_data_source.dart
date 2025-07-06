import 'package:hive/hive.dart';
import 'favorites_local_data_source.dart';
import '../models/favorite_flight_model.dart';

class FavoritesHiveDataSource implements FavoritesLocalDataSource {
  static const String _boxName = 'favorites';
  Box<FavoriteFlightModel>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<FavoriteFlightModel>(_boxName);
  }

  Box<FavoriteFlightModel> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Favorites box is not initialized');
    }
    return _box!;
  }

  @override
  Future<List<FavoriteFlightModel>> getAllFavorites() async {
    return box.values.toList();
  }

  @override
  Future<void> addFavorite(FavoriteFlightModel favorite) async {
    await box.put(favorite.flightNumber, favorite);
  }

  @override
  Future<void> removeFavorite(String flightNumber) async {
    await box.delete(flightNumber);
  }

  @override
  Future<bool> isFavorite(String flightNumber) async {
    return box.containsKey(flightNumber);
  }

  @override
  Future<void> clearAllFavorites() async {
    await box.clear();
  }
}

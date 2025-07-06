import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import 'package:hive/hive.dart';
import 'favorites_local_data_source.dart';

class FavoritesHiveDataSource implements FavoritesLocalDataSource {
  late final Box<Flight> _box;

  FavoritesHiveDataSource() {
    _box = Hive.box<Flight>('favorites');
  }

  @override
  Future<List<Flight>> getAllFavorites() async {
    return _box.values.toList();
  }

  @override
  Future<void> addFavorite(Flight favorite) async {
    await _box.put(favorite.flightNumber, favorite);
  }

  @override
  Future<void> removeFavorite(String flightNumber) async {
    await _box.delete(flightNumber);
  }

  @override
  Future<bool> isFavorite(String flightNumber) async {
    return _box.containsKey(flightNumber);
  }

  @override
  Future<void> clearAllFavorites() async {
    await _box.clear();
  }
}

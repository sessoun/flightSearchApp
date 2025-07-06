import '../entities/favorite_flight.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteFlight>> getAllFavorites();
  Future<void> addFavorite(FavoriteFlight favorite);
  Future<void> removeFavorite(String flightNumber);
  Future<bool> isFavorite(String flightNumber);
  Future<void> clearAllFavorites();
}

import '../models/favorite_flight_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteFlightModel>> getAllFavorites();
  Future<void> addFavorite(FavoriteFlightModel favorite);
  Future<void> removeFavorite(String flightNumber);
  Future<bool> isFavorite(String flightNumber);
  Future<void> clearAllFavorites();
}

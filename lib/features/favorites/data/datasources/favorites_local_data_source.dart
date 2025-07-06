import 'package:flightapp/features/flight_search/domain/entities/flight.dart';


abstract class FavoritesLocalDataSource {
  Future<List<Flight>> getAllFavorites();
  Future<void> addFavorite(Flight favorite);
  Future<void> removeFavorite(String flightNumber);
  Future<bool> isFavorite(String flightNumber);
  Future<void> clearAllFavorites();
}

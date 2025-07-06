import '../../domain/entities/favorite_flight.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';
import '../models/favorite_flight_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  const FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<FavoriteFlight>> getAllFavorites() async {
    final models = await localDataSource.getAllFavorites();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addFavorite(FavoriteFlight favorite) async {
    final model = FavoriteFlightModel.fromEntity(favorite);
    await localDataSource.addFavorite(model);
  }

  @override
  Future<void> removeFavorite(String flightNumber) async {
    await localDataSource.removeFavorite(flightNumber);
  }

  @override
  Future<bool> isFavorite(String flightNumber) async {
    return await localDataSource.isFavorite(flightNumber);
  }

  @override
  Future<void> clearAllFavorites() async {
    await localDataSource.clearAllFavorites();
  }
}

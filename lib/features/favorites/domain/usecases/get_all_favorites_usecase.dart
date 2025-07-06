import '../entities/favorite_flight.dart';
import '../repositories/favorites_repository.dart';

class GetAllFavoritesUseCase {
  final FavoritesRepository repository;

  const GetAllFavoritesUseCase(this.repository);

  Future<List<FavoriteFlight>> call() async {
    return await repository.getAllFavorites();
  }
}

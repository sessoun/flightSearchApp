import '../repositories/favorites_repository.dart';

class ClearAllFavoritesUseCase {
  final FavoritesRepository repository;

  const ClearAllFavoritesUseCase(this.repository);

  Future<void> call() async {
    await repository.clearAllFavorites();
  }
}

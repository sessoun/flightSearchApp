import '../entities/favorite_flight.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  const ToggleFavoriteUseCase(this.repository);

  Future<void> call(FavoriteFlight favorite) async {
    final isFavorite = await repository.isFavorite(favorite.flightNumber);

    if (isFavorite) {
      await repository.removeFavorite(favorite.flightNumber);
    } else {
      await repository.addFavorite(favorite);
    }
  }
}

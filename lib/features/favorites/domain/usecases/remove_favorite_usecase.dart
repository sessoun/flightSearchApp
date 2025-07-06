import '../repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  final FavoritesRepository repository;

  const RemoveFavoriteUseCase(this.repository);

  Future<void> call(String flightNumber) async {
    await repository.removeFavorite(flightNumber);
  }
}

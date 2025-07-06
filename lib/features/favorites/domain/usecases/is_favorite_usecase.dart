import '../repositories/favorites_repository.dart';

class IsFavoriteUseCase {
  final FavoritesRepository repository;

  const IsFavoriteUseCase(this.repository);

  Future<bool> call(String flightNumber) async {
    return await repository.isFavorite(flightNumber);
  }
}

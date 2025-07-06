import '../entities/favorite_flight.dart';
import '../repositories/favorites_repository.dart';

class AddFavoriteUseCase {
  final FavoritesRepository repository;

  const AddFavoriteUseCase(this.repository);

  Future<void> call(FavoriteFlight favorite) async {
    await repository.addFavorite(favorite);
  }
}

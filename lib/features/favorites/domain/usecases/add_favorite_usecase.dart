import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import '../repositories/favorites_repository.dart';

class AddFavoriteUseCase {
  final FavoritesRepository repository;

  const AddFavoriteUseCase(this.repository);

  Future<void> call(Flight favorite) async {
    await repository.addFavorite(favorite);
  }
}

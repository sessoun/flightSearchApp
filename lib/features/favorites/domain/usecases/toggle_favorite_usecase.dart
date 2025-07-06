import 'package:dartz/dartz.dart';
import 'package:flightapp/core/utils/errors/failure.dart';
import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  const ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, String>> call(Flight flight) async {
    final isFavorite = await repository.isFavorite(flight.flightNumber);

    if (isFavorite) {
      return await repository.removeFavorite(flight.flightNumber);
    } else {
      return await repository.addFavorite(flight);
    }
  }
}

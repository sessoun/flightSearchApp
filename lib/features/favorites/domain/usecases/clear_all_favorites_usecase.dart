import 'package:dartz/dartz.dart';
import 'package:flightapp/core/utils/errors/failure.dart';
import '../repositories/favorites_repository.dart';

class ClearAllFavoritesUseCase {
  final FavoritesRepository repository;

  const ClearAllFavoritesUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.clearAllFavorites();
  }
}

import 'package:dartz/dartz.dart';
import 'package:flightapp/core/utils/errors/failure.dart';

import '../repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  final FavoritesRepository repository;

  const RemoveFavoriteUseCase(this.repository);

  Future<Either<Failure, String>> call(String flightNumber) async {
   return await repository.removeFavorite(flightNumber);
  }
}

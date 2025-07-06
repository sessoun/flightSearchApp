import 'package:dartz/dartz.dart';
import 'package:flightapp/core/utils/errors/failure.dart';
import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import '../repositories/favorites_repository.dart';

class AddFavoriteUseCase {
  final FavoritesRepository repository;

  const AddFavoriteUseCase(this.repository);

  Future<Either<Failure,String>> call(Flight favorite) async {
  return  await repository.addFavorite(favorite);
  }
}

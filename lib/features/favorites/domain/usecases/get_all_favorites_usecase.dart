import 'package:dartz/dartz.dart';
import 'package:flightapp/core/utils/errors/failure.dart';
import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import '../repositories/favorites_repository.dart';

class GetAllFavoritesUseCase {
  final FavoritesRepository repository;

  const GetAllFavoritesUseCase(this.repository);

  Future<Either<Failure,List<Flight>>> call() async {
    return await repository.getAllFavorites();
  }
}

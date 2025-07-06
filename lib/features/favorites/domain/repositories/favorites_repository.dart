import 'package:dartz/dartz.dart';
import 'package:flightapp/core/utils/errors/failure.dart';
import 'package:flightapp/features/flight_search/domain/entities/flight.dart';

abstract class FavoritesRepository {
  Future<Either<Failure,List<Flight>>> getAllFavorites();
  Future<Either<Failure, String>> addFavorite(Flight favorite);
  Future<Either<Failure, String>> removeFavorite(String flightNumber);
  Future<bool> isFavorite(String flightNumber);
  Future<Either<Failure, String>> clearAllFavorites();
}

import 'package:dartz/dartz.dart';
import 'package:flightapp/core/utils/errors/failure.dart';
import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  const FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Flight>>> getAllFavorites() async {
    try {
      final models = await localDataSource.getAllFavorites();
      final flights = models.map((model) => model).toList();
      return Right(flights);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addFavorite(Flight favorite) async {
    try {
      await localDataSource.addFavorite(favorite);
      return const Right('Flight added to favorites successfully');
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> removeFavorite(String flightNumber) async {
    try {
      await localDataSource.removeFavorite(flightNumber);
      return const Right('Flight removed from favorites successfully');
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<bool> isFavorite(String flightNumber) async {
    return await localDataSource.isFavorite(flightNumber);
  }

  @override
  Future<Either<Failure, String>> clearAllFavorites() async {
    try {
      await localDataSource.clearAllFavorites();
      return const Right('All favorites cleared successfully');
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

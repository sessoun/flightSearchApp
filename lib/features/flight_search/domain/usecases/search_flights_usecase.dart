import 'package:dartz/dartz.dart';
import 'package:flightapp/core/utils/errors/failure.dart';
import 'package:flightapp/features/flight_search/domain/entities/request.dart';

import '../entities/flight.dart';
import '../repositories/flight_repository.dart';

class SearchFlightsUseCase {
  final FlightRepository repository;

  SearchFlightsUseCase(this.repository);

  Future<Either<Failure,List<Flight>>> call(FlightSearchRequest request) async {
    return await repository.searchFlights(request);
  }
}
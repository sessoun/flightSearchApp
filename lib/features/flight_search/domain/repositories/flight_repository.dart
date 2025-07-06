import 'package:dartz/dartz.dart';
import 'package:flightapp/core/utils/errors/failure.dart';
import 'package:flightapp/features/flight_search/domain/entities/request.dart';

import '../entities/flight.dart';

abstract class FlightRepository {
  Future<Either<Failure,List<Flight>>> searchFlights(FlightSearchRequest request);
}
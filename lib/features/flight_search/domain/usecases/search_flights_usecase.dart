import 'package:flightapp/features/flight_search/domain/entities/request.dart';

import '../entities/flight.dart';
import '../repositories/flight_repository.dart';

class SearchFlightsUseCase {
  final FlightRepository repository;

  SearchFlightsUseCase(this.repository);

  Future<List<Flight>> call(FlightSearchRequest request) {
    return repository.searchFlights(request);
  }
}
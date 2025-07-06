import 'package:flightapp/features/flight_search/domain/entities/request.dart';

import '../entities/flight.dart';

abstract class FlightRepository {
  Future<List<Flight>> searchFlights(FlightSearchRequest request);
}
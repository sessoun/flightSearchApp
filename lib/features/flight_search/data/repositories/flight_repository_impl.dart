import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import 'package:flightapp/features/flight_search/domain/entities/request.dart';
import 'package:flightapp/features/flight_search/domain/repositories/flight_repository.dart';

import '../datasources/flight_remote_data_source.dart';
import '../models/flight_search_request_model.dart';

class FlightRepositoryImpl implements FlightRepository {
  final FlightRemoteDataSource remoteDataSource;

  FlightRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Flight>> searchFlights(FlightSearchRequest request) async {
    // Convert the FlightSearchRequest to FlightSearchRequestModel if needed
    final requestModel = FlightSearchRequestModel(
      from: request.from,
      to: request.to,
      date: request.date,
      returnDate: request.returnDate,
      passengers: request.passengers,
      directFlightsOnly: request.directFlightsOnly,
      travelClass: request.travelClass,
      tripType: request.tripType,
      includeNearbyAirports: request.includeNearbyAirports,
    );
    final models = await remoteDataSource.searchFlights(requestModel);
    return models
        .map(
          (e) => Flight(
            flightNumber: e.flightNumber,
            airline: e.airline,
            from: e.from,
            seatsAvailable: e.seatsAvailable,
            to: e.to,
            departure: e.departure,
            arrival: e.arrival,
            price: e.price,
            aircraft: e.aircraft,
            duration: e.duration,
            stops: e.stops,
          ),
        )
        .toList();
  }
}

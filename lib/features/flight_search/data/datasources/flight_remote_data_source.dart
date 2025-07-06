import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/flight_model.dart';
import '../models/flight_search_request_model.dart';

abstract class FlightRemoteDataSource {
  Future<List<FlightModel>> searchFlights(FlightSearchRequestModel request);
}

class MockFlightRemoteDataSource implements FlightRemoteDataSource {
  @override
  Future<List<FlightModel>> searchFlights(
    FlightSearchRequestModel request,
  ) async {
    print('🔍 Starting flight search...');
    final searchJson = request.toJson();
    print('📋 Search criteria: $searchJson');
    print('🔧 Using enhanced filtering with all search parameters');

    await Future.delayed(const Duration(seconds: 1));

    try {
      final data = await rootBundle.loadString('assets/mock/flights.json');
      print('📄 JSON data loaded successfully');

      final decoded = jsonDecode(data) as List;
      print('📋 Total flights in JSON: ${decoded.length}');

      final allFlights = decoded.map((e) => FlightModel.fromJson(e)).toList();
      print('✅ Flights converted to models: ${allFlights.length}');

      // Filter flights based on search criteria
      final filteredFlights = allFlights.where((flight) {
        // Basic route matching
        final fromMatch = _matchesLocation(
          flight.from,
          request.from,
          request.includeNearbyAirports,
        );
        final toMatch = _matchesLocation(
          flight.to,
          request.to,
          request.includeNearbyAirports,
        );

        // Date matching
        final flightDate = DateTime.parse(flight.departure);
        final searchDate = request.date;
        final dateMatch =
            flightDate.year == searchDate.year &&
            flightDate.month == searchDate.month &&
            flightDate.day == searchDate.day;

        // Direct flights filter
        final directMatch = !request.directFlightsOnly || flight.stops == 0;

        // Travel class availability check
        final classSeats = flight.getSeatsForClass(request.travelClass);
        final classCapacityMatch = classSeats >= request.passengers;

        print('🔎 Checking flight ${flight.flightNumber}:');
        print('   From: "${flight.from}" vs "${request.from}" = $fromMatch');
        print('   To: "${flight.to}" vs "${request.to}" = $toMatch');
        print(
          '   Date: ${flightDate.day}/${flightDate.month}/${flightDate.year} vs ${searchDate.day}/${searchDate.month}/${searchDate.year} = $dateMatch',
        );
        print(
          '   Direct filter: ${flight.stops == 0} (required: ${request.directFlightsOnly}) = $directMatch',
        );
        print(
          '   Travel class: ${request.travelClass} - Available seats: $classSeats >= ${request.passengers} = $classCapacityMatch',
        );
        print(
          '   Class price: \$${flight.getPriceForClass(request.travelClass).toStringAsFixed(2)}',
        );
        print('   Trip type: ${request.tripType}');
        print(
          '   Overall match: ${fromMatch && toMatch && dateMatch && directMatch && classCapacityMatch}',
        );
        print('   ---');

        return fromMatch &&
            toMatch &&
            dateMatch &&
            directMatch &&
            classCapacityMatch;
      }).toList();

      print('🎯 Filtered flights found: ${filteredFlights.length}');
      for (final flight in filteredFlights) {
        print('✈️ ${flight.flightNumber}: ${flight.from} → ${flight.to}');
      }

      return filteredFlights;
    } catch (e) {
      print('❌ Error loading flights: $e');
      rethrow;
    }
  }

  bool _matchesLocation(
    String flightLocation,
    String searchLocation,
    bool includeNearby,
  ) {
    // Basic string matching (case-insensitive)
    final basicMatch =
        flightLocation.toLowerCase().contains(searchLocation.toLowerCase()) ||
        searchLocation.toLowerCase().contains(flightLocation.toLowerCase());

    if (basicMatch) return true;

    // If including nearby airports, we could enhance this with airport code matching
    // For now, we'll use the basic match
    return false;
  }
}

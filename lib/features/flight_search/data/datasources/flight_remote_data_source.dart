import 'dart:convert';
import 'package:flightapp/core/utils/custom_print.dart';
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
    miPrint('🔍 Starting flight search...');
    final searchJson = request.toJson();
    miPrint('📋 Search criteria: $searchJson');
    miPrint('🔧 Using enhanced filtering with all search parameters');

    await Future.delayed(const Duration(seconds: 1));

    try {
      final data = await rootBundle.loadString('assets/mock/flights.json');
      miPrint('📄 JSON data loaded successfully');

      final decoded = jsonDecode(data) as List;
      miPrint('📋 Total flights in JSON: ${decoded.length}');

      final allFlights = decoded.map((e) => FlightModel.fromJson(e)).toList();
      miPrint('✅ Flights converted to models: ${allFlights.length}');

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
            flightDate.isAfter(searchDate) &&
            flightDate.isBefore(searchDate.add(const Duration(days: 3)));

        // Direct flights filter
        final directMatch = !request.directFlightsOnly || flight.stops == 0;

        // Travel class availability check
        final classSeats = flight.getSeatsForClass(request.travelClass);
        final classCapacityMatch = classSeats >= request.passengers;

        miPrint('🔎 Checking flight ${flight.flightNumber}:');
        miPrint('   From: "${flight.from}" vs "${request.from}" = $fromMatch');
        miPrint('   To: "${flight.to}" vs "${request.to}" = $toMatch');
        miPrint(
          '   Date: ${flightDate.day}/${flightDate.month}/${flightDate.year} vs ${searchDate.day}/${searchDate.month}/${searchDate.year} = $dateMatch',
        );
        miPrint(
          '   Direct filter: ${flight.stops == 0} (required: ${request.directFlightsOnly}) = $directMatch',
        );
        miPrint(
          '   Travel class: ${request.travelClass} - Available seats: $classSeats >= ${request.passengers} = $classCapacityMatch',
        );
        miPrint(
          '   Class price: \$${flight.getPriceForClass(request.travelClass).toStringAsFixed(2)}',
        );
        miPrint('   Trip type: ${request.tripType}');
        miPrint(
          '   Overall match: ${fromMatch && toMatch && dateMatch && directMatch && classCapacityMatch}',
        );
        miPrint('   ---');

        return fromMatch &&
            toMatch &&
            dateMatch &&
            directMatch &&
            classCapacityMatch;
      }).toList();

      miPrint('🎯 Filtered flights found: ${filteredFlights.length}');
      for (final flight in filteredFlights) {
        miPrint('✈️ ${flight.flightNumber}: ${flight.from} → ${flight.to}');
      }

      return filteredFlights;
    } catch (e) {
      miPrint('❌ Error loading flights: $e');
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

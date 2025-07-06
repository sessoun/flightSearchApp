import 'package:flightapp/features/flight_search/domain/entities/flight.dart';

class FlightModel extends Flight {
  FlightModel({
    required super.flightNumber,
    required super.airline,
    required super.from,
    required super.to,
    required super.departure,
    required super.arrival,
    required super.price,
    required super.aircraft,
    required super.duration,
    required super.stops,
    required super.seatsAvailable,
    super.travelClasses,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    // Parse travel classes if available
    Map<String, TravelClass>? travelClasses;
    if (json['travel_classes'] != null) {
      final travelClassesJson = json['travel_classes'] as Map<String, dynamic>;
      travelClasses = travelClassesJson.map(
        (key, value) => MapEntry(key, TravelClass.fromJson(value)),
      );
    }

    return FlightModel(
      flightNumber: json['flight_number'],
      airline: json['airline'],
      from: json['from'],
      to: json['to'],
      departure: json['departure'],
      arrival: json['arrival'],
      price: (json['price'] as num).toDouble(),
      aircraft: json['aircraft'],
      duration: json['duration'],
      stops: json['stops'],
      seatsAvailable: json['seats_available'] ?? 0,
      travelClasses: travelClasses,
    );
  }
}

extension FlightModelListExtension on List<FlightModel> {
  List<FlightModel> filterByPrice(double maxPrice) {
    return where((flight) => flight.price <= maxPrice).toList();
  }

  List<FlightModel> filterByStops(int maxStops) {
    return where((flight) => flight.stops <= maxStops).toList();
  }

  List<FlightModel> sortByDepartureTime() {
    List<FlightModel> sortedList = List.from(this);
    sortedList.sort((a, b) => a.departure.compareTo(b.departure));
    return sortedList;
  }
}

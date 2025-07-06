import 'package:flightapp/features/flight_search/domain/entities/request.dart';

class FlightSearchRequestModel extends FlightSearchRequest{
  FlightSearchRequestModel({
    required super.from,
    required super.to,
    required super.date,
    super.tripType,
    super.directFlightsOnly,
    super.includeNearbyAirports,
    super.travelClass,
    super.passengers,
    super.returnDate,
  });

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'date': date.toIso8601String(),
    'trip_type': tripType,
    'direct_flights_only': directFlightsOnly,
    'include_nearby_airports': includeNearbyAirports,
    'travel_class': travelClass,
    'passengers': passengers,
    if (returnDate != null) 'return_date': returnDate!.toIso8601String(),
  };

 
 
  @override
  String toString() {
    return 'FlightSearchRequestModel(from: $from, to: $to, date: $date, tripType: $tripType, directFlightsOnly: $directFlightsOnly, includeNearbyAirports: $includeNearbyAirports, travelClass: $travelClass, passengers: $passengers, returnDate: $returnDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlightSearchRequestModel &&
        other.from == from &&
        other.to == to &&
        other.date == date &&
        other.tripType == tripType &&
        other.directFlightsOnly == directFlightsOnly &&
        other.includeNearbyAirports == includeNearbyAirports &&
        other.travelClass == travelClass &&
        other.passengers == passengers &&
        other.returnDate == returnDate;
  }

}

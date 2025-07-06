class FlightSearchRequest {
  final String from;
  final String to;
  final DateTime date;
  final String tripType;
  final bool directFlightsOnly;
  final bool includeNearbyAirports;
  final String travelClass;
  final int passengers;
  final DateTime? returnDate; // For round trip

  FlightSearchRequest({
    required this.from,
    required this.to,
    required this.date,
    this.tripType = 'One way',
    this.directFlightsOnly = false,
    this.includeNearbyAirports = false,
    this.travelClass = 'Economy',
    this.passengers = 1,
    this.returnDate,
  });
}
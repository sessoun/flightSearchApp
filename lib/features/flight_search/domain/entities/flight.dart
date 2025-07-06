class Flight {
  final String flightNumber;
  final String airline;
  final String from;
  final String to;
  final String departure;
  final String arrival;
  final double price;
  final String aircraft;
  final String duration;
  final int stops;
  final int seatsAvailable;
  final Map<String, TravelClass>? travelClasses;

  Flight({
    required this.flightNumber,
    required this.airline,
    required this.from,
    required this.to,
    required this.departure,
    required this.arrival,
    required this.price,
    required this.aircraft,
    required this.duration,
    required this.stops,
    required this.seatsAvailable,
    this.travelClasses,
  });

  // Helper method to get price for specific travel class
  double getPriceForClass(String travelClass) {
    if (travelClasses == null) return price;

    final classKey = travelClass.toLowerCase().replaceAll(' ', '_');
    return travelClasses![classKey]?.price ?? price;
  }

  // Helper method to get available seats for specific travel class
  int getSeatsForClass(String travelClass) {
    if (travelClasses == null) return seatsAvailable;

    final classKey = travelClass.toLowerCase().replaceAll(' ', '_');
    return travelClasses![classKey]?.seatsAvailable ?? seatsAvailable;
  }
}

class TravelClass {
  final double price;
  final int seatsAvailable;

  TravelClass({required this.price, required this.seatsAvailable});

  factory TravelClass.fromJson(Map<String, dynamic> json) {
    return TravelClass(
      price: (json['price'] as num).toDouble(),
      seatsAvailable: json['seats_available'] ?? 0,
    );
  }
}

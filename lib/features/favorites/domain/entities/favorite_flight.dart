class FavoriteFlight {
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
  final String travelClass;
  final DateTime favoriteDate;

  const FavoriteFlight({
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
    required this.travelClass,
    required this.favoriteDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteFlight && other.flightNumber == flightNumber;
  }

  @override
  int get hashCode => flightNumber.hashCode;
}

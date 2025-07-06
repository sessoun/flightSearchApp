import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'flight.g.dart';


@HiveType(typeId: 0)
class Flight extends Equatable{
  
  @HiveField(1)
  final String flightNumber;
  @HiveField(2)
  final String airline;
@HiveField(3)
  final String from;
@HiveField(4)
  final String to;
@HiveField(5)
  final String departure;
@HiveField(6)
  final String arrival;
@HiveField(7)
  final double price;
@HiveField(8)
  final String aircraft;
@HiveField(9)
  final String duration;
@HiveField(10)
  final int stops;
@HiveField(11)
  final int seatsAvailable;
@HiveField(12)
  final Map<String, TravelClass>? travelClasses;


  const Flight({
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
  
  @override
  List<Object?> get props => [
    flightNumber,
    airline,
    from,
    to,
    departure,
    arrival,
    price,
    aircraft,
    duration,
    stops,
    seatsAvailable,
    travelClasses
  ];
}


@HiveType(typeId: 1)
class TravelClass {
  @HiveField(0)
  final double price;
  @HiveField(1)
  final int seatsAvailable;

  TravelClass({required this.price, required this.seatsAvailable});

  factory TravelClass.fromJson(Map<String, dynamic> json) {
    return TravelClass(
      price: (json['price'] as num).toDouble(),
      seatsAvailable: json['seats_available'] ?? 0,
    );
  }
}

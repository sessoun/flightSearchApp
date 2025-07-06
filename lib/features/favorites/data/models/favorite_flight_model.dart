import 'package:hive/hive.dart';
import '../../domain/entities/favorite_flight.dart';

part 'favorite_flight_model.g.dart';

@HiveType(typeId: 0)
class FavoriteFlightModel extends HiveObject {
  @HiveField(0)
  final String flightNumber;

  @HiveField(1)
  final String airline;

  @HiveField(2)
  final String from;

  @HiveField(3)
  final String to;

  @HiveField(4)
  final String departure;

  @HiveField(5)
  final String arrival;

  @HiveField(6)
  final double price;

  @HiveField(7)
  final String aircraft;

  @HiveField(8)
  final String duration;

  @HiveField(9)
  final int stops;

  @HiveField(10)
  final int seatsAvailable;

  @HiveField(11)
  final String travelClass;

  @HiveField(12)
  final DateTime favoriteDate;

  FavoriteFlightModel({
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

  // Convert from domain entity to data model
  factory FavoriteFlightModel.fromEntity(FavoriteFlight entity) {
    return FavoriteFlightModel(
      flightNumber: entity.flightNumber,
      airline: entity.airline,
      from: entity.from,
      to: entity.to,
      departure: entity.departure,
      arrival: entity.arrival,
      price: entity.price,
      aircraft: entity.aircraft,
      duration: entity.duration,
      stops: entity.stops,
      seatsAvailable: entity.seatsAvailable,
      travelClass: entity.travelClass,
      favoriteDate: entity.favoriteDate,
    );
  }

  // Convert from data model to domain entity
  FavoriteFlight toEntity() {
    return FavoriteFlight(
      flightNumber: flightNumber,
      airline: airline,
      from: from,
      to: to,
      departure: departure,
      arrival: arrival,
      price: price,
      aircraft: aircraft,
      duration: duration,
      stops: stops,
      seatsAvailable: seatsAvailable,
      travelClass: travelClass,
      favoriteDate: favoriteDate,
    );
  }
}

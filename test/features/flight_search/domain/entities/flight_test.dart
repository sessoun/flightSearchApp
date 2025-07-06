import 'package:flutter_test/flutter_test.dart';
import 'package:flightapp/features/flight_search/domain/entities/flight.dart';

void main() {
  group('Flight Entity', () {
    var testFlight = Flight(
      flightNumber: 'AA123',
      airline: 'American Airlines',
      from: 'New York',
      to: 'Los Angeles',
      departure: '10:00',
      arrival: '13:00',
      price: 299.99,
      aircraft: 'Boeing 737',
      duration: '3h',
      stops: 0,
      seatsAvailable: 150,
    );

    test('should correctly assign all properties', () {
      expect(testFlight.flightNumber, 'AA123');
      expect(testFlight.airline, 'American Airlines');
      expect(testFlight.from, 'New York');
      expect(testFlight.to, 'Los Angeles');
      expect(testFlight.departure, '10:00');
      expect(testFlight.arrival, '13:00');
      expect(testFlight.price, 299.99);
      expect(testFlight.aircraft, 'Boeing 737');
      expect(testFlight.duration, '3h');
      expect(testFlight.stops, 0);
      expect(testFlight.seatsAvailable, 150);
    });

    test('should support value equality', () {
      var anotherFlight = Flight(
        flightNumber: 'AA123',
        airline: 'American Airlines',
        from: 'New York',
        to: 'Los Angeles',
        departure: '10:00',
        arrival: '13:00',
        price: 299.99,
        aircraft: 'Boeing 737',
        duration: '3h',
        stops: 0,
        seatsAvailable: 150,
      );

      expect(testFlight, equals(anotherFlight));
    });

    test('should consider it a direct flight when stops is 0', () {
      expect(testFlight.stops, 0);
    });

    test('should treat price as a double', () {
      expect(testFlight.price, isA<double>());
    });

    test('should treat seatsAvailable as an integer', () {
      expect(testFlight.seatsAvailable, isA<int>());
    });
  });
}

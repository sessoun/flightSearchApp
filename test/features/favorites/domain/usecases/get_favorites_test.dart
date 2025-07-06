import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import 'package:flightapp/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:flightapp/features/favorites/domain/usecases/get_all_favorites_usecase.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late GetAllFavoritesUseCase usecase;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    usecase = GetAllFavoritesUseCase(mockRepository);
  });

  final testFlights = [
    Flight(
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
    ),
  ];

  test('returns list of favorite flights when successful', () async {
    when(() => mockRepository.getAllFavorites())
        .thenAnswer((_) async => Right(testFlights));

    final result = await usecase();

    expect(result, Right(testFlights));
    verify(() => mockRepository.getAllFavorites()).called(1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import 'package:flightapp/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:flightapp/features/favorites/domain/usecases/add_favorite_usecase.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late AddFavoriteUseCase usecase;
  late MockFavoritesRepository mockRepository;

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

  setUp(() {
    mockRepository = MockFavoritesRepository();
    usecase = AddFavoriteUseCase(mockRepository);
  });

  test(
    'should return success message when flight is added to favorites',
    () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(testFlight),
      ).thenAnswer((_) async => const Right('Flight added to favorites'));

      // Act
      final result = await usecase.call(testFlight);

      // Assert
      expect(result, const Right('Flight added to favorites'));
      verify(() => mockRepository.addFavorite(testFlight)).called(1);
    },
  );
}

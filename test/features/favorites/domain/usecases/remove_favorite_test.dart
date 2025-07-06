import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flightapp/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:flightapp/features/favorites/domain/usecases/remove_favorite_usecase.dart';
import 'package:mocktail/mocktail.dart';

// Create a simple mock without using mockito annotations
class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late RemoveFavoriteUseCase usecase;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    usecase = RemoveFavoriteUseCase(mockRepository);
  });

  const testFlightNumber = 'AA123';

  test(
    'should call repository removeFavorite with correct flight number',
    () async {
      // arrange
      when(
        () => mockRepository.removeFavorite(testFlightNumber),
      ).thenAnswer((_) async => const Right('Flight removed from favorites'));

      // act
      final result = await usecase.call(testFlightNumber);

      // assert
      result.fold(
        (failure) => fail('Should return success'),
        (message) => expect(message, 'Flight removed from favorites'),
      );
      verify(() => mockRepository.removeFavorite(testFlightNumber)).called(1);
    },
  );
}

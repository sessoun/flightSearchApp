import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/get_all_favorites_usecase.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import '../../domain/usecases/is_favorite_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/clear_all_favorites_usecase.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../data/datasources/favorites_hive_data_source.dart';

// Data source provider
final favoritesDataSourceProvider = Provider<FavoritesHiveDataSource>((ref) {
  return FavoritesHiveDataSource();
});

// Repository provider
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final dataSource = ref.watch(favoritesDataSourceProvider);
  return FavoritesRepositoryImpl(localDataSource: dataSource);
});

// Use case providers
final getAllFavoritesUseCaseProvider = Provider<GetAllFavoritesUseCase>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return GetAllFavoritesUseCase(repository);
});

final addFavoriteUseCaseProvider = Provider<AddFavoriteUseCase>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return AddFavoriteUseCase(repository);
});

final removeFavoriteUseCaseProvider = Provider<RemoveFavoriteUseCase>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return RemoveFavoriteUseCase(repository);
});

final isFavoriteUseCaseProvider = Provider<IsFavoriteUseCase>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return IsFavoriteUseCase(repository);
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return ToggleFavoriteUseCase(repository);
});

final clearAllFavoritesUseCaseProvider = Provider<ClearAllFavoritesUseCase>((
  ref,
) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return ClearAllFavoritesUseCase(repository);
});

// State notifier provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Flight>>>((ref) {
      final getAllFavoritesUseCase = ref.watch(getAllFavoritesUseCaseProvider);
      final removeFavoriteUseCase = ref.watch(removeFavoriteUseCaseProvider);
      final isFavoriteUseCase = ref.watch(isFavoriteUseCaseProvider);
      final toggleFavoriteUseCase = ref.watch(toggleFavoriteUseCaseProvider);
      final clearAllFavoritesUseCase = ref.watch(
        clearAllFavoritesUseCaseProvider,
      );

      return FavoritesNotifier(
        getAllFavoritesUseCase: getAllFavoritesUseCase,
        removeFavoriteUseCase: removeFavoriteUseCase,
        isFavoriteUseCase: isFavoriteUseCase,
        toggleFavoriteUseCase: toggleFavoriteUseCase,
        clearAllFavoritesUseCase: clearAllFavoritesUseCase,
      );
    });

class FavoritesNotifier extends StateNotifier<AsyncValue<List<Flight>>> {
  final GetAllFavoritesUseCase _getAllFavoritesUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;
  final IsFavoriteUseCase _isFavoriteUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final ClearAllFavoritesUseCase _clearAllFavoritesUseCase;

  FavoritesNotifier({
    required GetAllFavoritesUseCase getAllFavoritesUseCase,
    required RemoveFavoriteUseCase removeFavoriteUseCase,
    required IsFavoriteUseCase isFavoriteUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required ClearAllFavoritesUseCase clearAllFavoritesUseCase,
  }) : _getAllFavoritesUseCase = getAllFavoritesUseCase,
       _removeFavoriteUseCase = removeFavoriteUseCase,
       _isFavoriteUseCase = isFavoriteUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       _clearAllFavoritesUseCase = clearAllFavoritesUseCase,
       super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      state = const AsyncValue.loading();
      final result = await _getAllFavoritesUseCase();
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (favorites) => state = AsyncValue.data(favorites),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleFavorite(Flight favorite) async {
    final result = await _toggleFavoriteUseCase(favorite);
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (message) {
        loadFavorites(); // Refresh the list on success
      },
    );
  }

  Future<bool> isFavorite(String flightNumber) async {
    try {
      return await _isFavoriteUseCase(flightNumber);
    } catch (error) {
      return false;
    }
  }

  Future<void> removeFavorite(String flightNumber) async {
    final result = await _removeFavoriteUseCase(flightNumber);
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (message) {
        loadFavorites(); // Refresh the list on success
      },
    );
  }

  Future<void> clearAll() async {
    final result = await _clearAllFavoritesUseCase();
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (message) {
        loadFavorites(); // Refresh the list on success
      },
    );
  }
}

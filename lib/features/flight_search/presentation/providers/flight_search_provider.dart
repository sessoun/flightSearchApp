import 'package:flightapp/features/flight_search/domain/entities/request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/flight_remote_data_source.dart';
import '../../data/repositories/flight_repository_impl.dart';
import '../../domain/entities/flight.dart';
import '../../domain/usecases/search_flights_usecase.dart';

class FlightSearchState {
  final AsyncValue<List<Flight>> flights;
  final FlightSearchRequest? lastRequest;

  FlightSearchState({required this.flights, this.lastRequest});

  FlightSearchState copyWith({
    AsyncValue<List<Flight>>? flights,
    FlightSearchRequest? lastRequest,
  }) {
    return FlightSearchState(
      flights: flights ?? this.flights,
      lastRequest: lastRequest ?? this.lastRequest,
    );
  }
}

final flightSearchProvider =
    StateNotifierProvider<FlightSearchNotifier, FlightSearchState>((ref) {
      final dataSource = MockFlightRemoteDataSource();
      final repository = FlightRepositoryImpl(dataSource);
      final useCase = SearchFlightsUseCase(repository);
      return FlightSearchNotifier(useCase);
    });

class FlightSearchNotifier extends StateNotifier<FlightSearchState> {
  final SearchFlightsUseCase useCase;

  FlightSearchNotifier(this.useCase)
    : super(FlightSearchState(flights: const AsyncValue.data([])));

  Future<void> search(FlightSearchRequest request) async {
    state = state.copyWith(
      flights: const AsyncValue.loading(),
      lastRequest: request,
    );
    
      final result = await useCase(request);
    result.fold(
      (failure) {
        state = state.copyWith(
          flights: AsyncValue.error(failure.message, StackTrace.current),
        );
      },
      (flights) {
        state = state.copyWith(
          flights: AsyncValue.data(flights),
        );
      },  );
    
  }

  //sorting by price
  void sortFlightsByPrice() {
    final flights = state.flights.value;
    if (flights != null) {
      flights.sort((a, b) => a.price.compareTo(b.price));
      state = state.copyWith(flights: AsyncValue.data(flights));
    }
  }
}

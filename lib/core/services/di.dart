// import 'package:flightapp/features/flight_search/data/datasources/flight_remote_data_source.dart';
// import 'package:flightapp/features/flight_search/data/repositories/flight_repository_impl.dart';
// import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
// import 'package:flightapp/features/flight_search/domain/repositories/flight_repository.dart';
// import 'package:flightapp/features/flight_search/domain/usecases/search_flights_usecase.dart';
// import 'package:flightapp/features/flight_search/presentation/providers/flight_search_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// final flightRemoteDataSourceProvider = Provider<FlightRemoteDataSource>((ref) {
//   return MockFlightRemoteDataSource();
// });

// final flightRepositoryProvider = Provider<FlightRepository>((ref) {
//   final dataSource = ref.watch(flightRemoteDataSourceProvider);
//   return FlightRepositoryImpl(dataSource);
// });

// final searchFlightsUseCaseProvider = Provider<SearchFlightsUseCase>((ref) {
//   final repository = ref.watch(flightRepositoryProvider);
//   return SearchFlightsUseCase(repository);
// });

// final flightSearchProvider = StateNotifierProvider<FlightSearchNotifier, AsyncValue<List<Flight>>>((ref) {
//   final useCase = ref.watch(searchFlightsUseCaseProvider);
//   return FlightSearchNotifier(useCase);
// });

// // Global overrides for testing or development purposes
// final globalOverrides = <Override>[];
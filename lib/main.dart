// File: lib/main.dart

import 'package:flightapp/features/flight_search/domain/entities/flight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive
    ..registerAdapter(FlightAdapter())
    ..registerAdapter(TravelClassAdapter());

  await Hive.deleteBoxFromDisk('favorites');
  // Initialize favorites data source
  await Hive.openBox<Flight>('favorites');

  runApp(const ProviderScope(child: FlightSearchApp()));
}

class FlightSearchApp extends StatelessWidget {
  const FlightSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flight Search',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}

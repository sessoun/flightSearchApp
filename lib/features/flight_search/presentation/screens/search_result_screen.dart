import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/flight_search_provider.dart';
import '../widgets/flight_card.dart';
import '../../domain/entities/flight.dart';
import '../../domain/entities/request.dart';
import 'flight_detail_screen.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  const SearchResultScreen({super.key});

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    final flightSearchState = ref.watch(flightSearchProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Flights',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: flightSearchState.flights.when(
        data: (flights) =>
            _buildFlightResults(flights, flightSearchState.lastRequest),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Error loading flights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightResults(
    List<Flight> flights,
    FlightSearchRequest? searchRequest,
  ) {
    if (flights.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No flights found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Modify Search'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Flight route header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _extractAirportCode(flights.first.from),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _extractCityName(flights.first.from),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.flight_takeoff, color: Colors.grey[600]),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        width: 40,
                        height: 2,
                        color: Colors.grey[300],
                      ),
                      Icon(Icons.flight_land, color: Colors.grey[600]),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _extractAirportCode(flights.first.to),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _extractCityName(flights.first.to),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${DateFormat('EEE, MMM d').format(DateTime.parse(flights.first.departure))} • ${flights.length} result${flights.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort & Filter',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Icon(Icons.tune, color: Colors.grey[600], size: 20),
                ],
              ),
            ],
          ),
        ),
        // Flight results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: flights.length,
            itemBuilder: (context, index) {
              final flight = flights[index];
              final selectedTravelClass =
                  searchRequest?.travelClass ?? 'Economy';
              final classPrice = flight.getPriceForClass(selectedTravelClass);
              final classSeats = flight.getSeatsForClass(selectedTravelClass);

              // Format travel class for display
              final displayClass = selectedTravelClass == 'Premium Economy'
                  ? 'Premium Eco'
                  : selectedTravelClass;

              return FlightCard(
                flight: flight,
                priceLabel: '\$${classPrice.toStringAsFixed(0)}',
                travelClass: displayClass,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlightDetailScreen(
                        flight: flight,
                        searchRequest: searchRequest,
                      ),
                    ),
                  );
                },
                trailingAction: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${classPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '$classSeats seats available',
                      style: TextStyle(
                        fontSize: 11,
                        color: classSeats < 5
                            ? Colors.orange
                            : Colors.grey[600],
                        fontWeight: classSeats < 5
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper methods to extract airport codes and city names
  String _extractAirportCode(String cityWithCode) {
    final match = RegExp(r'\(([^)]+)\)').firstMatch(cityWithCode);
    return match?.group(1) ?? cityWithCode.split(' ').first;
  }

  String _extractCityName(String cityWithCode) {
    return cityWithCode.split(' (').first;
  }
}

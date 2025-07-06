import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/flight.dart';
import '../../domain/entities/request.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class FlightDetailScreen extends ConsumerWidget {
  final Flight flight;
  final FlightSearchRequest? searchRequest;

  const FlightDetailScreen({
    super.key,
    required this.flight,
    this.searchRequest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    // Get the selected travel class and corresponding price
    final selectedTravelClass = searchRequest?.travelClass ?? 'Economy';
    final classPrice = flight.getPriceForClass(selectedTravelClass);
    final classSeats = flight.getSeatsForClass(selectedTravelClass);

    // Watch favorites state
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final favoritesState = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Flight Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          favoritesState.when(
            data: (favorites) {
              final isFavorite = favorites.any(
                (fav) => fav.flightNumber == flight.flightNumber,
              );
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black,
                ),
                onPressed: () async {
                  final favoriteFlight = Flight(
                    flightNumber: flight.flightNumber,
                    seatsAvailable: flight.seatsAvailable,
                    airline: flight.airline,
                    from: flight.from,
                    to: flight.to,
                    departure: flight.departure,
                    arrival: flight.arrival,
                    price: classPrice,
                    aircraft: flight.aircraft,
                    duration: flight.duration,
                    stops: flight.stops,
                    travelClasses: flight.travelClasses,
                  );

                  await favoritesNotifier.toggleFavorite(favoriteFlight);

                  // Show snackbar feedback
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Flight removed from favorites'
                            : 'Flight added to favorites',
                      ),
                      backgroundColor: isFavorite
                          ? Colors.orange
                          : Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
            loading: () => const IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.grey),
              onPressed: null,
            ),
            error: (_, __) => const IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.grey),
              onPressed: null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAirlineHeader(),
                  const SizedBox(height: 24),
                  _buildFlightInformation(selectedTravelClass, classSeats),
                  const SizedBox(height: 24),
                  _buildFlightRoute(),
                  const SizedBox(height: 24),
                  _buildBaggageInformation(),
                  const SizedBox(height: 24),
                  _buildPolicies(),
                  const SizedBox(height: 24),
                  _buildAmenities(),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
          _buildBottomButton(context, classPrice),
        ],
      ),
    );
  }

  Widget _buildAirlineHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2E5266),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.flight, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flight.airline,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Flight Number: ${flight.flightNumber}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightInformation(String travelClass, int availableSeats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Flight Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.flight, 'Aircraft Type', flight.aircraft),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.airline_seat_recline_normal,
            'Seat Class',
            travelClass,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.event_seat,
            'Seats Available',
            '$availableSeats seats',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.schedule, 'Total Duration', flight.duration),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.location_on,
            'Layovers and Stops',
            flight.stops == 0
                ? 'Non-stop'
                : '${flight.stops} Stop${flight.stops > 1 ? 's' : ''}',
          ),
        ],
      ),
    );
  }

  Widget _buildFlightRoute() {
    final departureTime = DateTime.parse(flight.departure);
    final arrivalTime = DateTime.parse(flight.arrival);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Route header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _extractAirportCode(flight.from),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _extractCityName(flight.from),
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
                    _extractAirportCode(flight.to),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _extractCityName(flight.to),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Flight timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.jm().format(departureTime),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, yyyy').format(departureTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    flight.duration,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    width: 60,
                    height: 2,
                    color: Colors.grey[300],
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat.jm().format(arrivalTime),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, yyyy').format(arrivalTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),

          // Map placeholder
          const SizedBox(height: 20),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDF5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 32, color: Colors.grey[500]),
                  const SizedBox(height: 8),
                  Text(
                    'Flight Route Map',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaggageInformation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Baggage Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.luggage, 'Checked Baggage', '1 checked bag'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.work_outline, 'Carry-on Baggage', '1 carry-on'),
        ],
      ),
    );
  }

  Widget _buildPolicies() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Policies',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildPolicyRow(Icons.description, 'Cancellation Policy'),
          const SizedBox(height: 12),
          _buildPolicyRow(Icons.description, 'Refund Policy'),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildAmenityRow(Icons.tv, 'In-Flight Entertainment', true),
          const SizedBox(height: 12),
          _buildAmenityRow(Icons.wifi, 'Wi-Fi', true),
          const SizedBox(height: 12),
          _buildAmenityRow(Icons.restaurant, 'Meals', true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyRow(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildAmenityRow(IconData icon, String title, bool available) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: available ? Colors.green : Colors.grey[400],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: available ? Colors.black87 : Colors.grey[500],
            ),
          ),
        ),
        if (available)
          Icon(Icons.check_circle, size: 16, color: Colors.green)
        else
          Icon(Icons.cancel, size: 16, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, double price) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement booking logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking functionality to be implemented'),
                backgroundColor: Colors.blue,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            elevation: 0,
          ),
          child: Text(
            'Continue to Book - \$${price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
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

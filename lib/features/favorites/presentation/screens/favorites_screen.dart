import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/favorites_provider.dart';
import '../../../flight_search/presentation/screens/flight_detail_screen.dart';
import '../../../flight_search/domain/entities/flight.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);

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
          'Favorite Flights',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          favoritesState.when(
            data: (favorites) => favorites.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_all, color: Colors.black),
                    onPressed: () => _showClearAllDialog(context, ref),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: favoritesState.when(
        data: (favorites) => favorites.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return _buildFavoriteCard(context, ref, favorite);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Error loading favorites'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(favoritesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Favorite Flights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add flights to favorites to see them here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, WidgetRef ref, favorite) {
    final departureTime = DateTime.parse(favorite.departure);
    final arrivalTime = DateTime.parse(favorite.arrival);

    return GestureDetector(
      onTap: () {
        // Convert FavoriteFlight back to Flight entity for detail screen
        final flight = Flight(
          flightNumber: favorite.flightNumber,
          airline: favorite.airline,
          from: favorite.from,
          to: favorite.to,
          departure: favorite.departure,
          arrival: favorite.arrival,
          price: favorite.price,
          aircraft: favorite.aircraft,
          duration: favorite.duration,
          stops: favorite.stops,
          seatsAvailable: 10, // Default value since not stored in favorites
          travelClasses: null, // Would need to be reconstructed if needed
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailScreen(flight: flight),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with favorite date and remove button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E5266),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '\$${favorite.price.toStringAsFixed(0)} • ${favorite.travelClass}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Added ${DateFormat.MMMd().format(favorite.favoriteDate)}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () async {
                        await ref
                            .read(favoritesProvider.notifier)
                            .removeFavorite(favorite.flightNumber);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Flight removed from favorites'),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Airline info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E5266),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        favorite.airline,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E5266),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        favorite.stops == 0
                            ? 'Non-stop'
                            : '${favorite.stops} Stop${favorite.stops > 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        favorite.flightNumber,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Flight times
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
                      '${_extractAirportCode(favorite.from)} • ${_extractCityName(favorite.from)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      favorite.duration,
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
                      '${_extractAirportCode(favorite.to)} • ${_extractCityName(favorite.to)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Favorites'),
          content: const Text(
            'Are you sure you want to remove all favorite flights?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(favoritesProvider.notifier).clearAll();
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All favorites cleared'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper methods
  String _extractAirportCode(String cityWithCode) {
    final match = RegExp(r'\(([^)]+)\)').firstMatch(cityWithCode);
    return match?.group(1) ?? cityWithCode.split(' ').first;
  }

  String _extractCityName(String cityWithCode) {
    return cityWithCode.split(' (').first;
  }
}

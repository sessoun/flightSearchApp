import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../../../flight_search/presentation/screens/flight_detail_screen.dart';
import '../../../flight_search/presentation/widgets/flight_card.dart';
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
                  return FlightCard(
                    flight: favorite,
                    priceLabel: '\$${favorite.price.toStringAsFixed(0)}',
                    travelClass:
                        favorite.travelClasses?.toString() ?? 'Economy',
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
                        seatsAvailable:
                            10, // Default value since not stored in favorites
                        travelClasses:
                            null, // Would need to be reconstructed if needed
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FlightDetailScreen(flight: flight),
                        ),
                      );
                    },
                    trailingAction: IconButton(
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
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading favorites\n$error'),
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
}

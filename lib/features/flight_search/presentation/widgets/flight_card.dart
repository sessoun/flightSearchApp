import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../flight_search/domain/entities/flight.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  final VoidCallback? onTap;
  final Widget? trailingAction;
  final String? priceLabel;
  final String? travelClass;

  const FlightCard({
    super.key,
    required this.flight,
    this.onTap,
    this.trailingAction,
    this.priceLabel,
    this.travelClass,
  });

  @override
  Widget build(BuildContext context) {
    final departureTime = DateTime.parse(flight.departure);
    final arrivalTime = DateTime.parse(flight.arrival);

    // Use provided price label or default to flight price
    final displayPrice = priceLabel ?? '\$${flight.price.toStringAsFixed(0)}';
    final displayClass = travelClass ?? 'Economy';

    return GestureDetector(
      onTap: onTap,
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
            // Price and class header
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
                    '$displayPrice • $displayClass',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (trailingAction != null) trailingAction!,
              ],
            ),
            const SizedBox(height: 16),

            // Airline logo and info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E5266),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Airline logo area
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        flight.airline,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E5266),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Flight details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        flight.stops == 0
                            ? 'Non-stop'
                            : '${flight.stops} Stop${flight.stops > 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        flight.flightNumber,
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

            // Flight time details
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
                      '${_extractAirportCode(flight.from)} • ${_extractCityName(flight.from)}',
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
                      '${_extractAirportCode(flight.to)} • ${_extractCityName(flight.to)}',
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

  // Helper methods
  String _extractAirportCode(String cityWithCode) {
    final match = RegExp(r'\(([^)]+)\)').firstMatch(cityWithCode);
    return match?.group(1) ?? cityWithCode.split(' ').first;
  }

  String _extractCityName(String cityWithCode) {
    return cityWithCode.split(' (').first;
  }
}

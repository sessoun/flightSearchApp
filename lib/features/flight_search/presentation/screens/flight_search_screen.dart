import 'package:flightapp/features/flight_search/presentation/providers/flight_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../data/models/flight_search_request_model.dart';

class FlightSearchScreen extends ConsumerStatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  ConsumerState<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends ConsumerState<FlightSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _tripType = 'One way';
  bool _directFlightsOnly = false;
  bool _includeNearbyAirports = false;
  String _travelClass = 'Economy';
  int _passengers = 1;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  final _cities = [
    'Accra (ACC)',
    'Lagos (LOS)',
    'New York (NYC)',
    'London (LHR)',
    'Paris (CDG)',
    'Tokyo (NRT)',
    'Dubai (DXB)',
    'Singapore (SIN)',
    'Los Angeles (LAX)',
    'Cape Town (CPT)',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(flightSearchProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Search Flights',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.black),
            onPressed: () => context.push('/favorites'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ).copyWith(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTypeAheadField(
                  controller: _fromController,
                  label: 'From',
                  hint: 'Enter departure city',
                  onSelected: (val) => _fromController.text = val,
                  validator: (val) => val == null || val.isEmpty
                      ? 'Select departure city'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTypeAheadField(
                  controller: _toController,
                  label: 'To',
                  hint: 'Enter destination city',
                  onSelected: (val) => _toController.text = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Select arrival city' : null,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EDF5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTripTypeChip('One way'),
                      const SizedBox(width: 12),
                      _buildTripTypeChip('Round trip'),
                      const SizedBox(width: 12),
                      _buildTripTypeChip('Multi-City'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildDateField(),
                const SizedBox(height: 16),
                _buildTimeField(),
                const SizedBox(height: 24),
                const Text(
                  'Optional Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSwitchTile(
                  'Direct Flights Only',
                  _directFlightsOnly,
                  (val) => setState(() => _directFlightsOnly = val),
                ),
                _buildSwitchTile(
                  'Include Nearby Airports',
                  _includeNearbyAirports,
                  (val) => setState(() => _includeNearbyAirports = val),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _showTravelClassDialog(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Travel Class',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      Row(
                        children: [
                          Text(
                            _travelClass,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xFFE8EDF5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Passengers',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _passengers > 1
                              ? () => setState(() => _passengers--)
                              : null,
                        ),
                        Text(_passengers.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _passengers < 9
                              ? () => setState(() => _passengers++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: provider.flights.isLoading
                        ? DoNothingAction.new
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              // Combine date and time for departure
                              DateTime departureDateTime = _selectedDate!;
                              if (_selectedTime != null) {
                                departureDateTime = DateTime(
                                  _selectedDate!.year,
                                  _selectedDate!.month,
                                  _selectedDate!.day,
                                  _selectedTime!.hour,
                                  _selectedTime!.minute,
                                );
                              }

                              final request = FlightSearchRequestModel(
                                from: _fromController.text,
                                to: _toController.text,
                                date: departureDateTime,
                                tripType: _tripType,
                                directFlightsOnly: _directFlightsOnly,
                                includeNearbyAirports: _includeNearbyAirports,
                                travelClass: _travelClass,
                                passengers: _passengers,
                                returnDate: _tripType == 'Round trip'
                                    ? departureDateTime.add(
                                        const Duration(days: 7),
                                      )
                                    : null, // Example return date
                              );

                              await ref
                                  .read(flightSearchProvider.notifier)
                                  .search(request)
                                  .then((_) {
                                    if (!provider.flights.hasError) {
                                      context.push('/search/result');
                                    }
                                  });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: provider.flights.isLoading
                          ? null
                          : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    child: provider.flights.isLoading
                        ? const Center(
                            child: Row(
                              spacing: 8,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Searching...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SpinKitPulse(
                                  color: Colors.white,
                                  size: 20.0,
                                  duration: Duration(milliseconds: 800),
                                ),
                              ],
                            ),
                          )
                        : const Text(
                            'Search Flights',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeAheadField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required void Function(String) onSelected,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TypeAheadField<String>(
        controller: controller,
        suggestionsCallback: (pattern) {
          return _cities
              .where(
                (city) => city.toLowerCase().contains(pattern.toLowerCase()),
              )
              .toList();
        },

        itemBuilder: (context, suggestion) {
          return ListTile(title: Text(suggestion));
        },
        onSelected: onSelected,
        builder: (context, controller, focusNode) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        controller.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFE8EDF5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: validator,
            onChanged: (value) {
              setState(() {}); // Rebuild to show/hide clear button
            },
          );
        },
      ),
    );
  }

  Widget _buildTripTypeChip(String type) {
    final isSelected = _tripType == type;
    return GestureDetector(
      onTap: () => setState(() => _tripType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? const Color.fromARGB(255, 34, 34, 34) : null,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Departure Date',
          hintText: _selectedDate == null
              ? 'Select date'
              : DateFormat.yMMMEd().format(_selectedDate!),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFE8EDF5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (picked != null) {
            setState(() => _selectedDate = picked);
          }
        },
        validator: (_) => _selectedDate == null ? 'Select travel date' : null,
      ),
    );
  }

  Widget _buildTimeField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Departure Time (Optional)',
          hintText: _selectedTime == null
              ? 'Select time'
              : _selectedTime!.format(context),
          suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFE8EDF5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: _selectedTime ?? TimeOfDay.now(),
          );
          if (picked != null) {
            setState(() => _selectedTime = picked);
          }
        },
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
          inactiveTrackColor: const Color(0xFFE8EDF5),
          inactiveThumbColor: Colors.grey,
        ),
      ],
    );
  }

  void _showTravelClassDialog() {
    final classes = ['Economy', 'Premium Economy', 'Business', 'First Class'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Travel Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: classes.map((travelClass) {
              return ListTile(
                title: Text(travelClass),
                leading: Radio<String>(
                  value: travelClass,
                  groupValue: _travelClass,
                  onChanged: (String? value) {
                    setState(() {
                      _travelClass = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _travelClass = travelClass;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

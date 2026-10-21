import 'package:flutter/material.dart';

import 'app_locale.dart';
import 'l10n/app_localizations.dart';
import 'route_details_screen.dart';

/// Bus route finder for LankaTransit.
///
/// IMPORTANT:
/// The route times and fares in this starter dataset are illustrative examples,
/// not verified live transport data. Replace them with confirmed information
/// from the relevant transport operator before presenting them as official.
class BusRoutesScreen extends StatefulWidget {
  const BusRoutesScreen({super.key});

  @override
  State<BusRoutesScreen> createState() => _BusRoutesScreenState();
}

class _BusRoutesScreenState extends State<BusRoutesScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();

  String _fromQuery = '';
  String _toQuery = '';
  String _routeQuery = '';
  bool _hasSearched = false;

  // Starter examples only. Verify route numbers, stops, timetables and fares
  // with official operators before using this as real-world travel guidance.
  final List<Map<String, dynamic>> _busRoutes = [
    {
      'number': '138',
      'route': 'Colombo → Kaduwela',
      'from': 'Colombo',
      'to': 'Kaduwela',
      'duration': '45–70 min',
      'fare': 'Check current fare',
      'boardingStand': 'Pettah / Colombo bus terminal',
      'departureTimes': ['6:00 AM', '6:30 AM', '7:00 AM', '7:30 AM'],
      'stops': ['Colombo', 'Borella', 'Rajagiriya', 'Battaramulla', 'Kaduwela'],
      'startLat': 6.9271,
      'startLng': 79.8612,
      'endLat': 6.9369,
      'endLng': 80.0028,
    },
    {
      'number': '100',
      'route': 'Panadura → Colombo',
      'from': 'Panadura',
      'to': 'Colombo',
      'duration': '60–90 min',
      'fare': 'Check current fare',
      'boardingStand': 'Panadura bus stand',
      'departureTimes': ['6:00 AM', '6:20 AM', '6:40 AM', '7:00 AM'],
      'stops': ['Panadura', 'Moratuwa', 'Mount Lavinia', 'Dehiwala', 'Colombo'],
      'startLat': 6.7132,
      'startLng': 79.9074,
      'endLat': 6.9271,
      'endLng': 79.8612,
    },
    {
      'number': '02',
      'route': 'Galle → Colombo',
      'from': 'Galle',
      'to': 'Colombo',
      'duration': '2–3 hr',
      'fare': 'Check current fare',
      'boardingStand': 'Galle Central Bus Stand',
      'departureTimes': ['5:30 AM', '6:00 AM', '6:30 AM', '7:00 AM'],
      'stops': ['Galle', 'Hikkaduwa', 'Ambalangoda', 'Kalutara', 'Colombo'],
      'startLat': 6.0329,
      'startLng': 80.2168,
      'endLat': 6.9271,
      'endLng': 79.8612,
    },
    {
      'number': '177',
      'route': 'Kaduwela → Kollupitiya',
      'from': 'Kaduwela',
      'to': 'Kollupitiya',
      'duration': '60–90 min',
      'fare': 'Check current fare',
      'boardingStand': 'Kaduwela bus stand',
      'departureTimes': ['6:00 AM', '6:30 AM', '7:00 AM'],
      'stops': [
        'Kaduwela',
        'Battaramulla',
        'Rajagiriya',
        'Borella',
        'Kollupitiya',
      ],
      'startLat': 6.9369,
      'startLng': 80.0028,
      'endLat': 6.9115,
      'endLng': 79.8518,
    },
    {
      'number': 'Negombo–Colombo',
      'route': 'Negombo → Colombo',
      'from': 'Negombo',
      'to': 'Colombo',
      'duration': '60–100 min',
      'fare': 'Check current fare',
      'boardingStand': 'Negombo bus stand',
      'departureTimes': ['6:00 AM', '6:30 AM', '7:00 AM'],
      'stops': ['Negombo', 'Ja-Ela', 'Wattala', 'Colombo'],
      'startLat': 7.2083,
      'startLng': 79.8358,
      'endLat': 6.9271,
      'endLng': 79.8612,
    },
    {
      'number': 'Kandy–Colombo',
      'route': 'Kandy → Colombo',
      'from': 'Kandy',
      'to': 'Colombo',
      'duration': '3–4 hr',
      'fare': 'Check current fare',
      'boardingStand': 'Kandy Goods Shed Bus Stand',
      'departureTimes': ['5:30 AM', '6:00 AM', '6:30 AM'],
      'stops': ['Kandy', 'Kadugannawa', 'Mawanella', 'Kegalle', 'Colombo'],
      'startLat': 7.2906,
      'startLng': 80.6337,
      'endLat': 6.9271,
      'endLng': 79.8612,
    },
    {
      'number': 'Galle–Matara',
      'route': 'Galle → Matara',
      'from': 'Galle',
      'to': 'Matara',
      'duration': '60–90 min',
      'fare': 'Check current fare',
      'boardingStand': 'Galle Central Bus Stand',
      'departureTimes': ['6:00 AM', '6:30 AM', '7:00 AM'],
      'stops': [
        'Galle',
        'Unawatuna junction',
        'Ahangama',
        'Weligama',
        'Matara',
      ],
      'startLat': 6.0329,
      'startLng': 80.2168,
      'endLat': 5.9549,
      'endLng': 80.5550,
    },
    {
      'number': 'Jaffna–Vavuniya',
      'route': 'Jaffna → Vavuniya',
      'from': 'Jaffna',
      'to': 'Vavuniya',
      'duration': '2–3 hr',
      'fare': 'Check current fare',
      'boardingStand': 'Jaffna Central Bus Stand',
      'departureTimes': ['6:00 AM', '7:00 AM', '8:00 AM'],
      'stops': ['Jaffna', 'Kilinochchi', 'Mullaitivu junction', 'Vavuniya'],
      'startLat': 9.6615,
      'startLng': 80.0255,
      'endLat': 8.7514,
      'endLng': 80.4971,
    },
    {
      'number': 'Anuradhapura–Dambulla',
      'route': 'Anuradhapura → Dambulla',
      'from': 'Anuradhapura',
      'to': 'Dambulla',
      'duration': '1–2 hr',
      'fare': 'Check current fare',
      'boardingStand': 'Anuradhapura bus stand',
      'departureTimes': ['6:00 AM', '7:00 AM', '8:00 AM'],
      'stops': ['Anuradhapura', 'Kekirawa', 'Dambulla'],
      'startLat': 8.3114,
      'startLng': 80.4037,
      'endLat': 7.8600,
      'endLng': 80.6517,
    },
    {
      'number': 'Kurunegala–Kandy',
      'route': 'Kurunegala → Kandy',
      'from': 'Kurunegala',
      'to': 'Kandy',
      'duration': '1.5–2.5 hr',
      'fare': 'Check current fare',
      'boardingStand': 'Kurunegala bus stand',
      'departureTimes': ['6:00 AM', '6:30 AM', '7:00 AM'],
      'stops': ['Kurunegala', 'Mawathagama', 'Galagedara', 'Kandy'],
      'startLat': 7.4863,
      'startLng': 80.3623,
      'endLat': 7.2906,
      'endLng': 80.6337,
    },
    {
      'number': 'Matara–Hambantota',
      'route': 'Matara → Hambantota',
      'from': 'Matara',
      'to': 'Hambantota',
      'duration': '1.5–2.5 hr',
      'fare': 'Check current fare',
      'boardingStand': 'Matara bus stand',
      'departureTimes': ['6:00 AM', '7:00 AM', '8:00 AM'],
      'stops': ['Matara', 'Dikwella', 'Tangalle', 'Beliatta', 'Hambantota'],
      'startLat': 5.9549,
      'startLng': 80.5550,
      'endLat': 6.1241,
      'endLng': 81.1185,
    },
    {
      'number': 'Badulla–Ella',
      'route': 'Badulla → Ella',
      'from': 'Badulla',
      'to': 'Ella',
      'duration': '45–75 min',
      'fare': 'Check current fare',
      'boardingStand': 'Badulla bus stand',
      'departureTimes': ['6:00 AM', '7:00 AM', '8:00 AM'],
      'stops': ['Badulla', 'Hali-Ela', 'Demodara', 'Ella'],
      'startLat': 6.9934,
      'startLng': 81.0550,
      'endLat': 6.8667,
      'endLng': 81.0466,
    },
  ];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _routeController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRoutes {
    final from = _fromQuery.trim().toLowerCase();
    final to = _toQuery.trim().toLowerCase();
    final routeQuery = _routeQuery.trim().toLowerCase();

    return _busRoutes.where((route) {
      final routeFrom = route['from'].toString().toLowerCase();
      final routeTo = route['to'].toString().toLowerCase();
      final routeName = route['route'].toString().toLowerCase();
      final number = route['number'].toString().toLowerCase();
      final stops = (route['stops'] as List)
          .map((stop) => stop.toString().toLowerCase())
          .toList();

      final fromMatches =
          from.isEmpty ||
          routeFrom.contains(from) ||
          stops.any((stop) => stop.contains(from));
      final toMatches =
          to.isEmpty ||
          routeTo.contains(to) ||
          stops.any((stop) => stop.contains(to));
      final queryMatches =
          routeQuery.isEmpty ||
          routeName.contains(routeQuery) ||
          number.contains(routeQuery) ||
          routeFrom.contains(routeQuery) ||
          routeTo.contains(routeQuery) ||
          stops.any((stop) => stop.contains(routeQuery));

      // If both places are given, show routes that pass through both places
      // in the correct order. This is a starter search, not a route planner.
      final fromIndex = from.isEmpty
          ? 0
          : stops.indexWhere((stop) => stop.contains(from));
      final toIndex = to.isEmpty
          ? stops.length - 1
          : stops.indexWhere((stop) => stop.contains(to));
      final correctOrder = from.isEmpty || to.isEmpty || fromIndex <= toIndex;

      return fromMatches && toMatches && queryMatches && correctOrder;
    }).toList();
  }

  void _searchRoutes() {
    setState(() {
      _fromQuery = _fromController.text;
      _toQuery = _toController.text;
      _routeQuery = _routeController.text;
      _hasSearched = true;
    });
    FocusScope.of(context).unfocus();
  }

  void _clearSearch() {
    _fromController.clear();
    _toController.clear();
    _routeController.clear();
    setState(() {
      _fromQuery = '';
      _toQuery = '';
      _routeQuery = '';
      _hasSearched = false;
    });
  }

  void _openRouteDetails(Map<String, dynamic> route) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _RouteInformationSheet(
        route: route,
        onShowMap: () {
          Navigator.pop(sheetContext);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RouteDetailsScreen(
                transportType: 'Bus Route',
                routeName: route['route'].toString(),
                from: route['from'].toString(),
                to: route['to'].toString(),
                icon: Icons.directions_bus_rounded,
                iconColor: const Color(0xFF38BDF8),
                startLat: route['startLat'] as double,
                startLng: route['startLng'] as double,
                endLat: route['endLat'] as double,
                endLng: route['endLng'] as double,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF070B18),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      l10n.busRoutes,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF3F6FF),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => showLanguageSelector(context),
                    icon: const Icon(
                      Icons.language_rounded,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                children: [
                  const Text(
                    'Find your bus',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF3F6FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Search by starting point, destination, or bus number.',
                    style: TextStyle(
                      color: Color(0xFF9AAAC4),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _SearchField(
                    controller: _fromController,
                    label: 'From',
                    hint: 'Where are you starting?',
                    icon: Icons.trip_origin_rounded,
                  ),
                  const SizedBox(height: 12),
                  _SearchField(
                    controller: _toController,
                    label: 'To',
                    hint: 'Where do you want to go?',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 12),
                  _SearchField(
                    controller: _routeController,
                    label: 'Bus number or stop (optional)',
                    hint: 'e.g. 138, Borella, Kandy',
                    icon: Icons.directions_bus_rounded,
                    onSubmitted: (_) => _searchRoutes(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _searchRoutes,
                          icon: const Icon(Icons.search_rounded),
                          label: const Text('Search buses'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38BDF8),
                            foregroundColor: const Color(0xFF111A2E),
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filledTonal(
                        tooltip: 'Clear search',
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.refresh_rounded),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(52, 52),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF302A1C),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFFFBBF24),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Preview data: times and fares are not verified live information. Confirm with the bus operator before travelling.',
                            style: TextStyle(
                              color: Color(0xFFFDE68A),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _hasSearched ? 'Search results' : 'Example routes',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF3F6FF),
                          ),
                        ),
                      ),
                      Text(
                        '${_filteredRoutes.length} routes',
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_filteredRoutes.isEmpty)
                    const _EmptyRoutesWidget(
                      message: 'No matching routes in this sample list. Try another location.',
                    )
                  else
                    ..._filteredRoutes.map(
                      (route) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _BusRouteCard(
                          route: route,
                          onTap: () => _openRouteDetails(route),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final ValueChanged<String>? onSubmitted;

  const _SearchField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF111A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF263653)),
      ),
      child: TextField(
        controller: controller,
        textInputAction: onSubmitted == null
            ? TextInputAction.next
            : TextInputAction.search,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF38BDF8)),
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _BusRouteCard extends StatelessWidget {
  final Map<String, dynamic> route;
  final VoidCallback onTap;

  const _BusRouteCard({required this.route, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final stops = (route['stops'] as List).join('  •  ');

    return Material(
      color: const Color(0xFF111A2E),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF15223B),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.directions_bus_rounded,
                          color: Color(0xFF38BDF8),
                        ),
                        const SizedBox(height: 3),
                        Flexible(
                          child: Text(
                            route['number'].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF38BDF8),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route['route'].toString(),
                          style: const TextStyle(
                            color: Color(0xFFF3F6FF),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Approx. ${route['duration']}',
                          style: const TextStyle(
                            color: Color(0xFF9AAAC4),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF38BDF8),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _InfoLine(
                icon: Icons.directions_bus_filled_outlined,
                title: 'Boarding stand',
                value: route['boardingStand'].toString(),
              ),
              const SizedBox(height: 8),
              _InfoLine(
                icon: Icons.schedule_rounded,
                title: 'Example departures',
                value: (route['departureTimes'] as List).join(', '),
              ),
              const SizedBox(height: 8),
              _InfoLine(
                icon: Icons.payments_outlined,
                title: 'Fare',
                value: route['fare'].toString(),
              ),
              const SizedBox(height: 12),
              Text(
                'Stops: $stops',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF9AAAC4),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'View details →',
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoLine({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF38BDF8)),
        const SizedBox(width: 8),
        SizedBox(
          width: 112,
          child: Text(
            '$title:',
            style: const TextStyle(
              color: Color(0xFF9AAAC4),
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF3F6FF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _RouteInformationSheet extends StatelessWidget {
  final Map<String, dynamic> route;
  final VoidCallback onShowMap;

  const _RouteInformationSheet({required this.route, required this.onShowMap});

  @override
  Widget build(BuildContext context) {
    final stops = (route['stops'] as List).cast<String>();
    final departures = (route['departureTimes'] as List).cast<String>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.86,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF111A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF263653),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              route['route'].toString(),
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF3F6FF),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Bus route ${route['number']}',
              style: const TextStyle(color: Color(0xFF9AAAC4)),
            ),
            const SizedBox(height: 22),
            _InfoLine(
              icon: Icons.location_on_outlined,
              title: 'Boarding stand',
              value: route['boardingStand'].toString(),
            ),
            const SizedBox(height: 14),
            _InfoLine(
              icon: Icons.timelapse_rounded,
              title: 'Journey time',
              value: route['duration'].toString(),
            ),
            const SizedBox(height: 14),
            _InfoLine(
              icon: Icons.payments_outlined,
              title: 'Fare',
              value: route['fare'].toString(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Example departure times',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF3F6FF),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: departures
                  .map(
                    (time) => Chip(
                      avatar: const Icon(Icons.schedule_rounded, size: 16),
                      label: Text(time),
                      backgroundColor: const Color(0xFF15223B),
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 22),
            const Text(
              'Stops along the route',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF3F6FF),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(stops.length, (index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    child: Column(
                      children: [
                        Icon(
                          index == 0 || index == stops.length - 1
                              ? Icons.location_on_rounded
                              : Icons.circle,
                          size: index == 0 || index == stops.length - 1
                              ? 19
                              : 9,
                          color: const Color(0xFF38BDF8),
                        ),
                        if (index != stops.length - 1)
                          Container(
                            width: 2,
                            height: 28,
                            color: const Color(0xFF263653),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1, bottom: 20),
                      child: Text(
                        stops[index],
                        style: const TextStyle(
                          color: Color(0xFFF3F6FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF302A1C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'These are example details for app development, not verified live timetable or fare information. Please confirm before travelling.',
                style: TextStyle(color: Color(0xFFFDE68A), fontSize: 12),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onShowMap,
              icon: const Icon(Icons.map_outlined),
              label: const Text('View route on map'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                foregroundColor: const Color(0xFF111A2E),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRoutesWidget extends StatelessWidget {
  final String message;

  const _EmptyRoutesWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF111A2E),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF15223B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: Color(0xFF38BDF8),
              size: 32,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF3F6FF),
            ),
          ),
        ],
      ),
    );
  }
}

/// Language selector shared with the other screens.
void showLanguageSelector(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF111A2E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.language_rounded,
                    color: Color(0xFF38BDF8),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.language,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF3F6FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _LanguageOption(
                title: l10n.english,
                subtitle: 'English',
                locale: const Locale('en'),
              ),
              const SizedBox(height: 10),
              _LanguageOption(
                title: l10n.sinhala,
                subtitle: 'සිංහල',
                locale: const Locale('si'),
              ),
              const SizedBox(height: 10),
              _LanguageOption(
                title: l10n.tamil,
                subtitle: 'தமிழ்',
                locale: const Locale('ta'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final Locale locale;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = appLocale.value.languageCode == locale.languageCode;

    return Material(
      color: isSelected ? const Color(0xFF15223B) : const Color(0xFF0D1425),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () {
          appLocale.value = locale;
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF111A2E),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    locale.languageCode == 'en' ? '🇬🇧' : '🇱🇰',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF3F6FF),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9AAAC4),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF38BDF8),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

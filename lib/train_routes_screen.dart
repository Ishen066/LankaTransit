import 'package:flutter/material.dart';

import 'app_locale.dart';
import 'l10n/app_localizations.dart';
import 'route_details_screen.dart';

const Color _background = Color(0xFF070B18);
const Color _surface = Color(0xFF111A2E);
const Color _surfaceLight = Color(0xFF15223B);
const Color _cyan = Color(0xFF38BDF8);
const Color _purple = Color(0xFF8B5CF6);
const Color _text = Color(0xFFF3F6FF);
const Color _muted = Color(0xFF9AA9C4);
const Color _border = Color(0xFF26334D);

class TrainRoutesScreen extends StatefulWidget {
  const TrainRoutesScreen({super.key});

  @override
  State<TrainRoutesScreen> createState() => _TrainRoutesScreenState();
}

class _TrainRoutesScreenState extends State<TrainRoutesScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _lineController = TextEditingController();

  String _fromQuery = '';
  String _toQuery = '';
  String _routeQuery = '';
  bool _hasSearched = false;

  // Illustrative sample data. Not live railway information.
  final List<Map<String, dynamic>> _trainRoutes = [
    {
      'number': 'Coastal Line',
      'route': 'Colombo Fort → Galle',
      'from': 'Colombo Fort',
      'to': 'Galle',
      'duration': '2–3 hr (example)',
      'fare': 'Check current railway fare',
      'boardingStand': 'Colombo Fort Railway Station',
      'departureTimes': [
        'Example: 6:00 AM',
        'Example: 7:00 AM',
        'Example: 8:00 AM',
      ],
      'stops': [
        'Colombo Fort',
        'Dehiwala',
        'Panadura',
        'Kalutara South',
        'Aluthgama',
        'Ambalangoda',
        'Galle',
      ],
      'startLat': 6.9344,
      'startLng': 79.8428,
      'endLat': 6.0329,
      'endLng': 80.2168,
      'routePath': [
        [6.9344, 79.8428],
        [6.9060, 79.8530],
        [6.8500, 79.8650],
        [6.7132, 79.9074],
        [6.5850, 79.9600],
        [6.4200, 80.0000],
        [6.2800, 80.0300],
        [6.1400, 80.1100],
        [6.0900, 80.1400],
        [6.0329, 80.2168],
      ],
    },
    {
      'number': 'Main Line',
      'route': 'Colombo Fort → Kandy',
      'from': 'Colombo Fort',
      'to': 'Kandy',
      'duration': '2.5–4 hr (example)',
      'fare': 'Check current railway fare',
      'boardingStand': 'Colombo Fort Railway Station',
      'departureTimes': [
        'Example: 6:00 AM',
        'Example: 7:00 AM',
        'Example: 8:00 AM',
      ],
      'stops': [
        'Colombo Fort',
        'Maradana',
        'Ragama',
        'Gampaha',
        'Veyangoda',
        'Polgahawela',
        'Rambukkana',
        'Peradeniya',
        'Kandy',
      ],
      'startLat': 6.9344,
      'startLng': 79.8428,
      'endLat': 7.2906,
      'endLng': 80.6337,
      'routePath': [
        [6.9344, 79.8428],
        [6.9310, 79.8610],
        [7.0300, 79.8900],
        [7.0840, 79.9580],
        [7.1500, 80.0500],
        [7.2500, 80.1200],
        [7.2900, 80.3500],
        [7.2500, 80.5000],
        [7.2906, 80.6337],
      ],
    },
    {
      'number': 'Puttalam Line',
      'route': 'Colombo Fort → Puttalam',
      'from': 'Colombo Fort',
      'to': 'Puttalam',
      'duration': '2.5–4 hr (example)',
      'fare': 'Check current railway fare',
      'boardingStand': 'Colombo Fort Railway Station',
      'departureTimes': [
        'Example: 6:00 AM',
        'Example: 7:00 AM',
        'Example: 8:00 AM',
      ],
      'stops': [
        'Colombo Fort',
        'Ragama',
        'Ja-Ela',
        'Seeduwa',
        'Negombo',
        'Chilaw',
        'Bangadeniya',
        'Puttalam',
      ],
      'startLat': 6.9344,
      'startLng': 79.8428,
      'endLat': 8.0362,
      'endLng': 79.8283,
      'routePath': [
        [6.9344, 79.8428],
        [6.9500, 79.8700],
        [7.0300, 79.8900],
        [7.1600, 79.8700],
        [7.2083, 79.8358],
        [7.4500, 79.9000],
        [7.6000, 79.8500],
        [7.8000, 79.8200],
        [8.0362, 79.8283],
      ],
    },
    {
      'number': 'Northern Line',
      'route': 'Colombo Fort → Jaffna',
      'from': 'Colombo Fort',
      'to': 'Jaffna',
      'duration': '5–7 hr or longer (example)',
      'fare': 'Check current railway fare',
      'boardingStand': 'Colombo Fort Railway Station',
      'departureTimes': [
        'Example: 5:00 AM',
        'Example: 6:00 AM',
        'Example: 8:00 AM',
      ],
      'stops': [
        'Colombo Fort',
        'Ragama',
        'Polgahawela',
        'Kurunegala',
        'Anuradhapura',
        'Vavuniya',
        'Kilinochchi',
        'Jaffna',
      ],
      'startLat': 6.9344,
      'startLng': 79.8428,
      'endLat': 9.6615,
      'endLng': 80.0255,
      'routePath': [
        [6.9344, 79.8428],
        [7.0300, 79.8900],
        [7.2800, 80.2000],
        [7.4800, 80.3500],
        [7.7500, 80.5000],
        [8.1200, 80.6000],
        [8.4500, 80.5000],
        [8.7500, 80.5000],
        [9.0500, 80.0000],
        [9.3500, 80.0000],
        [9.6615, 80.0255],
      ],
    },
  ];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _lineController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRoutes {
    final from = _fromQuery.trim().toLowerCase();
    final to = _toQuery.trim().toLowerCase();
    final query = _routeQuery.trim().toLowerCase();

    return _trainRoutes.where((route) {
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
          query.isEmpty ||
          routeName.contains(query) ||
          number.contains(query) ||
          routeFrom.contains(query) ||
          routeTo.contains(query) ||
          stops.any((stop) => stop.contains(query));

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
      _routeQuery = _lineController.text;
      _hasSearched = true;
    });

    FocusScope.of(context).unfocus();
  }

  void _clearSearch() {
    _fromController.clear();
    _toController.clear();
    _lineController.clear();

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
                transportType: 'Train Route',
                routeName: route['route'].toString(),
                from: route['from'].toString(),
                to: route['to'].toString(),
                icon: Icons.train_rounded,
                iconColor: _cyan,
                startLat: route['startLat'] as double,
                startLng: route['startLng'] as double,
                endLat: route['endLat'] as double,
                endLng: route['endLng'] as double,
                routePath: (route['routePath'] as List)
                    .map(
                      (point) => (point as List)
                          .map((value) => (value as num).toDouble())
                          .toList(),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
              child: Row(
                children: [
                  _HeaderButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Train Routes',
                          style: TextStyle(
                            color: _text,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Explore railway journeys',
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  _HeaderButton(
                    icon: Icons.language_rounded,
                    color: _purple,
                    onTap: () => showLanguageSelector(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF122C4A), Color(0xFF211D3D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _cyan.withValues(alpha: 0.30)),
                    ),
                    child: Stack(
                      children: [
                        const Positioned(
                          right: 0,
                          top: 0,
                          child: Icon(
                            Icons.train_rounded,
                            color: Color(0x558B5CF6),
                            size: 76,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _cyan.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.train_rounded,
                                    color: _cyan,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'LANKATRANSIT RAIL',
                                    style: TextStyle(
                                      color: _cyan,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Find your train',
                              style: TextStyle(
                                color: _text,
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Explore routes and plan your next journey across Sri Lanka.',
                              style: TextStyle(
                                color: _muted,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _SectionHeading(
                    title: 'Plan your journey',
                    subtitle: 'Enter your stations below',
                  ),
                  const SizedBox(height: 14),
                  _SearchField(
                    controller: _fromController,
                    label: 'From',
                    hint: 'Starting station',
                    icon: Icons.trip_origin_rounded,
                  ),
                  const SizedBox(height: 11),
                  _SearchField(
                    controller: _toController,
                    label: 'To',
                    hint: 'Destination station',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 11),
                  _SearchField(
                    controller: _lineController,
                    label: 'Train line or station (optional)',
                    hint: 'e.g. Coastal Line, Gampaha, Kandy',
                    icon: Icons.train_rounded,
                    onSubmitted: (_) => _searchRoutes(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _searchRoutes,
                          icon: const Icon(Icons.search_rounded),
                          label: const Text('Search trains'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _cyan,
                            foregroundColor: _background,
                            minimumSize: const Size.fromHeight(52),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: _surfaceLight,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: _border),
                        ),
                        child: IconButton(
                          tooltip: 'Clear search',
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.refresh_rounded, color: _cyan),
                          iconSize: 24,
                          style: IconButton.styleFrom(
                            minimumSize: const Size(52, 52),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFF302A1C),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF8A6500).withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFFFBBF24),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Sample data: train times, fares and some route details are not verified live information. Confirm with Sri Lanka Railways before travelling.',
                            style: TextStyle(
                              color: Color(0xFFF5D98B),
                              fontSize: 12,
                              height: 1.5,
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
                          _hasSearched
                              ? 'Search results'
                              : 'Popular train routes',
                          style: const TextStyle(
                            color: _text,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: _surfaceLight,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '${_filteredRoutes.length} routes',
                          style: const TextStyle(
                            color: _cyan,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_filteredRoutes.isEmpty)
                    const _EmptyRoutesWidget(
                      message: 'No matching train routes in this sample list. Try another station or line.',
                    )
                  else
                    ..._filteredRoutes.map(
                      (route) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _TrainRouteCard(
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

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _HeaderButton({
    required this.icon,
    required this.onTap,
    this.color = _cyan,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _text,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: _muted, fontSize: 13)),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: _text, fontSize: 14),
        cursorColor: _cyan,
        textInputAction: onSubmitted == null
            ? TextInputAction.next
            : TextInputAction.search,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          icon: Icon(icon, color: _cyan, size: 21),
          labelText: label,
          labelStyle: const TextStyle(color: _muted, fontSize: 13),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF687994), fontSize: 13),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _TrainRouteCard extends StatelessWidget {
  final Map<String, dynamic> route;
  final VoidCallback onTap;

  const _TrainRouteCard({required this.route, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final stops = (route['stops'] as List).join('  •  ');

    return Material(
      color: _surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF12304A), Color(0xFF211D3D)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.train_rounded,
                      color: _cyan,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route['number'].toString(),
                          style: const TextStyle(
                            color: _purple,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          route['route'].toString(),
                          style: const TextStyle(
                            color: _text,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Approx. ${route['duration']}',
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: _cyan,
                    size: 25,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(color: _border, height: 1),
              const SizedBox(height: 15),
              _InfoLine(
                icon: Icons.train_outlined,
                title: 'Starting station',
                value: route['boardingStand'].toString(),
              ),
              const SizedBox(height: 12),
              _InfoLine(
                icon: Icons.schedule_rounded,
                title: 'Example departures',
                value: (route['departureTimes'] as List).join(', '),
              ),
              const SizedBox(height: 12),
              _InfoLine(
                icon: Icons.payments_outlined,
                title: 'Fare',
                value: route['fare'].toString(),
              ),
              const SizedBox(height: 13),
              Text(
                'Stations: $stops',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'View train details',
                    style: TextStyle(
                      color: _cyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: _cyan,
                    size: 16,
                  ),
                ],
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
        Icon(icon, size: 17, color: _cyan),
        const SizedBox(width: 9),
        SizedBox(
          width: 105,
          child: Text(
            '$title:',
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: _text,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.4,
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
        color: _surface,
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
                  color: _muted.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _surfaceLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.train_rounded,
                    color: _cyan,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route['route'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${route['number']} • Train line',
                        style: const TextStyle(color: _muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _InfoLine(
              icon: Icons.location_on_outlined,
              title: 'Starting station',
              value: route['boardingStand'].toString(),
            ),
            const SizedBox(height: 15),
            _InfoLine(
              icon: Icons.timelapse_rounded,
              title: 'Journey time',
              value: route['duration'].toString(),
            ),
            const SizedBox(height: 15),
            _InfoLine(
              icon: Icons.payments_outlined,
              title: 'Fare',
              value: route['fare'].toString(),
            ),
            const SizedBox(height: 25),
            const Text(
              'Example departure times',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: _text,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: departures
                  .map(
                    (time) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: _surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 15,
                            color: _cyan,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            time,
                            style: const TextStyle(color: _text, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 25),
            const Text(
              'Stations along the route',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: _text,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(stops.length, (index) {
              final isEndpoint = index == 0 || index == stops.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    child: Column(
                      children: [
                        Icon(
                          isEndpoint ? Icons.location_on_rounded : Icons.circle,
                          size: isEndpoint ? 19 : 9,
                          color: index == stops.length - 1 ? _purple : _cyan,
                        ),
                        if (index != stops.length - 1)
                          Container(width: 2, height: 28, color: _border),
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
                          color: _text,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFF302A1C),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Text(
                'These are sample details for app development, not verified live railway timetable or fare information. Please confirm with Sri Lanka Railways before travelling.',
                style: TextStyle(
                  color: Color(0xFFF5D98B),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onShowMap,
              icon: const Icon(Icons.map_outlined),
              label: const Text('View train route on map'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _cyan,
                foregroundColor: _background,
                minimumSize: const Size.fromHeight(52),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: _surfaceLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.search_off_rounded, color: _cyan, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _text,
              height: 1.5,
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
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Container(
        decoration: const BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: _cyan,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Text(
                      l10n.language,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: _text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
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
      color: isSelected ? const Color(0xFF211D3D) : _surfaceLight,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          appLocale.value = locale;
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: _background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    locale.languageCode == 'en' ? '🇬🇧' : '🇱🇰',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: _muted),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded, color: _cyan),
            ],
          ),
        ),
      ),
    );
  }
}

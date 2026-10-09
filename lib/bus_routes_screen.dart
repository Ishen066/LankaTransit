import 'package:flutter/material.dart';
import 'app_locale.dart';
import 'l10n/app_localizations.dart';
import 'route_details_screen.dart';

class BusRoutesScreen extends StatefulWidget {
  const BusRoutesScreen({super.key});

  @override
  State<BusRoutesScreen> createState() => _BusRoutesScreenState();
}

class _BusRoutesScreenState extends State<BusRoutesScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  final List<Map<String, dynamic>> _busRoutes = [
    {
      'number': '138',
      'route': 'Colombo → Kaduwela',
      'description': 'Colombo to Kaduwela',
      'from': 'Colombo',
      'to': 'Kaduwela',
      'duration': '45 min',
      'stops': [
        'Colombo',
        'Borella',
        'Rajagiriya',
        'Battaramulla',
        'Kaduwela',
      ],

      // Colombo
      'startLat': 6.9271,
      'startLng': 79.8612,

      // Kaduwela
      'endLat': 6.9369,
      'endLng': 80.0028,
    },
    {
      'number': '100',
      'route': 'Panadura → Colombo',
      'description': 'Panadura to Colombo',
      'from': 'Panadura',
      'to': 'Colombo',
      'duration': '1 hr',
      'stops': [
        'Panadura',
        'Moratuwa',
        'Dehiwala',
        'Bambalapitiya',
        'Colombo',
      ],

      // Panadura
      'startLat': 6.7132,
      'startLng': 79.9074,

      // Colombo
      'endLat': 6.9271,
      'endLng': 79.8612,
    },
    {
      'number': '02',
      'route': 'Galle → Colombo',
      'description': 'Galle to Colombo',
      'from': 'Galle',
      'to': 'Colombo',
      'duration': '2 hr',
      'stops': [
        'Galle',
        'Hikkaduwa',
        'Ambalangoda',
        'Kalutara',
        'Colombo',
      ],

      // Galle
      'startLat': 6.0329,
      'startLng': 80.2168,

      // Colombo
      'endLat': 6.9271,
      'endLng': 79.8612,
    },
    {
      'number': '177',
      'route': 'Kaduwela → Kollupitiya',
      'description': 'Kaduwela to Kollupitiya',
      'from': 'Kaduwela',
      'to': 'Kollupitiya',
      'duration': '1 hr 15 min',
      'stops': [
        'Kaduwela',
        'Battaramulla',
        'Rajagiriya',
        'Borella',
        'Kollupitiya',
      ],

      // Kaduwela
      'startLat': 6.9369,
      'startLng': 80.0028,

      // Kollupitiya
      'endLat': 6.9115,
      'endLng': 79.8518,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRoutes {
    if (_searchQuery.trim().isEmpty) {
      return _busRoutes;
    }

    final query = _searchQuery.toLowerCase();

    return _busRoutes.where((route) {
      return route['number']
              .toString()
              .toLowerCase()
              .contains(query) ||
          route['route']
              .toString()
              .toLowerCase()
              .contains(query) ||
          route['description']
              .toString()
              .toLowerCase()
              .contains(query) ||
          route['from']
              .toString()
              .toLowerCase()
              .contains(query) ||
          route['to']
              .toString()
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  void _openRouteDetails(Map<String, dynamic> route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteDetailsScreen(
          transportType: 'Bus Route',
          routeName: route['route'].toString(),
          from: route['from'].toString(),
          to: route['to'].toString(),
          icon: Icons.directions_bus_rounded,
          iconColor: const Color(0xFF087F5B),
          startLat: route['startLat'] as double,
          startLng: route['startLng'] as double,
          endLat: route['endLat'] as double,
          endLng: route['endLng'] as double,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  const SizedBox(width: 18),

                  Text(
                    l10n.busRoutes,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173B32),
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      showLanguageSelector(context);
                    },
                    icon: const Icon(
                      Icons.language_rounded,
                      color: Color(0xFF087F5B),
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // CONTENT
            // =====================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  30,
                  20,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.findBusRoute,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF173B32),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _busSubtitle(l10n),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // =================================================
                    // SEARCH
                    // =================================================

                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF087F5B),
                            size: 29,
                          ),
                          hintText: _searchHint(l10n),
                          hintStyle:
                              const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 22,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // =================================================
                    // SECTION TITLE
                    // =================================================

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.popularBusRoutes,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF173B32),
                            ),
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFE8F5EF),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_filteredRoutes.length} ${_routesText(l10n)}',
                            style: const TextStyle(
                              color: Color(0xFF087F5B),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // =================================================
                    // ROUTES
                    // =================================================

                    if (_filteredRoutes.isEmpty)
                      _EmptyRoutesWidget(
                        message: _noRoutesFound(l10n),
                      )
                    else
                      ..._filteredRoutes.map(
                        (route) => Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 14,
                          ),
                          child: _BusRouteCard(
                            route: route,
                            viewRouteText:
                                l10n.viewRoute,
                            busRouteLabel:
                                _busRouteLabel(l10n),
                            onTap: () {
                              _openRouteDetails(route);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _busSubtitle(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'si':
        return 'බස් මාර්ග සොයාගෙන ඔබේ ගමනාන්තයට පහසුවෙන් යන්න.';
      case 'ta':
        return 'பேருந்து பாதைகளைக் கண்டறிந்து உங்கள் இலக்கை எளிதாக அடையுங்கள்.';
      default:
        return 'Explore bus routes and find your destination easily.';
    }
  }

  String _searchHint(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'si':
        return 'බස් අංකය හෝ ගමනාන්තය සොයන්න';
      case 'ta':
        return 'பேருந்து எண் அல்லது இலக்கைத் தேடுங்கள்';
      default:
        return 'Search bus number or destination';
    }
  }

  String _noRoutesFound(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'si':
        return 'බස් මාර්ග හමු නොවීය';
      case 'ta':
        return 'பேருந்து பாதைகள் எதுவும் கிடைக்கவில்லை';
      default:
        return 'No bus routes found';
    }
  }

  String _routesText(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'si':
        return 'මාර්ග';
      case 'ta':
        return 'பாதைகள்';
      default:
        return 'Routes';
    }
  }

  String _busRouteLabel(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'si':
        return 'බස් මාර්ගය';
      case 'ta':
        return 'பேருந்து பாதை';
      default:
        return 'BUS ROUTE';
    }
  }
}

// ================================================================
// BUS ROUTE CARD
// ================================================================

class _BusRouteCard extends StatelessWidget {
  final Map<String, dynamic> route;
  final String viewRouteText;
  final String busRouteLabel;
  final VoidCallback onTap;

  const _BusRouteCard({
    required this.route,
    required this.viewRouteText,
    required this.busRouteLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.035),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // ==================================================
                  // BUS NUMBER
                  // ==================================================

                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFE8F5EF),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons
                              .directions_bus_rounded,
                          color:
                              Color(0xFF087F5B),
                          size: 25,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          route['number'].toString(),
                          style:
                              const TextStyle(
                            color:
                                Color(0xFF087F5B),
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 18),

                  // ==================================================
                  // ROUTE INFORMATION
                  // ==================================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          busRouteLabel,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          route['route'].toString(),
                          style:
                              const TextStyle(
                            color:
                                Color(0xFF173B32),
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // ARROW
                  // ==================================================

                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFF0F5F3),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color:
                          Color(0xFF087F5B),
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Divider(
                color: Color(0xFFE8EDEA),
                height: 1,
              ),

              const SizedBox(height: 13),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                    size: 19,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      route['description'].toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.map_outlined,
                    color: Color(0xFF087F5B),
                    size: 19,
                  ),

                  const SizedBox(width: 7),

                  Text(
                    viewRouteText,
                    style: const TextStyle(
                      color: Color(0xFF087F5B),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
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

// ================================================================
// EMPTY ROUTES
// ================================================================

class _EmptyRoutesWidget extends StatelessWidget {
  final String message;

  const _EmptyRoutesWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EF),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: Color(0xFF087F5B),
              size: 32,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF173B32),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// LANGUAGE SELECTOR
// ================================================================

void showLanguageSelector(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(28),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            22,
            24,
            28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFE8F5EF),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.language_rounded,
                      color:
                          Color(0xFF087F5B),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Text(
                    l10n.language,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173B32),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              _LanguageOption(
                title: l10n.english,
                subtitle: 'English',
                locale: const Locale('en'),
                onTap: () {
                  appLocale.value =
                      const Locale('en');
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),

              _LanguageOption(
                title: l10n.sinhala,
                subtitle: 'සිංහල',
                locale: const Locale('si'),
                onTap: () {
                  appLocale.value =
                      const Locale('si');
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),

              _LanguageOption(
                title: l10n.tamil,
                subtitle: 'தமிழ்',
                locale: const Locale('ta'),
                onTap: () {
                  appLocale.value =
                      const Locale('ta');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ================================================================
// LANGUAGE OPTION
// ================================================================

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final Locale locale;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected =
        appLocale.value.languageCode ==
            locale.languageCode;

    return Material(
      color: isSelected
          ? const Color(0xFFE8F5EF)
          : const Color(0xFFF7F9F8),
      borderRadius:
          BorderRadius.circular(17),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(17),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    locale.languageCode == 'en'
                        ? '🇬🇧'
                        : '🇱🇰',
                    style:
                        const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF173B32),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color:
                      Color(0xFF087F5B),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
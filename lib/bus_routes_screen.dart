import 'package:flutter/material.dart';

import 'app_locale.dart';
import 'app_theme.dart';
import 'l10n/app_localizations.dart';
import 'route_details_screen.dart';

/// Bus route finder for LankaTransit.
/// Route times and fares below are illustrative, not verified live data.
class BusRoutesScreen extends StatefulWidget {
  const BusRoutesScreen({super.key});

  @override
  State<BusRoutesScreen> createState() => _BusRoutesScreenState();
}

class _BusRoutesScreenState extends State<BusRoutesScreen> {
  static const Color _cyan = Color(0xFF38BDF8);

  Color _background(BuildContext context) => AppTheme.pageBackground(context);
  Color _surface(BuildContext context) => AppTheme.cardBackground(context);
  Color _text(BuildContext context) => AppTheme.mainText(context);
  Color _muted(BuildContext context) => AppTheme.secondaryText(context);
  Color _border(BuildContext context) => AppTheme.borderColor(context);
  Color _surfaceLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF15223B)
          : const Color(0xFFEAF0F8);

  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _routeController = TextEditingController();
  String _fromQuery = '';
  String _toQuery = '';
  String _routeQuery = '';
  bool _hasSearched = false;

  // Starter examples only. Verify all details with official operators.
  final List<Map<String, dynamic>> _busRoutes = [
    {'number':'138','route':'Colombo → Kaduwela','from':'Colombo','to':'Kaduwela','duration':'45–70 min','fare':'Check current fare','boardingStand':'Pettah / Colombo bus terminal','departureTimes':['6:00 AM','6:30 AM','7:00 AM','7:30 AM'],'stops':['Colombo','Borella','Rajagiriya','Battaramulla','Kaduwela'],'startLat':6.9271,'startLng':79.8612,'endLat':6.9369,'endLng':80.0028},
    {'number':'100','route':'Panadura → Colombo','from':'Panadura','to':'Colombo','duration':'60–90 min','fare':'Check current fare','boardingStand':'Panadura bus stand','departureTimes':['6:00 AM','6:20 AM','6:40 AM','7:00 AM'],'stops':['Panadura','Moratuwa','Mount Lavinia','Dehiwala','Colombo'],'startLat':6.7132,'startLng':79.9074,'endLat':6.9271,'endLng':79.8612},
    {'number':'02','route':'Galle → Colombo','from':'Galle','to':'Colombo','duration':'2–3 hr','fare':'Check current fare','boardingStand':'Galle Central Bus Stand','departureTimes':['5:30 AM','6:00 AM','6:30 AM','7:00 AM'],'stops':['Galle','Hikkaduwa','Ambalangoda','Kalutara','Colombo'],'startLat':6.0329,'startLng':80.2168,'endLat':6.9271,'endLng':79.8612},
    {'number':'177','route':'Kaduwela → Kollupitiya','from':'Kaduwela','to':'Kollupitiya','duration':'60–90 min','fare':'Check current fare','boardingStand':'Kaduwela bus stand','departureTimes':['6:00 AM','6:30 AM','7:00 AM'],'stops':['Kaduwela','Battaramulla','Rajagiriya','Borella','Kollupitiya'],'startLat':6.9369,'startLng':80.0028,'endLat':6.9115,'endLng':79.8518},
    {'number':'Negombo–Colombo','route':'Negombo → Colombo','from':'Negombo','to':'Colombo','duration':'60–100 min','fare':'Check current fare','boardingStand':'Negombo bus stand','departureTimes':['6:00 AM','6:30 AM','7:00 AM'],'stops':['Negombo','Ja-Ela','Wattala','Colombo'],'startLat':7.2083,'startLng':79.8358,'endLat':6.9271,'endLng':79.8612},
    {'number':'Kandy–Colombo','route':'Kandy → Colombo','from':'Kandy','to':'Colombo','duration':'3–4 hr','fare':'Check current fare','boardingStand':'Kandy Goods Shed Bus Stand','departureTimes':['5:30 AM','6:00 AM','6:30 AM'],'stops':['Kandy','Kadugannawa','Mawanella','Kegalle','Colombo'],'startLat':7.2906,'startLng':80.6337,'endLat':6.9271,'endLng':79.8612},
    {'number':'Galle–Matara','route':'Galle → Matara','from':'Galle','to':'Matara','duration':'60–90 min','fare':'Check current fare','boardingStand':'Galle Central Bus Stand','departureTimes':['6:00 AM','6:30 AM','7:00 AM'],'stops':['Galle','Unawatuna junction','Ahangama','Weligama','Matara'],'startLat':6.0329,'startLng':80.2168,'endLat':5.9549,'endLng':80.5550},
    {'number':'Jaffna–Vavuniya','route':'Jaffna → Vavuniya','from':'Jaffna','to':'Vavuniya','duration':'2–3 hr','fare':'Check current fare','boardingStand':'Jaffna Central Bus Stand','departureTimes':['6:00 AM','7:00 AM','8:00 AM'],'stops':['Jaffna','Kilinochchi','Mullaitivu junction','Vavuniya'],'startLat':9.6615,'startLng':80.0255,'endLat':8.7514,'endLng':80.4971},
    {'number':'Anuradhapura–Dambulla','route':'Anuradhapura → Dambulla','from':'Anuradhapura','to':'Dambulla','duration':'1–2 hr','fare':'Check current fare','boardingStand':'Anuradhapura bus stand','departureTimes':['6:00 AM','7:00 AM','8:00 AM'],'stops':['Anuradhapura','Kekirawa','Dambulla'],'startLat':8.3114,'startLng':80.4037,'endLat':7.8600,'endLng':80.6517},
    {'number':'Kurunegala–Kandy','route':'Kurunegala → Kandy','from':'Kurunegala','to':'Kandy','duration':'1.5–2.5 hr','fare':'Check current fare','boardingStand':'Kurunegala bus stand','departureTimes':['6:00 AM','6:30 AM','7:00 AM'],'stops':['Kurunegala','Mawathagama','Galagedara','Kandy'],'startLat':7.4863,'startLng':80.3623,'endLat':7.2906,'endLng':80.6337},
    {'number':'Matara–Hambantota','route':'Matara → Hambantota','from':'Matara','to':'Hambantota','duration':'1.5–2.5 hr','fare':'Check current fare','boardingStand':'Matara bus stand','departureTimes':['6:00 AM','7:00 AM','8:00 AM'],'stops':['Matara','Dikwella','Tangalle','Beliatta','Hambantota'],'startLat':5.9549,'startLng':80.5550,'endLat':6.1241,'endLng':81.1185},
    {'number':'Badulla–Ella','route':'Badulla → Ella','from':'Badulla','to':'Ella','duration':'45–75 min','fare':'Check current fare','boardingStand':'Badulla bus stand','departureTimes':['6:00 AM','7:00 AM','8:00 AM'],'stops':['Badulla','Hali-Ela','Demodara','Ella'],'startLat':6.9934,'startLng':81.0550,'endLat':6.8667,'endLng':81.0466},
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
    final query = _routeQuery.trim().toLowerCase();
    return _busRoutes.where((route) {
      final routeFrom = route['from'].toString().toLowerCase();
      final routeTo = route['to'].toString().toLowerCase();
      final routeName = route['route'].toString().toLowerCase();
      final number = route['number'].toString().toLowerCase();
      final stops = (route['stops'] as List).map((s) => s.toString().toLowerCase()).toList();
      final fromMatches = from.isEmpty || routeFrom.contains(from) || stops.any((s) => s.contains(from));
      final toMatches = to.isEmpty || routeTo.contains(to) || stops.any((s) => s.contains(to));
      final queryMatches = query.isEmpty || routeName.contains(query) || number.contains(query) || routeFrom.contains(query) || routeTo.contains(query) || stops.any((s) => s.contains(query));
      final fromIndex = from.isEmpty ? 0 : stops.indexWhere((s) => s.contains(from));
      final toIndex = to.isEmpty ? stops.length - 1 : stops.indexWhere((s) => s.contains(to));
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
        surface: _surface(context),
        surfaceLight: _surfaceLight(context),
        textColor: _text(context),
        mutedColor: _muted(context),
        borderColor: _border(context),
        onShowMap: () {
          Navigator.pop(sheetContext);
          Navigator.push(context, MaterialPageRoute(builder: (_) => RouteDetailsScreen(
            transportType: 'Bus Route', routeName: route['route'].toString(),
            from: route['from'].toString(), to: route['to'].toString(),
            icon: Icons.directions_bus_rounded, iconColor: _cyan,
            startLat: route['startLat'] as double, startLng: route['startLng'] as double,
            endLat: route['endLat'] as double, endLng: route['endLng'] as double,
          )));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: _background(context),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(children: [
              _HeaderButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.pop(context), borderColor: _border(context), surface: _surface(context), textColor: _text(context)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.busRoutes, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: _text(context))),
                const SizedBox(height: 2),
                Text('Explore bus connections', style: TextStyle(fontSize: 12, color: _muted(context))),
              ])),
              _HeaderButton(icon: Icons.language_rounded, onTap: () => showLanguageSelector(context), borderColor: _border(context), surface: _surface(context), textColor: _cyan),
            ]),
          ),
          Expanded(child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF122C4A), Color(0xFF211D3D)]),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: _cyan.withValues(alpha: 0.24)),
                ),
                child: Stack(children: [
                  Positioned(right: -8, top: 0, child: Icon(Icons.directions_bus_filled_rounded, size: 108, color: Colors.white.withValues(alpha: 0.06))),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: _cyan.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(30)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.route_rounded, size: 15, color: _cyan), SizedBox(width: 6), Text('SMART BUS SEARCH', style: TextStyle(color: _cyan, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.1))])),
                    const SizedBox(height: 17),
                    const Text('Find your bus', style: TextStyle(fontSize: 29, height: 1.1, fontWeight: FontWeight.w900, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('Search by starting point, destination, or bus number.', style: TextStyle(color: Colors.white.withValues(alpha: 0.72), fontSize: 13, height: 1.45)),
                  ]),
                ]),
              ),
              const SizedBox(height: 22),
              _SearchField(controller: _fromController, label: 'From', hint: 'Where are you starting?', icon: Icons.trip_origin_rounded, surface: _surface(context), border: _border(context), text: _text(context), muted: _muted(context)),
              const SizedBox(height: 12),
              _SearchField(controller: _toController, label: 'To', hint: 'Where do you want to go?', icon: Icons.location_on_outlined, surface: _surface(context), border: _border(context), text: _text(context), muted: _muted(context)),
              const SizedBox(height: 12),
              _SearchField(controller: _routeController, label: 'Bus number or stop (optional)', hint: 'e.g. 138, Borella, Kandy', icon: Icons.directions_bus_rounded, surface: _surface(context), border: _border(context), text: _text(context), muted: _muted(context), onSubmitted: (_) => _searchRoutes()),
              const SizedBox(height: 15),
              Row(children: [
                Expanded(child: SizedBox(height: 52, child: ElevatedButton.icon(onPressed: _searchRoutes, icon: const Icon(Icons.search_rounded), label: const Text('Search buses', style: TextStyle(fontWeight: FontWeight.w800)), style: ElevatedButton.styleFrom(backgroundColor: _cyan, foregroundColor: const Color(0xFF07111F), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))))),
                const SizedBox(width: 10),
                SizedBox(height: 52, width: 52, child: OutlinedButton(onPressed: _clearSearch, style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: _text(context), side: BorderSide(color: _border(context)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Icon(Icons.refresh_rounded))),
              ]),
              const SizedBox(height: 17),
              Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: isDark ? const Color(0xFF302A1C) : const Color(0xFFFFF5D9), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.22))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B), size: 20), const SizedBox(width: 9), Expanded(child: Text('Preview data: times and fares are not verified live information. Confirm with the bus operator before travelling.', style: TextStyle(color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF805B00), fontSize: 12, height: 1.4)))])),
              const SizedBox(height: 27),
              Row(children: [
                Expanded(child: Text(_hasSearched ? 'Search results' : 'Popular example routes', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: _text(context)))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: _cyan.withValues(alpha: isDark ? 0.13 : 0.11), borderRadius: BorderRadius.circular(30)), child: Text('${_filteredRoutes.length} routes', style: const TextStyle(color: _cyan, fontSize: 12, fontWeight: FontWeight.w800))),
              ]),
              const SizedBox(height: 14),
              if (_filteredRoutes.isEmpty) ...[
                _EmptyRoutesWidget(
                  message: 'No matching routes in this sample list. Try another location.',
                  surface: _surface(context),
                  surfaceLight: _surfaceLight(context),
                  text: _text(context),
                  muted: _muted(context),
                ),
              ] else ...[
                for (final route in _filteredRoutes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _BusRouteCard(
                      route: route,
                      onTap: () => _openRouteDetails(route),
                      surface: _surface(context),
                      surfaceLight: _surfaceLight(context),
                      border: _border(context),
                      text: _text(context),
                      muted: _muted(context),
                    ),
                  ),
              ],
            ],
          )),
        ]),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color borderColor, surface, textColor;
  const _HeaderButton({required this.icon, required this.onTap, required this.borderColor, required this.surface, required this.textColor});
  @override
  Widget build(BuildContext context) => Material(color: surface, borderRadius: BorderRadius.circular(14), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: Container(width: 44, height: 44, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)), child: Icon(icon, color: textColor, size: 22))));
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final ValueChanged<String>? onSubmitted;
  final Color surface, border, text, muted;
  const _SearchField({required this.controller, required this.label, required this.hint, required this.icon, required this.surface, required this.border, required this.text, required this.muted, this.onSubmitted});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3), decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(17), border: Border.all(color: border)), child: TextField(controller: controller, onSubmitted: onSubmitted, textInputAction: onSubmitted == null ? TextInputAction.next : TextInputAction.search, style: TextStyle(color: text, fontSize: 14), cursorColor: const Color(0xFF38BDF8), decoration: InputDecoration(icon: Icon(icon, color: const Color(0xFF38BDF8), size: 21), labelText: label, labelStyle: TextStyle(color: muted, fontSize: 12), hintText: hint, hintStyle: TextStyle(color: muted.withValues(alpha: 0.8), fontSize: 13), border: InputBorder.none)));
}

class _BusRouteCard extends StatelessWidget {
  final Map<String, dynamic> route;
  final VoidCallback onTap;
  final Color surface, surfaceLight, border, text, muted;
  const _BusRouteCard({required this.route, required this.onTap, required this.surface, required this.surfaceLight, required this.border, required this.text, required this.muted});
  @override
  Widget build(BuildContext context) {
    final stops = (route['stops'] as List).join('  •  ');
    return Material(color: surface, borderRadius: BorderRadius.circular(22), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), border: Border.all(color: border)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 62, height: 62, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF123A57), Color(0xFF25224B)]), borderRadius: BorderRadius.circular(17)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.directions_bus_rounded, color: Color(0xFF38BDF8), size: 23), const SizedBox(height: 3), Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: Text(route['number'].toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF7DD3FC), fontWeight: FontWeight.w800, fontSize: 10)))])),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(route['route'].toString(), style: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w800)), const SizedBox(height: 7), Row(children: [Icon(Icons.schedule_rounded, size: 15, color: muted), const SizedBox(width: 5), Expanded(child: Text('Approx. ${route['duration']}', style: TextStyle(color: muted, fontSize: 12)))]), const SizedBox(height: 8), Row(children: [const Icon(Icons.payments_outlined, size: 15, color: Color(0xFF8B5CF6)), const SizedBox(width: 5), Expanded(child: Text(route['fare'].toString(), style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)))] )])),
        const Icon(Icons.chevron_right_rounded, color: Color(0xFF38BDF8)),
      ]),
      const SizedBox(height: 16),
      Divider(color: border, height: 1),
      const SizedBox(height: 13),
      _InfoLine(icon: Icons.directions_bus_filled_outlined, title: 'Boarding stand', value: route['boardingStand'].toString(), text: text, muted: muted),
      const SizedBox(height: 9),
      _InfoLine(icon: Icons.schedule_rounded, title: 'Example departures', value: (route['departureTimes'] as List).join(', '), text: text, muted: muted),
      const SizedBox(height: 12),
      Text('Stops: $stops', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: muted, fontSize: 11, height: 1.5)),
      const SizedBox(height: 13),
      Align(alignment: Alignment.centerRight, child: Row(mainAxisSize: MainAxisSize.min, children: [const Text('View details', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w800, fontSize: 12)), const SizedBox(width: 5), const Icon(Icons.arrow_forward_rounded, color: Color(0xFF38BDF8), size: 15)])),
    ]))));
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String title, value;
  final Color text, muted;
  const _InfoLine({required this.icon, required this.title, required this.value, required this.text, required this.muted});
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 17, color: const Color(0xFF38BDF8)), const SizedBox(width: 8), SizedBox(width: 108, child: Text('$title:', style: TextStyle(color: muted, fontSize: 11))), Expanded(child: Text(value, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.w600, height: 1.35)))]);
}

class _RouteInformationSheet extends StatelessWidget {
  final Map<String, dynamic> route;
  final VoidCallback onShowMap;
  final Color surface, surfaceLight, textColor, mutedColor, borderColor;
  const _RouteInformationSheet({required this.route, required this.onShowMap, required this.surface, required this.surfaceLight, required this.textColor, required this.mutedColor, required this.borderColor});
  @override
  Widget build(BuildContext context) {
    final stops = (route['stops'] as List).cast<String>();
    final departures = (route['departureTimes'] as List).cast<String>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .86), decoration: BoxDecoration(color: surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))), child: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(22, 12, 22, 24), children: [
      Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(10)))),
      const SizedBox(height: 22),
      Text(route['route'].toString(), style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: textColor)),
      const SizedBox(height: 6),
      Text('Bus route ${route['number']}', style: TextStyle(color: mutedColor)),
      const SizedBox(height: 22),
      _InfoLine(icon: Icons.location_on_outlined, title: 'Boarding stand', value: route['boardingStand'].toString(), text: textColor, muted: mutedColor),
      const SizedBox(height: 14),
      _InfoLine(icon: Icons.timelapse_rounded, title: 'Journey time', value: route['duration'].toString(), text: textColor, muted: mutedColor),
      const SizedBox(height: 14),
      _InfoLine(icon: Icons.payments_outlined, title: 'Fare', value: route['fare'].toString(), text: textColor, muted: mutedColor),
      const SizedBox(height: 24),
      Text('Example departure times', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textColor)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: departures.map((time) => Chip(avatar: const Icon(Icons.schedule_rounded, size: 16, color: Color(0xFF38BDF8)), label: Text(time, style: TextStyle(color: textColor, fontSize: 12)), backgroundColor: surfaceLight, side: BorderSide.none)).toList()),
      const SizedBox(height: 22),
      Text('Stops along the route', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textColor)),
      const SizedBox(height: 12),
      ...List.generate(stops.length, (index) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 28, child: Column(children: [Icon(index == 0 || index == stops.length - 1 ? Icons.location_on_rounded : Icons.circle, size: index == 0 || index == stops.length - 1 ? 19 : 9, color: const Color(0xFF38BDF8)), if (index != stops.length - 1) Container(width: 2, height: 28, color: borderColor)])), const SizedBox(width: 8), Expanded(child: Padding(padding: const EdgeInsets.only(top: 1, bottom: 20), child: Text(stops[index], style: TextStyle(color: textColor, fontWeight: FontWeight.w600))))])),
      const SizedBox(height: 6),
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isDark ? const Color(0xFF302A1C) : const Color(0xFFFFF5D9), borderRadius: BorderRadius.circular(12)), child: Text('These are example details for app development, not verified live timetable or fare information. Please confirm before travelling.', style: TextStyle(color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF805B00), fontSize: 12, height: 1.4))),
      const SizedBox(height: 18),
      SizedBox(height: 52, child: ElevatedButton.icon(onPressed: onShowMap, icon: const Icon(Icons.map_outlined), label: const Text('View route on map', style: TextStyle(fontWeight: FontWeight.w800)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: const Color(0xFF07111F), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))),
    ])));
  }
}

class _EmptyRoutesWidget extends StatelessWidget {
  final String message;
  final Color surface, surfaceLight, text, muted;
  const _EmptyRoutesWidget({required this.message, required this.surface, required this.surfaceLight, required this.text, required this.muted});
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(22), border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF263653) : const Color(0xFFD9E2EF)),), child: Column(children: [Container(width: 64, height: 64, decoration: BoxDecoration(color: surfaceLight, borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.search_off_rounded, color: Color(0xFF38BDF8), size: 32)), const SizedBox(height: 15), Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)), const SizedBox(height: 5), Text('Try a different city or bus stop.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: muted))]));
}

/// Language selector shared with the other screens.
void showLanguageSelector(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final surface = AppTheme.cardBackground(context);
  final text = AppTheme.mainText(context);
  final muted = AppTheme.secondaryText(context);
  final border = AppTheme.borderColor(context);
  showModalBottomSheet<void>(context: context, backgroundColor: surface, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (sheetContext) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24, 22, 24, 28), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [const Icon(Icons.language_rounded, color: Color(0xFF38BDF8), size: 28), const SizedBox(width: 12), Text(l10n.language, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: text))]),
    const SizedBox(height: 20),
    _LanguageOption(title: l10n.english, subtitle: 'English', locale: const Locale('en'), surface: surface, selectedSurface: isDark ? const Color(0xFF15223B) : const Color(0xFFEAF0F8), text: text, muted: muted, border: border),
    const SizedBox(height: 10),
    _LanguageOption(title: l10n.sinhala, subtitle: 'සිංහල', locale: const Locale('si'), surface: surface, selectedSurface: isDark ? const Color(0xFF15223B) : const Color(0xFFEAF0F8), text: text, muted: muted, border: border),
    const SizedBox(height: 10),
    _LanguageOption(title: l10n.tamil, subtitle: 'தமிழ்', locale: const Locale('ta'), surface: surface, selectedSurface: isDark ? const Color(0xFF15223B) : const Color(0xFFEAF0F8), text: text, muted: muted, border: border),
  ]))));
}

class _LanguageOption extends StatelessWidget {
  final String title, subtitle;
  final Locale locale;
  final Color surface, selectedSurface, text, muted, border;
  const _LanguageOption({required this.title, required this.subtitle, required this.locale, required this.surface, required this.selectedSurface, required this.text, required this.muted, required this.border});
  @override
  Widget build(BuildContext context) {
    final selected = appLocale.value.languageCode == locale.languageCode;
    return Material(color: selected ? selectedSurface : surface, borderRadius: BorderRadius.circular(17), child: InkWell(borderRadius: BorderRadius.circular(17), onTap: () { appLocale.value = locale; Navigator.pop(context); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), border: Border.all(color: selected ? const Color(0xFF38BDF8).withValues(alpha: .45) : border)), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: selectedSurface, borderRadius: BorderRadius.circular(13)), child: Center(child: Text(locale.languageCode == 'en' ? '🇬🇧' : '🇱🇰', style: const TextStyle(fontSize: 22)))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: text)), const SizedBox(height: 3), Text(subtitle, style: TextStyle(fontSize: 12, color: muted))])), if (selected) const Icon(Icons.check_circle_rounded, color: Color(0xFF38BDF8))]))));
  }
}

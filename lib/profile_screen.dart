
import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'app_locale.dart';
import 'favourite_routes_screen.dart';
import 'notification_screen.dart';
import 'recent_journeys_screen.dart';
import 'l10n/app_localizations.dart';

const Color _bg = Color(0xFF070B18);
const Color _panel = Color(0xFF111A2E);
const Color _panelLight = Color(0xFF15223B);
const Color _cyan = Color(0xFF38BDF8);
const Color _purple = Color(0xFF8B5CF6);
const Color _text = Color(0xFFF3F6FF);
const Color _muted = Color(0xFF9AA8C0);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'LankaTransit User';
  String _email = 'user@example.com';

  Future<void> _editProfile() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _panel,
        title: Text(
          l10n.editProfile,
          style: const TextStyle(color: _text),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(color: _text),
              decoration: _inputDecoration(
                l10n.fullName,
                Icons.person_outline,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: _text),
              decoration: _inputDecoration(
                l10n.emailAddress,
                Icons.email_outlined,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: _muted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _cyan,
              foregroundColor: _bg,
            ),
            onPressed: () {
              Navigator.pop(dialogContext, {
                'name': nameController.text.trim(),
                'email': emailController.text.trim(),
              });
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    nameController.dispose();
    emailController.dispose();

    if (!mounted || result == null) return;

    if (result['name']!.isEmpty || result['email']!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseEnterNameEmail),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _name = result['name']!;
      _email = result['email']!;
    });
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _muted),
      prefixIcon: Icon(icon, color: _cyan),
      filled: true,
      fillColor: _bg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF28344D)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF28344D)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _cyan),
      ),
    );
  }

  void _showLanguageSelector() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.chooseLanguage,
                style: const TextStyle(
                  color: _text,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              _LanguageOption(
                title: l10n.english,
                subtitle: 'English',
                locale: const Locale('en'),
              ),
              const SizedBox(height: 9),
              const _LanguageOption(
                title: 'සිංහල',
                subtitle: 'Sinhala',
                locale: Locale('si'),
              ),
              const SizedBox(height: 9),
              const _LanguageOption(
                title: 'தமிழ்',
                subtitle: 'Tamil',
                locale: Locale('ta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout() {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _panel,
        icon: const Icon(
          Icons.logout_rounded,
          color: Color(0xFFFB7185),
        ),
        title: Text(
          l10n.logoutTitle,
          style: const TextStyle(color: _text),
        ),
        content: Text(
          l10n.logoutMessage,
          style: const TextStyle(color: _muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: _muted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB7185),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      ),
    );
  }

  void _openRecentJourneys() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RecentJourneysScreen(),
      ),
    );
  }

  void _openFavouriteRoutes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavouriteRoutesScreen(),
      ),
    );
  }

  void _openAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final currentLanguage = switch (appLocale.value.languageCode) {
      'si' => l10n.sinhala,
      'ta' => l10n.tamil,
      _ => l10n.english,
    };

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: _text,
        title: Text(
          l10n.myProfile,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: l10n.language,
            onPressed: _showLanguageSelector,
            icon: const Icon(
              Icons.language_rounded,
              color: _cyan,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_panelLight, Color(0xFF211D3D)],
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: _cyan.withValues(alpha: 0.18),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 94,
                    height: 94,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [_cyan, _purple],
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: _bg,
                      size: 55,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: _editProfile,
                    icon: const Icon(Icons.edit_rounded, size: 17),
                    label: Text(l10n.editProfile),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _cyan,
                      side: const BorderSide(color: _cyan),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 27),

            _SectionTitle(title: l10n.yourTravel),
            const SizedBox(height: 11),
            _ProfileTile(
              icon: Icons.favorite_rounded,
              iconColor: const Color(0xFFFB7185),
              title: l10n.favouriteRoutes,
              subtitle: l10n.savedBusTrainRoutes,
              onTap: _openFavouriteRoutes,
            ),
            const SizedBox(height: 10),
            _ProfileTile(
              icon: Icons.history_rounded,
              iconColor: const Color(0xFFFBBF24),
              title: l10n.recentJourneys,
              subtitle: l10n.reviewRecentTrips,
              onTap: _openRecentJourneys,
            ),

            const SizedBox(height: 26),
            _SectionTitle(title: l10n.preferences),
            const SizedBox(height: 11),
            _ProfileTile(
              icon: Icons.language_rounded,
              iconColor: _cyan,
              title: l10n.language,
              subtitle: currentLanguage,
              onTap: _showLanguageSelector,
            ),
            const SizedBox(height: 10),
            _ProfileTile(
              icon: Icons.notifications_active_outlined,
              iconColor: _purple,
              title: l10n.notifications,
              subtitle: l10n.viewTravelUpdates,
              onTap: _openNotifications,
            ),

            const SizedBox(height: 26),
            _SectionTitle(title: l10n.aboutSection),
            const SizedBox(height: 11),
            _ProfileTile(
              icon: Icons.info_outline_rounded,
              iconColor: _cyan,
              title: l10n.aboutLankaTransit,
              subtitle: l10n.learnMoreAboutApp,
              onTap: _openAbout,
            ),

            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: OutlinedButton.icon(
                onPressed: _confirmLogout,
                icon: const Icon(Icons.logout_rounded),
                label: Text(
                  l10n.logout,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFB7185),
                  side: BorderSide(
                    color: const Color(0xFFFB7185)
                        .withValues(alpha: 0.55),
                  ),
                  backgroundColor: const Color(0xFF321A2A)
                      .withValues(alpha: 0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Center(
              child: Text(
                '${l10n.appName} • ${l10n.travelSmarterFooter}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
    final selected =
        appLocale.value.languageCode == locale.languageCode;

    return Material(
      color: selected ? _panelLight : _bg,
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        leading: Icon(
          selected
              ? Icons.check_circle_rounded
              : Icons.circle_outlined,
          color: selected ? _cyan : _muted,
        ),
        title: Text(
          title,
          style: const TextStyle(color: _text),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: _muted),
        ),
        onTap: () {
          appLocale.value = locale;
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _muted,
        fontSize: 12,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _panel,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 23,
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
                        color: _text,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: _muted,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

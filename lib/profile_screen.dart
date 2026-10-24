
import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'app_locale.dart';
import 'favourite_routes_screen.dart';
import 'notification_screen.dart';
import 'recent_journeys_screen.dart';
import 'l10n/app_localizations.dart';
import 'auth_service.dart';
import 'main.dart' show LoginScreen;

const Color _cyan = Color(0xFF38BDF8);
const Color _purple = Color(0xFF8B5CF6);
const Color _pink = Color(0xFFFB7185);
const Color _amber = Color(0xFFFBBF24);

Color _bg(BuildContext context) =>
    Theme.of(context).scaffoldBackgroundColor;

Color _surface(BuildContext context) =>
    Theme.of(context).colorScheme.surface;

Color _text(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface;

Color _muted(BuildContext context) =>
    Theme.of(context).colorScheme.onSurfaceVariant;

bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'LankaTransit User';
  String _email = 'user@example.com';
  bool _isLoggingOut = false;

  Future<void> _editProfile() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        final colors = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colors.surface,
          title: Text(
            l10n.editProfile,
            style: TextStyle(color: colors.onSurface),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: colors.onSurface),
                decoration: _inputDecoration(
                  dialogContext,
                  l10n.fullName,
                  Icons.person_outline,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: colors.onSurface),
                decoration: _inputDecoration(
                  dialogContext,
                  l10n.emailAddress,
                  Icons.email_outlined,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, {
                  'name': nameController.text.trim(),
                  'email': emailController.text.trim(),
                });
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    emailController.dispose();

    if (!mounted || result == null) return;

    if ((result['name'] ?? '').isEmpty ||
        (result['email'] ?? '').isEmpty) {
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

  InputDecoration _inputDecoration(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    final colors = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _cyan),
      filled: true,
      fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _cyan, width: 1.5),
      ),
    );
  }

  void _showLanguageSelector() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
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
                style: TextStyle(
                  color: _text(sheetContext),
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

  // Firebase sign out කර LoginScreen එකට යනවා.
  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await AuthService().logout();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoggingOut = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout failed. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _confirmLogout() {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colors = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colors.surface,
          icon: const Icon(Icons.logout_rounded, color: _pink),
          title: Text(
            l10n.logoutTitle,
            style: TextStyle(color: colors.onSurface),
          ),
          content: Text(
            l10n.logoutMessage,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _pink,
                foregroundColor: Colors.white,
              ),
              onPressed: _isLoggingOut
                  ? null
                  : () {
                      Navigator.pop(dialogContext);
                      _logout();
                    },
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const NotificationScreen(),
      ),
    );
  }

  void _openRecentJourneys() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const RecentJourneysScreen(),
      ),
    );
  }

  void _openFavouriteRoutes() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const FavouriteRoutesScreen(),
      ),
    );
  }

  void _openAbout() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const AboutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final currentLanguage = switch (appLocale.value.languageCode) {
      'si' => l10n.sinhala,
      'ta' => l10n.tamil,
      _ => l10n.english,
    };

    return Scaffold(
      backgroundColor: _bg(context),
      appBar: AppBar(
        backgroundColor: _bg(context),
        foregroundColor: _text(context),
        surfaceTintColor: Colors.transparent,
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isDark(context)
                      ? const [
                          Color(0xFF15223B),
                          Color(0xFF211D3D),
                        ]
                      : const [
                          Color(0xFFEAF6FF),
                          Color(0xFFF0EAFF),
                        ],
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: _cyan.withValues(alpha: 0.28),
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
                      color: Colors.white,
                      size: 55,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isDark(context)
                          ? Colors.white
                          : const Color(0xFF17233B),
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isDark(context)
                          ? const Color(0xFFB8C5DA)
                          : const Color(0xFF53627A),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: _editProfile,
                    icon: const Icon(Icons.edit_rounded, size: 17),
                    label: Text(l10n.editProfile),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      side: BorderSide(color: colors.primary),
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
              iconColor: _pink,
              title: l10n.favouriteRoutes,
              subtitle: l10n.savedBusTrainRoutes,
              onTap: _openFavouriteRoutes,
            ),
            const SizedBox(height: 10),
            _ProfileTile(
              icon: Icons.history_rounded,
              iconColor: _amber,
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
                onPressed: _isLoggingOut ? null : _confirmLogout,
                icon: _isLoggingOut
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.logout_rounded),
                label: Text(
                  _isLoggingOut ? 'Logging out...' : l10n.logout,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _pink,
                  side: BorderSide(
                    color: _pink.withValues(alpha: 0.65),
                  ),
                  backgroundColor: _pink.withValues(
                    alpha: _isDark(context) ? 0.10 : 0.06,
                  ),
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
                style: TextStyle(
                  color: _muted(context).withValues(alpha: 0.8),
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
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? colors.primaryContainer
          : colors.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        leading: Icon(
          selected
              ? Icons.check_circle_rounded
              : Icons.circle_outlined,
          color: selected
              ? colors.primary
              : colors.onSurfaceVariant,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selected
                ? colors.onPrimaryContainer
                : colors.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: selected
                ? colors.onPrimaryContainer.withValues(alpha: 0.8)
                : colors.onSurfaceVariant,
          ),
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
      style: TextStyle(
        color: _muted(context),
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
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: _surface(context),
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
              color: iconColor.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.13),
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
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: colors.onSurfaceVariant,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

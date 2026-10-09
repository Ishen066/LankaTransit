import 'package:flutter/material.dart';
import 'app_locale.dart';
import 'l10n/app_localizations.dart';
import 'bus_routes_screen.dart';
import 'train_routes_screen.dart';

void main() {
  runApp(const LankaTransitApp());
}

// ============================================================
// MAIN APP
// ============================================================

class LankaTransitApp extends StatelessWidget {
  const LankaTransitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LankaTransit',

          locale: locale,

          localizationsDelegates:
              AppLocalizations.localizationsDelegates,

          supportedLocales:
              AppLocalizations.supportedLocales,

          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor:
                const Color(0xFFF6F8F7),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF087F5B),
            ),
            fontFamily: 'Arial',
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}

// ============================================================
// LANGUAGE SELECTOR
// ============================================================

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
                      color: const Color(0xFFE8F5EF),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.language_rounded,
                      color: Color(0xFF087F5B),
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
                currentLocale: appLocale.value,
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
                currentLocale: appLocale.value,
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
                currentLocale: appLocale.value,
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

// ============================================================
// LANGUAGE OPTION
// ============================================================

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final Locale locale;
  final Locale currentLocale;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.currentLocale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected =
        currentLocale.languageCode ==
            locale.languageCode;

    return Material(
      color: isSelected
          ? const Color(0xFFE8F5EF)
          : const Color(0xFFF7F9F8),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
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
                        const TextStyle(fontSize: 22),
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                        color: Color(0xFF173B32),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
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
                  color: Color(0xFF087F5B),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GET STARTED / SPLASH SCREEN
// ============================================================

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F8F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            30,
            24,
            28,
          ),
          child: Column(
            children: [
              // LOGO HEADER

              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(0xFFE8F5EF),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons
                          .directions_transit_rounded,
                      color:
                          Color(0xFF087F5B),
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    l10n.appName,
                    style:
                        const TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF173B32),
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      showLanguageSelector(
                          context);
                    },
                    icon: const Icon(
                      Icons.language_rounded,
                      color:
                          Color(0xFF087F5B),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // MAIN ILLUSTRATION

              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    begin:
                        Alignment.topLeft,
                    end:
                        Alignment.bottomRight,
                    colors: [
                      Color(0xFFE8F5EF),
                      Color(0xFFEFF8F5),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(35),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 25,
                      right: 25,
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.7,
                          ),
                          shape:
                              BoxShape.circle,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 25,
                      left: 25,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.7,
                          ),
                          shape:
                              BoxShape.circle,
                        ),
                      ),
                    ),

                    Container(
                      width: 145,
                      height: 145,
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF087F5B,
                            ).withValues(
                              alpha: 0.12,
                            ),
                            blurRadius: 25,
                            offset:
                                const Offset(
                              0,
                              10,
                            ),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons
                            .directions_transit_rounded,
                        size: 75,
                        color:
                            Color(0xFF087F5B),
                      ),
                    ),

                    const Positioned(
                      left: 35,
                      bottom: 55,
                      child:
                          _SmallTransportIcon(
                        icon: Icons
                            .directions_bus_rounded,
                        color:
                            Color(0xFF087F5B),
                      ),
                    ),

                    const Positioned(
                      right: 35,
                      top: 55,
                      child:
                          _SmallTransportIcon(
                        icon:
                            Icons.train_rounded,
                        color:
                            Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                l10n.travelSmarter,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 31,
                  height: 1.15,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Color(0xFF173B32),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                l10n.travelSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // GET STARTED

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                            0xFF087F5B),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              17),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LoginScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.getStarted,
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons
                            .arrow_forward_rounded,
                        size: 21,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                l10n.yourJourneyStartsHere,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SMALL TRANSPORT ICON
// ============================================================

class _SmallTransportIcon
    extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SmallTransportIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 25,
      ),
    );
  }
}

// ============================================================
// LOGIN SCREEN
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  bool _obscurePassword = true;

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF087F5B),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE3EAE7),
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF087F5B),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F8F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            24,
            18,
            24,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    icon: const Icon(
                      Icons
                          .arrow_back_rounded,
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      showLanguageSelector(
                          context);
                    },
                    icon: const Icon(
                      Icons.language_rounded,
                      color:
                          Color(0xFF087F5B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                            0xFFE8F5EF),
                    borderRadius:
                        BorderRadius.circular(
                            22),
                  ),
                  child: const Icon(
                    Icons
                        .directions_transit_rounded,
                    color:
                        Color(0xFF087F5B),
                    size: 38,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  l10n.welcomeBack,
                  style:
                      const TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF173B32),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  l10n.loginSubtitle,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 34),

              Text(
                l10n.emailAddress,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 14,
                  color:
                      Color(0xFF173B32),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                keyboardType:
                    TextInputType.emailAddress,
                decoration:
                    _inputDecoration(
                  label:
                      l10n.enterYourEmail,
                  icon:
                      Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                l10n.password,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 14,
                  color:
                      Color(0xFF173B32),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                obscureText:
                    _obscurePassword,
                decoration:
                    _inputDecoration(
                  label:
                      l10n.enterYourPassword,
                  icon:
                      Icons.lock_outline_rounded,
                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                              .visibility_outlined
                          : Icons
                              .visibility_off_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment:
                    Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    l10n.forgotPassword,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF087F5B),
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HomePage(),
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                            0xFF087F5B),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              17),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.login,
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Icon(
                        Icons
                            .arrow_forward_rounded,
                        size: 21,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color:
                          Color(0xFFDDE5E1),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 14,
                    ),
                    child: Text(
                      l10n.or,
                      style:
                          TextStyle(
                        color: Colors
                            .grey.shade600,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color:
                          Color(0xFFDDE5E1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child:
                    OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons
                        .g_mobiledata_rounded,
                    size: 27,
                  ),
                  label: Text(
                    l10n.continueWithGoogle,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(
                            0xFF173B32),
                    side:
                        const BorderSide(
                      color:
                          Color(0xFFDDE5E1),
                    ),
                    backgroundColor:
                        Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              Center(
                child: Wrap(
                  alignment:
                      WrapAlignment.center,
                  children: [
                    Text(
                      '${l10n.dontHaveAccount} ',
                      style:
                          const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.register,
                        style:
                            const TextStyle(
                          color:
                              Color(0xFF087F5B),
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REGISTER SCREEN
// ============================================================

class RegisterScreen
    extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF087F5B),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE3EAE7),
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF087F5B),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F8F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            24,
            18,
            24,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    icon: const Icon(
                      Icons
                          .arrow_back_rounded,
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      showLanguageSelector(
                          context);
                    },
                    icon: const Icon(
                      Icons.language_rounded,
                      color:
                          Color(0xFF087F5B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                            0xFFE8F5EF),
                    borderRadius:
                        BorderRadius.circular(
                            22),
                  ),
                  child: const Icon(
                    Icons
                        .person_add_alt_1_rounded,
                    color:
                        Color(0xFF087F5B),
                    size: 36,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Center(
                child: Text(
                  l10n.createAccount,
                  style:
                      const TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF173B32),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  l10n.createAccountSubtitle,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                l10n.fullName,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 14,
                  color:
                      Color(0xFF173B32),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                textCapitalization:
                    TextCapitalization.words,
                decoration:
                    _inputDecoration(
                  label:
                      l10n.enterYourFullName,
                  icon: Icons
                      .person_outline_rounded,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                l10n.emailAddress,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 14,
                  color:
                      Color(0xFF173B32),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                keyboardType:
                    TextInputType.emailAddress,
                decoration:
                    _inputDecoration(
                  label:
                      l10n.enterYourEmail,
                  icon:
                      Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                l10n.password,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 14,
                  color:
                      Color(0xFF173B32),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                obscureText:
                    _obscurePassword,
                decoration:
                    _inputDecoration(
                  label:
                      l10n.createPassword,
                  icon:
                      Icons.lock_outline_rounded,
                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                              .visibility_outlined
                          : Icons
                              .visibility_off_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                l10n.confirmPassword,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 14,
                  color:
                      Color(0xFF173B32),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                obscureText:
                    _obscureConfirmPassword,
                decoration:
                    _inputDecoration(
                  label:
                      l10n.confirmYourPassword,
                  icon:
                      Icons.lock_outline_rounded,
                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons
                              .visibility_outlined
                          : Icons
                              .visibility_off_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons
                        .info_outline_rounded,
                    size: 17,
                    color:
                        Color(0xFF087F5B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.passwordHint,
                      style:
                          const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HomePage(),
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                            0xFF087F5B),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              17),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.createAccount,
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Icon(
                        Icons
                            .arrow_forward_rounded,
                        size: 21,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Center(
                child: Wrap(
                  alignment:
                      WrapAlignment.center,
                  children: [
                    Text(
                      '${l10n.alreadyHaveAccount} ',
                      style:
                          const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        l10n.login,
                        style:
                            const TextStyle(
                          color:
                              Color(0xFF087F5B),
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F8F7),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            25,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TOP HEADER
              // ==================================================

              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration:
                        BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(0xFF087F5B),
                          Color(0xFF12A879),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(
                              17),
                    ),
                    child: const Icon(
                      Icons
                          .directions_transit_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          l10n.goodMorning,
                          style:
                              const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.appName,
                          style:
                              const TextStyle(
                            fontSize: 21,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // LANGUAGE BUTTON

                  Container(
                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                              15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        showLanguageSelector(
                            context);
                      },
                      icon: const Icon(
                        Icons
                            .language_rounded,
                        color:
                            Color(0xFF087F5B),
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  Container(
                    width: 44,
                    height: 44,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                              0xFFE8F5EF),
                      borderRadius:
                          BorderRadius.circular(
                              15),
                    ),
                    child: const Icon(
                      Icons
                          .person_outline_rounded,
                      color:
                          Color(0xFF087F5B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // WELCOME BANNER
              // ==================================================

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(22),
                decoration:
                    BoxDecoration(
                  gradient:
                      const LinearGradient(
                    begin:
                        Alignment.topLeft,
                    end:
                        Alignment.bottomRight,
                    colors: [
                      Color(0xFF087F5B),
                      Color(0xFF12A879),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF087F5B,
                      ).withValues(
                        alpha: 0.20,
                      ),
                      blurRadius: 18,
                      offset:
                          const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -15,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.08,
                          ),
                          shape:
                              BoxShape.circle,
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          l10n.whereAreYouGoing,
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          l10n.planYourJourney,
                          style:
                              const TextStyle(
                            color:
                                Colors.white70,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          height: 50,
                          decoration:
                              BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        15),
                          ),
                          child: TextField(
                            decoration:
                                InputDecoration(
                              hintText:
                                  l10n.searchDestination,
                              hintStyle:
                                  const TextStyle(
                                color:
                                    Colors.grey,
                                fontSize: 14,
                              ),
                              prefixIcon:
                                  const Icon(
                                Icons
                                    .search_rounded,
                                color:
                                    Color(
                                        0xFF087F5B),
                              ),
                              border:
                                  InputBorder.none,
                              contentPadding:
                                  const EdgeInsets
                                      .symmetric(
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // TRANSPORT
              // ==================================================

              Text(
                l10n.chooseYourTransport,
                style:
                    const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                l10n.selectHowYouTravel,
                style:
                    const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: _TransportCard(
                      icon: Icons
                          .directions_bus_rounded,
                      title: l10n.bus,
                      subtitle:
                          l10n.findBusRoutes,
                      iconColor:
                          const Color(
                              0xFF087F5B),
                      backgroundColor:
                          const Color(
                              0xFFE8F5EF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const BusRoutesScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _TransportCard(
                      icon:
                          Icons.train_rounded,
                      title: l10n.train,
                      subtitle:
                          l10n.findTrainRoutes,
                      iconColor:
                          const Color(
                              0xFF2563EB),
                      backgroundColor:
                          const Color(
                              0xFFEFF4FF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const TrainRoutesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // QUICK ACCESS
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Text(
                    l10n.quickAccess,
                    style:
                        const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      l10n.viewAll,
                      style:
                          const TextStyle(
                        color:
                            Color(0xFF087F5B),
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              _QuickActionCard(
                icon: Icons
                    .location_on_rounded,
                title:
                    l10n.nearbyTransport,
                subtitle:
                    l10n.findNearbyTransport,
                iconColor:
                    const Color(0xFF087F5B),
                backgroundColor:
                    const Color(0xFFE8F5EF),
                onTap: () {},
              ),

              const SizedBox(height: 11),

              _QuickActionCard(
                icon:
                    Icons.favorite_rounded,
                title:
                    l10n.favouriteRoutes,
                subtitle:
                    l10n.savedRoutes,
                iconColor:
                    const Color(0xFFE63963),
                backgroundColor:
                    const Color(0xFFFFEDF1),
                onTap: () {},
              ),

              const SizedBox(height: 11),

              _QuickActionCard(
                icon:
                    Icons.history_rounded,
                title:
                    l10n.recentJourneys,
                subtitle:
                    l10n.recentTrips,
                iconColor:
                    const Color(0xFFF59E0B),
                backgroundColor:
                    const Color(0xFFFFF7E6),
                onTap: () {},
              ),

              const SizedBox(height: 28),

              // ==================================================
              // INFO CARD
              // ==================================================

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(18),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFEFF4FF),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                      child: const Icon(
                        Icons
                            .lightbulb_outline_rounded,
                        color:
                            Color(0xFF2563EB),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            l10n.travelSmart,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                              height: 4),
                          Text(
                            l10n
                                .travelSmartDescription,
                            style:
                                const TextStyle(
                              color:
                                  Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar:
          NavigationBar(
        height: 70,
        selectedIndex: 0,
        backgroundColor: Colors.white,
        indicatorColor:
            const Color(0xFFE8F5EF),
        labelTextStyle:
            WidgetStateProperty.all(
          const TextStyle(
            fontSize: 11,
            fontWeight:
                FontWeight.w600,
          ),
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(
                Icons.home_outlined),
            selectedIcon:
                const Icon(
              Icons.home,
              color:
                  Color(0xFF087F5B),
            ),
            label: l10n.home,
          ),

          NavigationDestination(
            icon: const Icon(
                Icons.route_outlined),
            selectedIcon:
                const Icon(
              Icons.route,
              color:
                  Color(0xFF087F5B),
            ),
            label: l10n.routes,
          ),

          NavigationDestination(
            icon: const Icon(
                Icons.favorite_border),
            selectedIcon:
                const Icon(
              Icons.favorite,
              color:
                  Color(0xFFE63963),
            ),
            label: l10n.favorites,
          ),

          NavigationDestination(
            icon: const Icon(
                Icons.person_outline),
            selectedIcon:
                const Icon(
              Icons.person,
              color:
                  Color(0xFF087F5B),
            ),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TRANSPORT CARD
// ============================================================

class _TransportCard
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _TransportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(22),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.all(18),
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(
                  alpha: 0.035,
                ),
                blurRadius: 12,
                offset:
                    const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration:
                    BoxDecoration(
                  color:
                      backgroundColor,
                  borderRadius:
                      BorderRadius.circular(
                          17),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 30,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                subtitle,
                style:
                    const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Text(
                    l10n.explore,
                    style: TextStyle(
                      color: iconColor,
                      fontWeight:
                          FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(width: 5),

                  Icon(
                    Icons
                        .arrow_forward_rounded,
                    color: iconColor,
                    size: 17,
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

// ============================================================
// QUICK ACTION CARD
// ============================================================

class _QuickActionCard
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(19),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(19),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration:
                    BoxDecoration(
                  color:
                      backgroundColor,
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons
                    .arrow_forward_ios_rounded,
                size: 16,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
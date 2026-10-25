import 'package:flutter/material.dart';

import 'app_locale.dart';
import 'app_theme.dart';
import 'l10n/app_localizations.dart';
import 'bus_routes_screen.dart';
import 'train_routes_screen.dart';
import 'favourite_routes_screen.dart';
import 'routes_screen.dart';
import 'nearby_transport_screen.dart';
import 'profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load saved app theme
  await AppTheme.load();

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
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppTheme.mode,
          builder: (context, mode, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'LankaTransit',
              locale: locale,
              themeMode: mode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}

// ============================================================
// THEME HELPERS
// ============================================================

Color _page(BuildContext context) => Theme.of(context).scaffoldBackgroundColor;

Color _surface(BuildContext context) => Theme.of(context).colorScheme.surface;

Color _text(BuildContext context) => Theme.of(context).colorScheme.onSurface;

Color _muted(BuildContext context) => AppTheme.secondaryText(context);

Color _primary(BuildContext context) => Theme.of(context).colorScheme.primary;

// ============================================================
// LANGUAGE SELECTOR
// ============================================================

void showLanguageSelector(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    backgroundColor: _surface(context),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.language,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: _text(sheetContext),
                ),
              ),
              const SizedBox(height: 20),
              _LanguageOption(
                title: l10n.english,
                subtitle: 'English',
                locale: const Locale('en'),
                onTap: () {
                  appLocale.value = const Locale('en');
                  Navigator.pop(sheetContext);
                },
              ),
              const SizedBox(height: 10),
              _LanguageOption(
                title: l10n.sinhala,
                subtitle: 'සිංහල',
                locale: const Locale('si'),
                onTap: () {
                  appLocale.value = const Locale('si');
                  Navigator.pop(sheetContext);
                },
              ),
              const SizedBox(height: 10),
              _LanguageOption(
                title: l10n.tamil,
                subtitle: 'தமிழ்',
                locale: const Locale('ta'),
                onTap: () {
                  appLocale.value = const Locale('ta');
                  Navigator.pop(sheetContext);
                },
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
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = appLocale.value.languageCode == locale.languageCode;
    final theme = Theme.of(context);

    return Material(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.12)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  locale.languageCode == 'en' ? '🇬🇧' : '🇱🇰',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _text(context),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: _muted(context)),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: _primary(context)),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SPLASH SCREEN
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginSession();
  }

  void _checkLoginSession() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _page(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/lanka_transit_splash.png',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: _page(context)),
          ),
          Container(
            color: isDark ? const Color(0xCC070B18) : const Color(0x99070B18),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_transit_rounded,
                        color: Color(0xFF38BDF8),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.appName,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => showLanguageSelector(context),
                        icon: const Icon(
                          Icons.language_rounded,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          AppTheme.setMode(
                            isDark ? ThemeMode.light : ThemeMode.dark,
                          );
                        },
                        icon: Icon(
                          isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    l10n.travelSmarter,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 34,
                      height: 1.15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.travelSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.getStarted),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.yourJourneyStartsHere,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SHARED AUTH INPUT
// ============================================================

InputDecoration _inputDecoration(
  BuildContext context, {
  required String label,
  required IconData icon,
  Widget? suffixIcon,
}) {
  final theme = Theme.of(context);
  final border = AppTheme.borderColor(context);

  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: theme.colorScheme.primary),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: theme.colorScheme.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _loginError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Check your internet connection.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return e.message ?? 'Login failed. Please try again.';
    }
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter your email and password.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().login(email: email, password: password);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) _showMessage(_loginError(e));
    } catch (_) {
      if (mounted) {
        _showMessage('Something went wrong. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Enter your email address first.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().sendPasswordReset(email);

      if (mounted) {
        _showMessage(
          'If an account exists for this email, a reset link will be sent.',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _showMessage(
          e.code == 'invalid-email'
              ? 'Please enter a valid email address.'
              : 'Could not send reset email. Please try again.',
        );
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Could not send reset email. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: _page(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 470),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: MaterialLocalizations.of(context)
                            .backButtonTooltip,
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Change language',
                        onPressed: () => showLanguageSelector(context),
                        icon: const Icon(Icons.language_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F9D78), Color(0xFF087F8C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F9D78).withValues(alpha:.24),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.directions_transit_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      l10n.appName,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.welcomeBack,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: _text(context),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: _muted(context),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: _surface(context),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: AppTheme.borderColor(context).withValues(alpha:.7),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:
                            theme.brightness == Brightness.dark ? .08 : .045,
                          ),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _FieldLabel(text: l10n.emailAddress),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: _inputDecoration(
                            context,
                            label: l10n.enterYourEmail,
                            icon: Icons.mail_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FieldLabel(text: l10n.password),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onSubmitted: (_) => _login(),
                          decoration: _inputDecoration(
                            context,
                            label: l10n.enterYourPassword,
                            icon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isLoading ? null : _forgotPassword,
                            child: Text(l10n.forgotPassword),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        l10n.login,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 19,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          l10n.dontHaveAccount,
                          style: TextStyle(color: _muted(context)),
                        ),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                ),
                          child: Text(
                            l10n.register,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please complete all fields.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must contain at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().register(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;

      _showMessage('Account created successfully!');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'weak-password':
          message = 'Please choose a stronger password.';
          break;
        case 'network-request-failed':
          message = 'Check your internet connection.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password login is not enabled in Firebase.';
          break;
        default:
          message = e.message ?? 'Registration failed. Please try again.';
      }

      _showMessage(message);
    } catch (_) {
      if (mounted) {
        _showMessage(
          'Account creation may have started, but saving the profile failed. '
          'Try logging in before registering again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: _page(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 470),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Change language',
                        onPressed: () => showLanguageSelector(context),
                        icon: const Icon(Icons.language_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F9D78), Color(0xFF087F8C)],
                        ),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      l10n.appName,
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.createAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                      color: _text(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.createAccountSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: _muted(context),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: _surface(context),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: AppTheme.borderColor(context).withValues(alpha:.7),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:
                            theme.brightness == Brightness.dark ? .08 : .045,
                          ),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _FieldLabel(text: l10n.fullName),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          enabled: !_isLoading,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            context,
                            label: l10n.enterYourFullName,
                            icon: Icons.person_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: 17),
                        _FieldLabel(text: l10n.emailAddress),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: _inputDecoration(
                            context,
                            label: l10n.enterYourEmail,
                            icon: Icons.mail_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: 17),
                        _FieldLabel(text: l10n.password),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            context,
                            label: l10n.createPassword,
                            icon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 17),
                        _FieldLabel(text: l10n.confirmPassword),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _confirmPasswordController,
                          enabled: !_isLoading,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _register(),
                          decoration: _inputDecoration(
                            context,
                            label: l10n.confirmYourPassword,
                            icon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              ),
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 17,
                              color: _muted(context),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                l10n.passwordHint,
                                style: TextStyle(
                                  color: _muted(context),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _isLoading ? null : _register,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        l10n.createAccount,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 19,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          l10n.alreadyHaveAccount,
                          style: TextStyle(color: _muted(context)),
                        ),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(
                            l10n.login,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: _text(context),
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _page(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF38BDF8), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.directions_transit_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.goodMorning,
                          style: TextStyle(color: _muted(context)),
                        ),
                        Text(
                          l10n.appName,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: _text(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _HeaderButton(
                    icon: Icons.language_rounded,
                    onTap: () => showLanguageSelector(context),
                  ),
                  const SizedBox(width: 5),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: AppTheme.mode,
                    builder: (context, mode, child) {
                      return _HeaderButton(
                        icon: mode == ThemeMode.dark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        onTap: () {
                          AppTheme.setMode(
                            mode == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 5),
                  _HeaderButton(
                    icon: Icons.person_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF38BDF8), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.whereAreYouGoing,
                      style: const TextStyle(
                        color: Color(0xFF07111F),
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      l10n.planYourJourney,
                      style: const TextStyle(
                        color: Color(0xDD07111F),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RoutesScreen(),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: l10n.searchDestination,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF0284C7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                l10n.chooseYourTransport,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _text(context),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                l10n.selectHowYouTravel,
                style: TextStyle(color: _muted(context)),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _TransportCard(
                      icon: Icons.directions_bus_rounded,
                      title: l10n.bus,
                      subtitle: l10n.findBusRoutes,
                      iconColor: const Color(0xFF38BDF8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BusRoutesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _TransportCard(
                      icon: Icons.train_rounded,
                      title: l10n.train,
                      subtitle: l10n.findTrainRoutes,
                      iconColor: const Color(0xFF8B5CF6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TrainRoutesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.quickAccess,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _text(context),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RoutesScreen()),
                      );
                    },
                    child: Text(l10n.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _QuickActionCard(
                icon: Icons.location_on_rounded,
                title: l10n.nearbyTransport,
                subtitle: l10n.findNearbyTransport,
                iconColor: const Color(0xFF38BDF8),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NearbyTransportScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 11),
              _QuickActionCard(
                icon: Icons.favorite_rounded,
                title: l10n.favouriteRoutes,
                subtitle: l10n.savedRoutes,
                iconColor: const Color(0xFFFB7185),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavouriteRoutesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 11),
              _QuickActionCard(
                icon: Icons.history_rounded,
                title: l10n.recentJourneys,
                subtitle: l10n.recentTrips,
                iconColor: const Color(0xFFF59E0B),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RoutesScreen()),
                  );
                },
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _surface(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: _primary(context),
                      size: 32,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.travelSmart,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _text(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.travelSmartDescription,
                            style: TextStyle(
                              color: _muted(context),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: 0,
        backgroundColor: _surface(context),
        indicatorColor: _primary(context).withValues(alpha: 0.13),
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoutesScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavouriteRoutesScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.route_outlined),
            selectedIcon: const Icon(Icons.route),
            label: l10n.routes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: l10n.favorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HEADER BUTTON
// ============================================================

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface(context),
      borderRadius: BorderRadius.circular(14),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: _primary(context)),
      ),
    );
  }
}

// ============================================================
// TRANSPORT CARD
// ============================================================

class _TransportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _TransportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface(context),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: iconColor.withValues(alpha: 0.30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 29),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _text(context),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: _muted(context)),
              ),
              const SizedBox(height: 15),
              Icon(Icons.arrow_forward_rounded, color: iconColor),
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

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface(context),
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: iconColor.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: iconColor, size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _text(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: _muted(context), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}

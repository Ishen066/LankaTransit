import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
    Locale('ta'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'LankaTransit'**
  String get appName;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @travelSmarter.
  ///
  /// In en, this message translates to:
  /// **'Travel Smarter,\nTravel Better'**
  String get travelSmarter;

  /// No description provided for @travelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover bus and train routes across Sri Lanka\nand plan your journey with ease.'**
  String get travelSubtitle;

  /// No description provided for @yourJourneyStartsHere.
  ///
  /// In en, this message translates to:
  /// **'Your journey starts here'**
  String get yourJourneyStartsHere;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to continue your journey with LankaTransit.'**
  String get loginSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your LankaTransit account and start\nplanning smarter journeys.'**
  String get createAccountSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters for a stronger password.'**
  String get passwordHint;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning 👋'**
  String get goodMorning;

  /// No description provided for @whereAreYouGoing.
  ///
  /// In en, this message translates to:
  /// **'Where are you going?'**
  String get whereAreYouGoing;

  /// No description provided for @planYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Plan your journey with Sri Lanka’s\npublic transport network.'**
  String get planYourJourney;

  /// No description provided for @searchDestination.
  ///
  /// In en, this message translates to:
  /// **'Search destination...'**
  String get searchDestination;

  /// No description provided for @chooseYourTransport.
  ///
  /// In en, this message translates to:
  /// **'Choose your transport'**
  String get chooseYourTransport;

  /// No description provided for @selectHowYouTravel.
  ///
  /// In en, this message translates to:
  /// **'Select how you want to travel'**
  String get selectHowYouTravel;

  /// No description provided for @bus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get bus;

  /// No description provided for @train.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get train;

  /// No description provided for @findBusRoutes.
  ///
  /// In en, this message translates to:
  /// **'Find bus routes'**
  String get findBusRoutes;

  /// No description provided for @findTrainRoutes.
  ///
  /// In en, this message translates to:
  /// **'Find train routes'**
  String get findTrainRoutes;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @nearbyTransport.
  ///
  /// In en, this message translates to:
  /// **'Nearby Transport'**
  String get nearbyTransport;

  /// No description provided for @findNearbyTransport.
  ///
  /// In en, this message translates to:
  /// **'Find buses and trains near you'**
  String get findNearbyTransport;

  /// No description provided for @favouriteRoutes.
  ///
  /// In en, this message translates to:
  /// **'Favourite Routes'**
  String get favouriteRoutes;

  /// No description provided for @savedRoutes.
  ///
  /// In en, this message translates to:
  /// **'Your saved routes'**
  String get savedRoutes;

  /// No description provided for @recentJourneys.
  ///
  /// In en, this message translates to:
  /// **'Recent Journeys'**
  String get recentJourneys;

  /// No description provided for @recentTrips.
  ///
  /// In en, this message translates to:
  /// **'View your recent trips'**
  String get recentTrips;

  /// No description provided for @travelSmart.
  ///
  /// In en, this message translates to:
  /// **'Travel Smart'**
  String get travelSmart;

  /// No description provided for @travelSmartDescription.
  ///
  /// In en, this message translates to:
  /// **'Use public transport and enjoy a smarter journey.'**
  String get travelSmartDescription;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @routes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get routes;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @busRoutes.
  ///
  /// In en, this message translates to:
  /// **'Bus Routes'**
  String get busRoutes;

  /// No description provided for @trainRoutes.
  ///
  /// In en, this message translates to:
  /// **'Train Routes'**
  String get trainRoutes;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @sinhala.
  ///
  /// In en, this message translates to:
  /// **'Sinhala'**
  String get sinhala;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get tamil;

  /// No description provided for @findBusRoute.
  ///
  /// In en, this message translates to:
  /// **'Find Your Bus Route'**
  String get findBusRoute;

  /// No description provided for @findTrainRoute.
  ///
  /// In en, this message translates to:
  /// **'Find Your Train Route'**
  String get findTrainRoute;

  /// No description provided for @popularBusRoutes.
  ///
  /// In en, this message translates to:
  /// **'Popular Bus Routes'**
  String get popularBusRoutes;

  /// No description provided for @popularTrainRoutes.
  ///
  /// In en, this message translates to:
  /// **'Popular Train Routes'**
  String get popularTrainRoutes;

  /// No description provided for @routeDetails.
  ///
  /// In en, this message translates to:
  /// **'Route Details'**
  String get routeDetails;

  /// No description provided for @viewRoute.
  ///
  /// In en, this message translates to:
  /// **'View Route'**
  String get viewRoute;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'FROM'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'TO'**
  String get to;

  /// No description provided for @yourJourney.
  ///
  /// In en, this message translates to:
  /// **'Your Journey'**
  String get yourJourney;

  /// No description provided for @tripInformation.
  ///
  /// In en, this message translates to:
  /// **'Trip Information'**
  String get tripInformation;

  /// No description provided for @mainStops.
  ///
  /// In en, this message translates to:
  /// **'Main Stops'**
  String get mainStops;

  /// No description provided for @addToFavourites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favourites'**
  String get addToFavourites;

  /// No description provided for @addedToFavourites.
  ///
  /// In en, this message translates to:
  /// **'Added to Favourites'**
  String get addedToFavourites;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @busRouteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore bus routes and find your destination easily.'**
  String get busRouteSubtitle;

  /// No description provided for @searchBusRoute.
  ///
  /// In en, this message translates to:
  /// **'Search bus number or destination'**
  String get searchBusRoute;

  /// No description provided for @routesCount.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get routesCount;

  /// No description provided for @busRouteLabel.
  ///
  /// In en, this message translates to:
  /// **'BUS ROUTE'**
  String get busRouteLabel;

  /// No description provided for @noBusRoutes.
  ///
  /// In en, this message translates to:
  /// **'No bus routes found'**
  String get noBusRoutes;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @pleaseEnterNameEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name and email.'**
  String get pleaseEnterNameEmail;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out?'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to return to the welcome screen?'**
  String get logoutMessage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @yourTravel.
  ///
  /// In en, this message translates to:
  /// **'YOUR TRAVEL'**
  String get yourTravel;

  /// No description provided for @savedBusTrainRoutes.
  ///
  /// In en, this message translates to:
  /// **'Your saved bus and train routes'**
  String get savedBusTrainRoutes;

  /// No description provided for @reviewRecentTrips.
  ///
  /// In en, this message translates to:
  /// **'Review your recent trips'**
  String get reviewRecentTrips;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @viewTravelUpdates.
  ///
  /// In en, this message translates to:
  /// **'View your travel updates'**
  String get viewTravelUpdates;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutSection;

  /// No description provided for @aboutLankaTransit.
  ///
  /// In en, this message translates to:
  /// **'About LankaTransit'**
  String get aboutLankaTransit;

  /// No description provided for @learnMoreAboutApp.
  ///
  /// In en, this message translates to:
  /// **'Learn more about our app'**
  String get learnMoreAboutApp;

  /// No description provided for @travelSmarterFooter.
  ///
  /// In en, this message translates to:
  /// **'Travel smarter, travel better'**
  String get travelSmarterFooter;

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Travel Smarter, Travel Better'**
  String get aboutTagline;

  /// No description provided for @aboutCompanion.
  ///
  /// In en, this message translates to:
  /// **'Your travel companion for exploring Sri Lanka.'**
  String get aboutCompanion;

  /// No description provided for @aboutOurApp.
  ///
  /// In en, this message translates to:
  /// **'About Our App'**
  String get aboutOurApp;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'LankaTransit helps users explore bus and train routes across Sri Lanka. It provides a simple interface to discover transport options and organise journeys.'**
  String get aboutDescription;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @aboutBusDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore available bus route information.'**
  String get aboutBusDescription;

  /// No description provided for @aboutTrainDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover train route information.'**
  String get aboutTrainDescription;

  /// No description provided for @aboutNearbyDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore nearby transport options.'**
  String get aboutNearbyDescription;

  /// No description provided for @aboutFavouritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Access your saved favourite routes.'**
  String get aboutFavouritesDescription;

  /// No description provided for @aboutRecentDescription.
  ///
  /// In en, this message translates to:
  /// **'View your recent journey list.'**
  String get aboutRecentDescription;

  /// No description provided for @appInformation.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @coverage.
  ///
  /// In en, this message translates to:
  /// **'Coverage'**
  String get coverage;

  /// No description provided for @sriLanka.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get sriLanka;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @madeForSmarterJourneys.
  ///
  /// In en, this message translates to:
  /// **'Made for smarter journeys'**
  String get madeForSmarterJourneys;

  /// No description provided for @refreshLocation.
  ///
  /// In en, this message translates to:
  /// **'Refresh location'**
  String get refreshLocation;

  /// No description provided for @findingCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Finding your current location...'**
  String get findingCurrentLocation;

  /// No description provided for @transportWithin5Km.
  ///
  /// In en, this message translates to:
  /// **'Transport within 5 km of you'**
  String get transportWithin5Km;

  /// No description provided for @busStops.
  ///
  /// In en, this message translates to:
  /// **'Bus stops'**
  String get busStops;

  /// No description provided for @trainStations.
  ///
  /// In en, this message translates to:
  /// **'Train stations'**
  String get trainStations;

  /// No description provided for @nearbyPlaces.
  ///
  /// In en, this message translates to:
  /// **'Nearby places'**
  String get nearbyPlaces;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noPlacesToShow.
  ///
  /// In en, this message translates to:
  /// **'No places to show yet.'**
  String get noPlacesToShow;

  /// No description provided for @checkLocationTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Check your location and try again.'**
  String get checkLocationTryAgain;

  /// No description provided for @locationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Please turn on Location/GPS on your device.'**
  String get locationServiceOff;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied. Allow it to find nearby transport.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionBlocked.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked. Enable it in your device app settings.'**
  String get locationPermissionBlocked;

  /// No description provided for @mapServiceBusy.
  ///
  /// In en, this message translates to:
  /// **'Map data service is busy. Please try again in a moment.'**
  String get mapServiceBusy;

  /// No description provided for @noNearbyStopsFound.
  ///
  /// In en, this message translates to:
  /// **'No nearby stops found in OpenStreetMap data. Try refreshing or check your internet connection.'**
  String get noNearbyStopsFound;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @metersAway.
  ///
  /// In en, this message translates to:
  /// **'m away'**
  String get metersAway;

  /// No description provided for @kilometersAway.
  ///
  /// In en, this message translates to:
  /// **'km away'**
  String get kilometersAway;

  /// No description provided for @busStop.
  ///
  /// In en, this message translates to:
  /// **'Bus Stop'**
  String get busStop;

  /// No description provided for @trainStation.
  ///
  /// In en, this message translates to:
  /// **'Train Station'**
  String get trainStation;

  /// No description provided for @yourTravelHistory.
  ///
  /// In en, this message translates to:
  /// **'Your travel history'**
  String get yourTravelHistory;

  /// No description provided for @busJourney.
  ///
  /// In en, this message translates to:
  /// **'Bus Journey'**
  String get busJourney;

  /// No description provided for @trainJourney.
  ///
  /// In en, this message translates to:
  /// **'Train Journey'**
  String get trainJourney;

  /// No description provided for @sampleJourneysMessage.
  ///
  /// In en, this message translates to:
  /// **'Sample journeys are displayed for now.'**
  String get sampleJourneysMessage;

  /// No description provided for @notificationWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to LankaTransit!'**
  String get notificationWelcomeTitle;

  /// No description provided for @notificationWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using LankaTransit. Explore bus and train routes and plan your next journey around Sri Lanka.'**
  String get notificationWelcomeMessage;

  /// No description provided for @notificationBusTitle.
  ///
  /// In en, this message translates to:
  /// **'Bus Routes'**
  String get notificationBusTitle;

  /// No description provided for @notificationBusMessage.
  ///
  /// In en, this message translates to:
  /// **'Explore available bus route information and check your preferred destination before starting your journey.'**
  String get notificationBusMessage;

  /// No description provided for @notificationTrainTitle.
  ///
  /// In en, this message translates to:
  /// **'Train Journey'**
  String get notificationTrainTitle;

  /// No description provided for @notificationTrainMessage.
  ///
  /// In en, this message translates to:
  /// **'Visit the Train Routes section to explore train journey information for your next trip.'**
  String get notificationTrainMessage;

  /// No description provided for @notificationNearbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Transport'**
  String get notificationNearbyTitle;

  /// No description provided for @notificationNearbyMessage.
  ///
  /// In en, this message translates to:
  /// **'Use Nearby Transport to explore transport options around your current location.'**
  String get notificationNearbyMessage;

  /// No description provided for @notificationFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Your Favourite Routes'**
  String get notificationFavoritesTitle;

  /// No description provided for @notificationFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on a route to add it to your favourite routes and find it more easily later.'**
  String get notificationFavoritesMessage;

  /// No description provided for @notificationTimeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationTimeJustNow;

  /// No description provided for @notificationTimeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationTimeToday;

  /// No description provided for @notificationTimeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationTimeYesterday;

  /// No description provided for @notificationTimeTwoDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get notificationTimeTwoDaysAgo;

  /// No description provided for @notificationTimeThreeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'3 days ago'**
  String get notificationTimeThreeDaysAgo;

  /// No description provided for @notificationGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get notificationGotIt;

  /// No description provided for @notificationAllMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get notificationAllMarkedRead;

  /// No description provided for @notificationReadAll.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get notificationReadAll;

  /// No description provided for @notificationStayUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stay updated!'**
  String get notificationStayUpdated;

  /// No description provided for @notificationAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up!'**
  String get notificationAllCaughtUp;

  /// No description provided for @notificationUnreadCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Unread notifications:'**
  String get notificationUnreadCountLabel;

  /// No description provided for @notificationYourNotifications.
  ///
  /// In en, this message translates to:
  /// **'Your notifications'**
  String get notificationYourNotifications;

  /// No description provided for @notificationItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get notificationItemsLabel;

  /// No description provided for @notificationUnreadFilter.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationUnreadFilter;

  /// No description provided for @notificationNoUnread.
  ///
  /// In en, this message translates to:
  /// **'There are no unread notifications.'**
  String get notificationNoUnread;

  /// No description provided for @exploreRoutesTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Routes'**
  String get exploreRoutesTitle;

  /// No description provided for @journeyPlannerLabel.
  ///
  /// In en, this message translates to:
  /// **'SRI LANKA • JOURNEY PLANNER'**
  String get journeyPlannerLabel;

  /// No description provided for @whereWouldYouLikeToGo.
  ///
  /// In en, this message translates to:
  /// **'Where would you\nlike to go?'**
  String get whereWouldYouLikeToGo;

  /// No description provided for @chooseTransportDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your transport and find a route that fits your journey.'**
  String get chooseTransportDescription;

  /// No description provided for @chooseTransportLabel.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE TRANSPORT'**
  String get chooseTransportLabel;

  /// No description provided for @busRoutesExploreDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore bus routes and plan your trip across the island.'**
  String get busRoutesExploreDescription;

  /// No description provided for @roadTravelLabel.
  ///
  /// In en, this message translates to:
  /// **'ROAD TRAVEL'**
  String get roadTravelLabel;

  /// No description provided for @trainRoutesExploreDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover railway journeys, stations and scenic routes.'**
  String get trainRoutesExploreDescription;

  /// No description provided for @railTravelLabel.
  ///
  /// In en, this message translates to:
  /// **'RAIL TRAVEL'**
  String get railTravelLabel;

  /// No description provided for @saveFavouriteRouteTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Save a route with the heart icon to find it quickly in Favourite Routes.'**
  String get saveFavouriteRouteTip;

  /// No description provided for @refreshFavourites.
  ///
  /// In en, this message translates to:
  /// **'Refresh favourites'**
  String get refreshFavourites;

  /// No description provided for @favouriteRoutesDescription.
  ///
  /// In en, this message translates to:
  /// **'Your favourite bus and train journeys'**
  String get favouriteRoutesDescription;

  /// No description provided for @oneSavedRoute.
  ///
  /// In en, this message translates to:
  /// **'1 saved route'**
  String get oneSavedRoute;

  /// No description provided for @savedRoutesCountLabel.
  ///
  /// In en, this message translates to:
  /// **'saved routes'**
  String get savedRoutesCountLabel;

  /// No description provided for @noFavouriteRoutesYet.
  ///
  /// In en, this message translates to:
  /// **'No favourite routes yet'**
  String get noFavouriteRoutesYet;

  /// No description provided for @saveFavouriteRoutesDescription.
  ///
  /// In en, this message translates to:
  /// **'Open a bus or train route and tap the heart icon to save it here.'**
  String get saveFavouriteRoutesDescription;

  /// No description provided for @exploreRoutesButton.
  ///
  /// In en, this message translates to:
  /// **'Explore routes'**
  String get exploreRoutesButton;

  /// No description provided for @removeFavourite.
  ///
  /// In en, this message translates to:
  /// **'Remove favourite'**
  String get removeFavourite;

  /// No description provided for @routeRemovedFromFavourites.
  ///
  /// In en, this message translates to:
  /// **'Route removed from favourites'**
  String get routeRemovedFromFavourites;

  /// No description provided for @couldNotRemoveRoute.
  ///
  /// In en, this message translates to:
  /// **'Could not remove route. Please try again.'**
  String get couldNotRemoveRoute;

  /// No description provided for @savedRouteFallback.
  ///
  /// In en, this message translates to:
  /// **'Saved route'**
  String get savedRouteFallback;

  /// No description provided for @startLocationFallback.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startLocationFallback;

  /// No description provided for @destinationFallback.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destinationFallback;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

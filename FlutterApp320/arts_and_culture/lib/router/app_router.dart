import 'package:arts_and_culture/auth/auth_provider.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:arts_and_culture/event_details_screen.dart';
import 'package:arts_and_culture/guest_login_screen.dart';
import 'package:arts_and_culture/link_bank_screen.dart';
import 'package:arts_and_culture/my_classes_screen.dart';
import 'package:arts_and_culture/pamphlet_screen.dart';
import 'package:arts_and_culture/start_screen.dart';
import 'package:arts_and_culture/home_screen.dart';
import 'package:arts_and_culture/calendar_screen.dart';
import 'package:arts_and_culture/uploaded_pamphlet_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:arts_and_culture/qr_scanner.dart';
import 'package:flutter/material.dart';

final authProvider = AuthProvider();

final GoRouter appRouter = GoRouter(
  refreshListenable: authProvider,
  initialLocation: startScreenPath,
  redirect: (BuildContext context, GoRouterState state) {
    final bool fullyLoggedIn = authProvider.isAuthenticated;
    final bool isGuest = authProvider.isGuest;
    final bool hasAccess = authProvider.hasAccess; // either ADFS or guest
    final String location = state.matchedLocation;
    final bool onStartScreen = location == startScreenPath;
    final bool onGuestLogin = location == guestLoginScreenPath;

    if (!hasAccess && !onStartScreen && !onGuestLogin) {
      return startScreenPath;
    }

    if (fullyLoggedIn && onStartScreen) return homeScreenPath;

    if (isGuest && !fullyLoggedIn) {
      if (onStartScreen) return homeScreenPath;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: startScreenPath,
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: guestLoginScreenPath,
      builder: (context, state) => const GuestLoginScreen(),
    ),
    GoRoute(
      path: homeScreenPath,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: calendarScreenPath,
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: linkBankScreenPath,
      builder: (context, state) => const LinkBankScreen(),
    ),
    GoRoute(
      path: qrScannerPath,
      builder: (context, state) => const QrScannerPage(),
    ),
    GoRoute(
      path: myClassesScreenPath,
      builder: (context, state) => const MyClassesScreen(),
    ),
    GoRoute(
      path: eventDetailsPath,
      builder: (context, state) {
        final eventId = state.pathParameters["eventId"]!;
        return EventDetailsScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: pamphletViewPath,
      builder: (context, state) {
        final eventId = state.pathParameters["eventId"]!;
        final pamphletId = int.parse(state.pathParameters["pamphletId"]!);
        return PamphletScreen(eventId: eventId, pamphletId: pamphletId);
      },
    ),
    GoRoute(
      path: uploadedPamphletViewPath,
      builder: (context, state) {
        final pamphletId = int.parse(state.pathParameters["pamphletId"]!);
        return UploadedPamphletScreen(pamphletId: pamphletId);
      },
    ),
  ],
);

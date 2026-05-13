import 'package:arts_and_culture/api/api_service.dart';
import 'package:arts_and_culture/components/launch_url.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:arts_and_culture/api/get_events.dart';
import 'package:arts_and_culture/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:arts_and_culture/components/announcement_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:collection/collection.dart';
import 'package:arts_and_culture/components/confetti.dart';
import 'package:flutter/gestures.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _tutorialSeenKey = 'has_seen_home_tutorial_v1';
  late Future<List<Event>> _futureEvents;
  late Future<String> _aboutVersionFuture;

  final api = ApiService();
  final Set<String> _locallyReadEventIds = {};
  final GlobalKey<AnnouncementBannerState> _announcementKey =
      GlobalKey<AnnouncementBannerState>();

  void _handleEventViewed(String eventId) {
    setState(() {
      _locallyReadEventIds.add(eventId);
    });

    if (authProvider.isAuthenticated) {
      api.markEventsAsRead().catchError((_) {});
    } else {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('guest_last_viewed_events', DateTime.now().toIso8601String());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _aboutVersionFuture = _readAppVersionText();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorialIfNeeded();
    });
  }

  void _loadEvents() {
    final current = getEventsList(DateTime.now().month, DateTime.now().year);
    final next = getEventsList(DateTime.now().month + 1, DateTime.now().year);

    _futureEvents = Future.wait([current, next]).then((results) {
      final combined = <Event>[...results[0], ...results[1]];
      return combined;
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _locallyReadEventIds.clear();
      _loadEvents();
    });

    await Future.wait([
      _futureEvents,
      _announcementKey.currentState?.fetchData() ?? Future.value(),
    ]);
  }

  Future<String> _readAppVersionText() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version.trim();
      final build = info.buildNumber.trim();
      if (version.isEmpty && build.isEmpty) return 'Version unavailable';
      if (build.isEmpty) return 'Version $version';
      return 'Version $version+$build';
    } catch (_) {
      return 'Version unavailable';
    }
  }

  Future<void> _showTutorialIfNeeded() async {
    if (!mounted || !authProvider.isAuthenticated) return;

    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool(_tutorialSeenKey) ?? false;
    if (hasSeen || !mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Welcome to Arts & Culture at BJU'),
          content: const Text(
            'Thanks for installing the Arts & Culture at BJU app.\n\n'
            '• Attendance: Track your event attendance progress.\n'
            '• Calendar: View upcoming arts and culture events.\n'
            '• Scan QR: Check in quickly at events.\n'
            '• Links: Open important BJU School of Fine Arts & Communication resources from the left menu.',
          ),
          actions: [
            _dialogOkButton(
              dialogContext,
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );

    await prefs.setBool(_tutorialSeenKey, true);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authProvider,
      builder: (context, _) {
        final isAuthenticated = authProvider.isAuthenticated;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  homeTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  width: 140,
                  child: TextButton(
                    onPressed: () => launchURL(faCommURL),
                    child: Image.asset(
                      Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? musicLogo
                          : musicDarkLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        linkBankTitle,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  _drawerLinkTile(
                    context,
                    label: faCommLink,
                    url: faCommURL,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  _drawerLinkTile(
                    context,
                    label: showpassLink,
                    url: showpassURL,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  _drawerLinkTile(
                    context,
                    label: giveLink,
                    url: giveURL,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  _drawerLinkTile(
                    context,
                    label: visitLink,
                    url: visitURL,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const Spacer(),
                  ListTile(
                    leading: Icon(
                      Icons.feedback,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    title: const Text(feedbackButton),
                    textColor: Theme.of(context).textTheme.titleMedium?.color,
                    iconColor: Theme.of(context).textTheme.titleMedium?.color,
                    onTap: () => launchURL(feedbackURL),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    title: const Text(aboutButton),
                    textColor: Theme.of(context).textTheme.titleMedium?.color,
                    iconColor: Theme.of(context).textTheme.titleMedium?.color,
                    onTap: () => _showAboutDialog(),
                  ),
                  const Divider(height: 1),
                  if (isAuthenticated)
                    ListTile(
                      leading: const Icon(Icons.logout, color: brandRedAccent),
                      title: const Text(logoutButton),
                      textColor: brandRedAccent,
                      iconColor: brandRedAccent,
                      onTap: () => authProvider.logout(),
                    )
                  else
                    ListTile(
                      leading: Icon(
                        Icons.login,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                      title: const Text(guestLogin),
                      onTap: () async {
                        Navigator.of(context).pop();
                        final success = await authProvider.login();
                        if (!success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(loginFailure)),
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(homeBkrndImageLoc),
                fit: BoxFit.cover,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    brandDarkBlue.withValues(alpha: 0.18),
                    brandDarkBlue.withValues(alpha: 0.34),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Guest notice banner
                  if (!isAuthenticated)
                    Container(
                      width: double.infinity,
                      color: brandDarkBlue.withValues(alpha: 0.85),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              guestNotice,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final success = await authProvider.login();
                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text(loginFailure)),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  AnnouncementBanner(key: _announcementKey),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      24,
                                      36,
                                      24,
                                      16,
                                    ),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 440,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          20,
                                          20,
                                          20,
                                          16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withValues(alpha: 0.7),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x24000000),
                                              blurRadius: 20,
                                              offset: Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              homeWidgetText1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.onPrimary,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              homeWidgetText3,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryFixed,
                                                    height: 1.35,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(height: 16),
                                            Divider(
                                              height: 1,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSecondary,
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              homeWidgetText3,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.onSecondary,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            FutureBuilder<List<Event>>(
                                              future: _futureEvents,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 10,
                                                        ),
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                }
                                                if (snapshot.hasError) {
                                                  return Text(
                                                    homeWidgetEventError,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .onSecondaryFixed,
                                                        ),
                                                  );
                                                }
                                                final now = DateTime.now();
                                                final events =
                                                    (snapshot.data ?? [])
                                                        .where((event) {
                                                          final d =
                                                              DateTime.tryParse(
                                                                event.eventDate,
                                                              );
                                                          return d != null &&
                                                              !DateTime(
                                                                d.year,
                                                                d.month,
                                                                d.day,
                                                              ).isBefore(
                                                                DateTime(
                                                                  now.year,
                                                                  now.month,
                                                                  now.day,
                                                                ),
                                                              );
                                                        })
                                                        .take(3)
                                                        .toList();
                                                if (events.isEmpty) {
                                                  return Text(
                                                    'No upcoming events found.',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: brandBlueGray,
                                                        ),
                                                  );
                                                }
                                                return Column(
                                                  children: events
                                                      .map(
                                                        (
                                                          e,
                                                        ) => _upcomingEventRow(
                                                          context,
                                                          e,
                                                          _locallyReadEventIds,
                                                          _handleEventViewed,
                                                        ),
                                                      )
                                                      .toList(),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: SizedBox(
                height: 108,
                child: Row(
                  children: [
                    footerButton(
                      context,
                      onPressed: () async {
                        await context.push(myClassesScreenPath);
                        _handleRefresh();
                      },
                      text: myClassesButton,
                      icon: Icons.school_outlined,
                    ),
                    footerButton(
                      context,
                      onPressed: () async {
                        await context.push(calendarScreenPath);
                        _handleRefresh();
                      },
                      text: calendarButton,
                      icon: Icons.calendar_month_outlined,
                    ),
                    footerButton(
                      context,
                      onPressed: () => context.push(qrScannerPath),
                      text: scanQRText,
                      icon: Icons.qr_code_scanner,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAboutDialog() async {
    if (!mounted) return;

    final theme = Theme.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(aboutDialogTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  aboutAppName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(aboutPurpose),
                const SizedBox(height: 12),
                Text(
                  aboutDevelopersTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      ..._textHiddenButtonList(context, aboutDevelopers, (
                        context,
                        name,
                      ) {
                        showConfettiColor(context, aboutDevColors[name]!);
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  aboutBackendTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                ...aboutBackend.map((name) => Text(name)),
                const SizedBox(height: 12),
                Text(
                  aboutFacultyAdvisorTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      ..._textHiddenButtonList(context, aboutFacultyAdvisors, (
                        context,
                        _,
                      ) {
                        showFireworksConfetti(context);
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  aboutSponsorsTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                ...aboutFineArtsCommSponsors.map((name) => Text(name)),
                const SizedBox(height: 12),
                Text(
                  aboutGraphicDesignTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                ...aboutGraphicDesigners.map((name) => Text(name)),
                const SizedBox(height: 12),
                Text('$aboutSupportLabel: $aboutSupportValue'),
                const SizedBox(height: 8),
                FutureBuilder<String>(
                  future: _aboutVersionFuture,
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? 'Version',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  aboutCopyright,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            _dialogOkButton(
              dialogContext,
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }
}

Iterable<TextSpan> _textHiddenButtonList(
  BuildContext context,
  List<String> list,
  Function(BuildContext, String) confettiFoo,
) {
  return list.expandIndexed((index, name) {
    if (index == list.length - 1) {
      return [
        TextSpan(
          text: name,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              confettiFoo(context, name);
            },
        ),
      ];
    } else {
      return [
        TextSpan(
          text: name,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              confettiFoo(context, name);
            },
        ),
        TextSpan(text: ', '),
      ];
    }
  });
}

Widget _dialogOkButton(
  BuildContext context, {
  required VoidCallback onPressed,
}) {
  return FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: brandDarkBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: const Text('OK'),
  );
}

Widget _drawerLinkTile(
  BuildContext context, {
  required String label,
  required String url,
  required Color color,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => launchURL(url),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: brandDarkBlue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSecondary,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}

Widget footerButton(
  BuildContext context, {
  required VoidCallback onPressed,
  required String text,
  required IconData icon,
  bool isPrimary = false,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          backgroundColor: isPrimary
              ? brandDarkBlue
              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isPrimary
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isPrimary
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _upcomingEventRow(
  BuildContext context,
  Event event,
  Set<String> readEventIds,
  Function(String) onEventViewed,
) {
  final parsedDate = DateTime.tryParse(event.eventDate);
  final dateText = parsedDate != null
      ? DateFormat('EEE, MMM d').format(parsedDate)
      : 'Date TBD';

  String timeText = 'Time TBD';
  try {
    timeText = DateFormat(
      'h:mm a',
    ).format(DateFormat('HH:mm:ss').parse(event.eventTime));
  } catch (_) {}

  final isUnread =
      event.isRecentlyUpdated && !readEventIds.contains(event.eventId);

  return ListTile(
    contentPadding: EdgeInsets.zero,
    visualDensity: VisualDensity.compact,
    minVerticalPadding: 0,
    dense: true,
    onTap: () async {
      await context.push("/events/${event.eventId}");
      if (isUnread) {
        onEventViewed(event.eventId);
      }
    },
    title: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: brandBrown.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.event,
              size: 18,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.eventName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "UPDATED",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$dateText • $timeText',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryFixed,
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

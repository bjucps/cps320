import 'package:arts_and_culture/api/api_service.dart';
import 'package:arts_and_culture/api/get_events.dart';
import 'package:arts_and_culture/components/event_list.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:arts_and_culture/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:arts_and_culture/api/local_favorites.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final api = ApiService();
  Set<String> _favoriteEventIds = {};

  final Set<String> _locallyReadEventIds = {};

  final Set<String> _loadingMonths = {};
  final Map<String, Map<DateTime, List<Event>>> _monthEventCache = {};

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? _lastLoadedMonth;
  String _monthKey(DateTime d) => "${d.year}-${d.month}";

  // only cache 3 months at a time (previous, current, next)
  Set<String> _getAllowedMonths() {
    final center = DateTime(_focusedDay.year, _focusedDay.month);

    final prev = DateTime(center.year, center.month - 1);
    final next = DateTime(center.year, center.month + 1);

    return {_monthKey(prev), _monthKey(center), _monthKey(next)};
  }

  void _onMonthChanged(DateTime focusedDay) {
    final newKey = _monthKey(focusedDay);

    _focusedDay = focusedDay;

    if (_lastLoadedMonth == newKey) return;
    _lastLoadedMonth = newKey;

    _loadEvents(focusedDay);
  }

  void _loadEvents(DateTime focusedDay) {
    final center = DateTime(focusedDay.year, focusedDay.month, 1);

    // get current month events first
    _fetchMonth(center);

    // load adjacent months asynchronously
    Future.microtask(() {
      _fetchMonth(DateTime(center.year, center.month - 1));
      _fetchMonth(DateTime(center.year, center.month + 1));
    });
  }

  void _fetchMonth(DateTime date) {
    final key = _monthKey(date);

    if (_loadingMonths.contains(key)) return;
    if (_monthEventCache.containsKey(key)) return;

    _loadingMonths.add(key);

    getEventsList(date.month, date.year)
        .then((list) {
          _loadingMonths.remove(key);
          if (!_getAllowedMonths().contains(key)) return;
          _setMonthEvents(key, list);
        })
        .catchError((_) {
          _loadingMonths.remove(key);
        });
  }

  void _setMonthEvents(String monthKey, List<Event> list) {
    final map = <DateTime, List<Event>>{};

    for (final event in list) {
      final day = DateTime(event.date.year, event.date.month, event.date.day);
      map.putIfAbsent(day, () => []);
      map[day]!.add(event);
    }

    setState(() {
      _monthEventCache[monthKey] = map;

      final allowed = _getAllowedMonths();

      // enforce strict 3-month rolling window
      _monthEventCache.removeWhere((key, _) => !allowed.contains(key));
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    final monthKey = _monthKey(day);
    final dayKey = DateTime(day.year, day.month, day.day);

    return _monthEventCache[monthKey]?[dayKey] ?? [];
  }

  final localFavorites = LocalFavorites();

  @override
  void initState() {
    super.initState();

    loadFavorites();

    _loadEvents(_focusedDay);
  }

  void loadFavorites() async {
    try {
      final favs = await api.getFavorites(); // logged in
      setState(() {
        _favoriteEventIds = favs;
      });
    } catch (e) {
      final favs = await localFavorites.getFavorites(); // fallback
      setState(() {
        _favoriteEventIds = favs;
      });
    }
  }

  void _toggleFavorite(String eventId) async {
    final wasFavorited = _favoriteEventIds.contains(eventId);

    setState(() {
      if (wasFavorited) {
        _favoriteEventIds.remove(eventId);
      } else {
        _favoriteEventIds.add(eventId);
      }
    });

    try {
      final isFavorited = await api.toggleFavorite(eventId);

      setState(() {
        if (isFavorited) {
          _favoriteEventIds.add(eventId);
        } else {
          _favoriteEventIds.remove(eventId);
        }
      });
    } catch (e) {
      await localFavorites.saveFavorites((_favoriteEventIds));
    }
  }

  void _handleEventViewed(String eventId) {
    setState(() {
      _locallyReadEventIds.add(eventId);
    });
  }

  Future<void> _handleRefresh() async {
    if (authProvider.isAuthenticated) {
      api.markEventsAsRead().catchError((_) {});
    }

    setState(() {
      _locallyReadEventIds.clear();
      _monthEventCache.clear();
    });
    _loadEvents(_focusedDay);
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(eventCalendarTitle)),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondaryFixed,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return const SizedBox.shrink();

                return Positioned(
                  bottom: 6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: events.take(4).map((e) {
                      final event = e as Event;
                      
                      // An event is "New" if the server flagged it AND we haven't clicked it yet
                      final isNew = event.isRecentlyUpdated && 
                          !_locallyReadEventIds.contains(event.eventId);

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isNew 
                              ? Colors.orangeAccent // Bright color for unread
                              : Theme.of(context).colorScheme.onPrimary,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            onPageChanged: _onMonthChanged,
            eventLoader: (day) {
              final monthKey = _monthKey(day);
              final dayKey = DateTime(day.year, day.month, day.day);

              final month = _monthEventCache[monthKey];
              return month?[dayKey] ?? [];
            },
          ),
          SizedBox(height: 12),
          Expanded(
            child: EventList(
              events: _getEventsForDay(_selectedDay),
              favoriteEventIds: _favoriteEventIds,
              readEventIds: _locallyReadEventIds,
              onToggleFavorite: _toggleFavorite,
              onEventViewed: _handleEventViewed,
              onRefresh: _handleRefresh,
            ),
          ),
        ],
      ),
    );
  }
}
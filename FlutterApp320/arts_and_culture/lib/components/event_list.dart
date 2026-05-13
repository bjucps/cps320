import 'package:arts_and_culture/api/get_events.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventList extends StatelessWidget {
  final List<Event> events;
  final Set<String> favoriteEventIds;
  final Set<String> readEventIds;
  final Function(String) onToggleFavorite;
  final Function(String) onEventViewed;

  final Future<void> Function()? onRefresh;

  const EventList({
    super.key,
    required this.events,
    required this.favoriteEventIds,
    required this.readEventIds,
    required this.onToggleFavorite,
    required this.onEventViewed,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text(
          "No events for this day.",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          String formattedTime;
          try {
            formattedTime = DateFormat(
              'h:mm a',
            ).format(DateFormat("HH:mm:ss").parse(event.eventTime));
          } catch (_) {
            formattedTime = "Time TBD";
          }

          final parsedDate = DateTime.tryParse(event.eventDate);
          final formattedDate = parsedDate != null
              ? DateFormat('E, MMMM d').format(parsedDate)
              : "Date TBD";

          final isUnread = event.isRecentlyUpdated && !readEventIds.contains(event.eventId);

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () async {
                await context.push("/events/${event.eventId}");
                
                if (isUnread) {
                  onEventViewed(event.eventId);
                }
              },
              contentPadding: const EdgeInsets.all(16),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      event.eventName,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (isUnread)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "UPDATED",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "$formattedTime • $formattedDate\n${event.eventLocation}",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  favoriteEventIds.contains(event.eventId)
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => onToggleFavorite(event.eventId),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

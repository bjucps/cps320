import 'package:arts_and_culture/api/get_events.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Future<Event> _futureEvent;

  @override
  void initState() {
    super.initState();
    _futureEvent = getEventDetails(widget.eventId);
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(eventDetailsTitle), centerTitle: true),
      body: FutureBuilder<Event>(
        future: _futureEvent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Error loading event:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Event not found."));
          }

          final event = snapshot.data!;

          String formattedTime;
          try {
            formattedTime = DateFormat(
              'h:mm a',
            ).format(DateFormat("HH:mm:ss").parse(event.eventTime));
          } catch (e) {
            formattedTime = "Time TBD";
          }

          DateTime? parsedDate = DateTime.tryParse(event.eventDate);
          final formattedDate = parsedDate != null
              ? DateFormat('E, MMMM d').format(parsedDate)
              : "Date TBD";

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Event Header Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.eventName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _infoRow(Icons.calendar_month, "Date", formattedDate),
                      _infoRow(Icons.access_time, "Time", formattedTime),
                      _infoRow(
                        Icons.location_on,
                        "Location",
                        event.eventLocation,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Pamphlets Section
              _sectionTitle(context, pamphletTitle),

              if (event.eventPamphlets.isEmpty && !event.useUploadedPamphlet)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            noPamphletsText,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (!event.useUploadedPamphlet)
                Column(
                  children: event.eventPamphlets.map((pamphletId) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.picture_as_pdf),
                          title: Text(
                            viewPamphletButtonText,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.push(
                              "/events/${event.eventId}/$pamphletId",
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.picture_as_pdf),
                          title: Text(
                            viewPamphletButtonText,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.push(
                              "/events/${event.eventId}/pamphlet_pdf/${event.uploadedPamphlet}",
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
